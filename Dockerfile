# --- Estágio 1: Build ---
FROM node:14-alpine AS build-stage

WORKDIR /app

# Recebe a URL do backend como argumento de build
ARG VUE_APP_API_URL
ENV VUE_APP_API_URL=$VUE_APP_API_URL

COPY package*.json ./
RUN npm install

COPY . .
# O build do Vue.js injeta as variáveis VUE_APP_* no bundle final
RUN npm run build

# --- Estágio 2: Production/Local Run ---
FROM nginx:alpine AS production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]