# ---------- Etapa 1: Build ----------
FROM debian:bookworm-slim AS build-env

# Evitar prompts interativos
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependências necessárias
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl unzip xz-utils zip ca-certificates libglu1-mesa \
 && rm -rf /var/lib/apt/lists/*

# Clonar e instalar Flutter (versão 3.35.4)
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter \
    && cd /usr/local/flutter \
    && git checkout 3.35.4

# Adicionar Flutter ao PATH
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Pré-configurar Flutter e baixar SDK Web
RUN flutter config --enable-web && flutter precache --web

# Definir diretório de trabalho
WORKDIR /app

# Copiar apenas arquivos de dependências primeiro (melhor cache)
COPY pubspec.* ./

# Instalar dependências
RUN flutter pub get

# Copiar todo o restante do código
COPY . .

# Corrigir permissões (resolve erro do local.properties)
RUN chmod -R a+w /app

# Gerar build otimizado de produção
RUN flutter build web --release

# ---------- Etapa 2: Servidor ----------
FROM nginx:stable-alpine

# Copiar build gerado para o diretório padrão do Nginx
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Copiar configuração customizada do nginx como template
COPY nginx.conf /etc/nginx/templates/default.conf.template

# Expor a porta padrão do Nginx
EXPOSE 80

# Script para substituir $PORT no nginx e iniciar
CMD /bin/sh -c "envsubst '\$PORT' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"
