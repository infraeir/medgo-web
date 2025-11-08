#!/bin/bash
set -e

# Versão do Flutter (mesma do Dockerfile)
FLUTTER_VERSION="3.35.4"

# Evitar warning de root
export FLUTTER_ROOT=$HOME/flutter
export PUB_CACHE=$HOME/.pub-cache

echo "📋 Informações do sistema:"
echo "   PWD: $(pwd)"
echo "   HOME: $HOME"
echo "   USER: $(whoami)"
echo ""

# Verificar se Flutter já está instalado
if [ ! -d "$HOME/flutter" ]; then
  echo "📦 Instalando Flutter..."
  git clone https://github.com/flutter/flutter.git $HOME/flutter
  cd $HOME/flutter
  echo "🔄 Checkout para versão ${FLUTTER_VERSION}..."
  git checkout $FLUTTER_VERSION
  cd -
fi

# Adicionar Flutter ao PATH
export PATH="$HOME/flutter/bin:$PATH"

# Verificar versão instalada
echo "🔍 Versão do Flutter:"
flutter --version

# Configurar Flutter
echo "⚙️ Configurando Flutter..."
flutter config --enable-web --no-analytics

# Habilitar suporte web no projeto (caso não esteja configurado)
echo "🌐 Habilitando suporte web..."
flutter create . --platforms web

# Instalar dependências
echo "📥 Instalando dependências..."
flutter pub get

# Limpar cache antigo
echo "🧹 Limpando cache..."
flutter clean

# Análise de código (para identificar erros)
echo "🔍 Analisando código..."
flutter analyze --no-fatal-infos || echo "⚠️  Análise com warnings, continuando..."

# Build web
echo "🏗️ Fazendo build..."
echo "⚠️  Isso pode levar alguns minutos..."
flutter build web --release --verbose

echo "✅ Build completo!"
