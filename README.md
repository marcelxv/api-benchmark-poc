# API Benchmark POC: TypeScript vs Rust

Uma prova de conceito para comparar o desempenho de APIs implementadas em TypeScript (Node.js) e Rust, demonstrando visualmente a diferença de performance em cenários de alta concorrência e processamento intensivo.

## 🎯 Objetivo

Demonstrar de forma prática e visual a superioridade do Rust em termos de performance para APIs que lidam com processamento computacionalmente intensivo, através de um dashboard interativo que permite realizar benchmarks em tempo real.

## 🏗️ Arquitetura

O projeto consiste em três componentes principais:

1. **API TypeScript** - Implementada com Express.js
2. **API Rust** - Implementada com Axum
3. **Frontend** - Dashboard Next.js para visualização dos benchmarks

## 📋 Regra de Negócio

Ambas as APIs implementam o mesmo endpoint de validação de documentos:

- **Endpoint**: `POST /process`
- **Validações**:
  1. **Complexidade**: Conta palavras no texto (> 50 = "complexo")
  2. **Hash**: Gera SHA-256 do conteúdo

## 🚀 Como Executar

### Com Docker (Recomendado)

```bash
# Clone o repositório
git clone <seu-repositorio>
cd api-benchmark-poc

# Inicie todos os serviços
docker-compose up --build

# Acesse o dashboard
# http://localhost:3000
```

### Desenvolvimento Local

#### API TypeScript
```bash
cd ts-api
npm install
npm run dev
# API rodando em http://localhost:8080
```

#### API Rust
```bash
cd rust-api
cargo run
# API rodando em http://localhost:8081
```

#### Frontend
```bash
cd frontend
npm install
npm run dev
# Dashboard em http://localhost:3000
```

## 📊 Dashboard de Benchmark

O dashboard oferece três visualizações principais:

1. **Painel de Latência**: Compara o tempo de resposta individual
2. **Painel de Throughput**: Mostra requisições por segundo (100 requisições simultâneas)
3. **Painel de Resumo**: Exibe os JSONs de resposta detalhados

## 🔧 Configuração Docker

Ambas as APIs são configuradas com recursos idênticos para garantir um benchmark justo:
- CPU: 1.0 core
- Memória: 512MB

## 📈 Resultados Esperados

Em testes típicos, você deve observar:
- **Rust**: 2-5x mais rápido em latência individual
- **Rust**: 3-10x maior throughput em alta concorrência
- **Rust**: Uso mais eficiente de memória

## 🛠️ Tecnologias Utilizadas

- **TypeScript API**: Node.js, Express, TypeScript
- **Rust API**: Axum, Tokio, SHA2
- **Frontend**: Next.js, React, Recharts, Tailwind CSS
- **Infraestrutura**: Docker, Docker Compose

## 📝 Exemplo de Teste

1. Cole um texto longo (> 50 palavras) na textarea
2. Clique em "Benchmark com TypeScript" e "Benchmark com Rust"
3. Compare os tempos de processamento no gráfico de latência
4. Execute o "Teste de Throughput" para ver a diferença em alta concorrência
5. Observe as métricas detalhadas na tabela de desempenho

## 🔍 Observações

- Os tempos de processamento incluem apenas o processamento do servidor
- O teste de throughput executa 100 requisições simultâneas
- As configurações de Docker garantem recursos iguais para ambas as APIs