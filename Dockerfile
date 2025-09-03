# This Dockerfile is designed to work with Railway's root directory configuration
# It detects whether we're building from root (frontend) or a service directory

FROM node:20-alpine AS builder

WORKDIR /app

# Copy all files
COPY . .

# Check if we're in a service directory or root and build accordingly
RUN if [ -f "package.json" ] && [ -d "../frontend" ]; then \
      echo "Building from service directory but targeting frontend" && \
      cd ../frontend && \
      npm ci && \
      npm run build; \
    elif [ -f "package.json" ]; then \
      echo "Building from service directory" && \
      npm ci && \
      npm run build; \
    elif [ -d "frontend" ]; then \
      echo "Building from root - building frontend" && \
      cd frontend && \
      npm ci && \
      npm run build; \
    else \
      echo "ERROR: No package.json found and no frontend directory" && \
      exit 1; \
    fi

FROM node:20-alpine AS runner

WORKDIR /app

ENV NODE_ENV production

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copy built files - handle both service directory and frontend builds
RUN mkdir -p /tmp/check
COPY --from=builder /app/ /tmp/check/

# Copy the appropriate files based on build type
RUN if [ -d "/tmp/check/frontend/.next/standalone" ]; then \
      echo "Copying from frontend build" && \
      cp -r /tmp/check/frontend/public ./public && \
      cp -r /tmp/check/frontend/.next/standalone/* ./; \
    elif [ -f "/tmp/check/server.js" ] || [ -f "/tmp/check/index.js" ]; then \
      echo "Copying from service build" && \
      cp -r /tmp/check/* ./; \
    else \
      echo "ERROR: No valid build output found" && \
      ls -la /tmp/check/ && \
      exit 1; \
    fi

RUN rm -rf /tmp/check

USER nextjs

EXPOSE 3000

ENV PORT 3000

CMD ["node", "server.js"]