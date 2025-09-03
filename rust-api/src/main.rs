use axum::{
    extract::Json,
    http::StatusCode,
    response::IntoResponse,
    routing::{get, post},
    Router,
};
use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use std::time::Instant;
use tower_http::cors::CorsLayer;

#[derive(Debug, Deserialize)]
struct ProcessRequest {
    document_text: String,
}

#[derive(Debug, Serialize)]
struct ProcessResponse {
    status: String,
    complexity_score: String,
    document_hash: String,
    processed_by: String,
    processing_time_ms: f64,
}

fn process_document(text: &str) -> (String, String) {
    let word_count = text.split_whitespace().count();
    let complexity_score = if word_count > 50 {
        "complex".to_string()
    } else {
        "simple".to_string()
    };

    let mut hasher = Sha256::new();
    hasher.update(text.as_bytes());
    let result = hasher.finalize();
    let document_hash = hex::encode(result);

    (complexity_score, document_hash)
}

async fn process_endpoint(
    Json(payload): Json<ProcessRequest>,
) -> Result<impl IntoResponse, StatusCode> {
    let start = Instant::now();

    if payload.document_text.is_empty() {
        let processing_time_ms = start.elapsed().as_secs_f64() * 1000.0;
        return Ok(Json(ProcessResponse {
            status: "error".to_string(),
            complexity_score: "simple".to_string(),
            document_hash: String::new(),
            processed_by: "Rust API".to_string(),
            processing_time_ms,
        }));
    }

    let (complexity_score, document_hash) = process_document(&payload.document_text);
    let processing_time_ms = start.elapsed().as_secs_f64() * 1000.0;

    Ok(Json(ProcessResponse {
        status: "success".to_string(),
        complexity_score,
        document_hash,
        processed_by: "Rust API".to_string(),
        processing_time_ms,
    }))
}

async fn health_check() -> impl IntoResponse {
    Json(serde_json::json!({
        "status": "healthy",
        "api": "Rust"
    }))
}

#[tokio::main]
async fn main() {
    let app = Router::new()
        .route("/process", post(process_endpoint))
        .route("/health", get(health_check))
        .layer(CorsLayer::permissive());

    let listener = tokio::net::TcpListener::bind("0.0.0.0:8081")
        .await
        .unwrap();

    println!("Rust API listening on port 8081");

    axum::serve(listener, app).await.unwrap();
}