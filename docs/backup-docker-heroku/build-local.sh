#!/bin/bash
# Script para fazer build local e preparar para deploy no Vercel

echo "🏗️ Fazendo build Flutter Web localmente..."
echo "⚠️  Certifique-se de ter Flutter instalado localmente!"
echo ""

# Verificar se Flutter está instalado
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter não encontrado!"
    echo "   Instale Flutter: https://docs.flutter.dev/get-started/install"
    exit 1
fi

# Limpar build anterior
echo "🧹 Limpando build anterior..."
flutter clean

# Fazer build web
echo "🏗️ Building..."
flutter build web --release

# Verificar se build foi criado
if [ ! -d "build/web" ]; then
    echo "❌ Build falhou!"
    exit 1
fi

echo ""
echo "✅ Build completo!"
echo "📦 Arquivos em: build/web/"
echo ""
echo "🚀 Próximos passos:"
echo "   1. git add build/web .gitignore vercel.json"
echo "   2. git commit -m 'build: Adiciona build web para deploy'"
echo "   3. git push origin main"
echo ""
