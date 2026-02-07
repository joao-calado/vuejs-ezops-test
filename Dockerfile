# --- Estágio 1: Build ---
# Usando Node 14 (compatível com o backend e boilerplate antigo)
FROM node:14-alpine AS build-stage

WORKDIR /app

# Instala dependências
COPY package*.json ./
RUN npm install

# Copia código fonte e gera o build de produção
COPY . .
RUN npm run build

# --- Estágio 2: Production/Local Run ---
# Usando Nginx para servir os arquivos estáticos gerados
FROM nginx:alpine AS production-stage

# Copia os arquivos gerados no estágio anterior (pasta /dist) para o Nginx
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Expõe a porta 80 do container
EXPOSE 80

# Roda o Nginx em primeiro plano
CMD ["nginx", "-g", "daemon off;"]