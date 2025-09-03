#!/bin/bash

echo "🚀 Starting API Benchmark POC..."

# Start TypeScript API
echo "Starting TypeScript API..."
cd ts-api
npm install
npm run dev &
TS_PID=$!

# Start Rust API  
echo "Starting Rust API..."
cd ../rust-api
cargo build --release
cargo run --release &
RUST_PID=$!

# Start Frontend
echo "Starting Frontend..."
cd ../frontend
npm install
npm run dev &
FRONTEND_PID=$!

echo "✅ All services started!"
echo ""
echo "📍 Access points:"
echo "   - Frontend: http://localhost:3005"
echo "   - TypeScript API: http://localhost:8080"
echo "   - Rust API: http://localhost:8081"
echo ""
echo "Press Ctrl+C to stop all services..."

# Wait for interrupt
trap "kill $TS_PID $RUST_PID $FRONTEND_PID; exit" INT
wait