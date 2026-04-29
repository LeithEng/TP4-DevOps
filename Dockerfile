# Étape 1 : Build
FROM node:18-alpine AS builder
WORKDIR /app
COPY app/package*.json ./
RUN npm install --production
COPY app/src ./src

# Étape 2 : Image finale (minimale)
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app ./
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -qO- http://localhost:3000/health || exit 1
USER node
CMD ["node", "src/index.js"]