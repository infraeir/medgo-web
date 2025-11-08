# 🚀 Deploy MedGo no Vercel

## ⚡ Deploy Simplificado (Recomendado)

O build do Flutter é feito **localmente** e o Vercel serve apenas os arquivos estáticos.
Isso é mais rápido, confiável e não depende do ambiente do Vercel.

### Passos:

```bash
# 1. Fazer build local
./build-local.sh

# 2. Commitar o build
git add build/web .gitignore vercel.json
git commit -m "build: Atualiza build web para deploy"
git push origin main

# 3. Vercel detecta automaticamente e faz deploy
```

## Opção 1: Deploy via Vercel Dashboard

1. Acesse [vercel.com](https://vercel.com)
2. Clique em "Add New Project"
3. Conecte seu repositório GitHub
4. Configure:
   - **Build Command**: `flutter build web --release`
   - **Output Directory**: `build/web`
   - **Install Command**: Deixe vazio (Vercel detecta Flutter)
5. Clique em "Deploy"

## Opção 2: Deploy via CLI

```bash
# 1. Instalar Vercel CLI
npm i -g vercel

# 2. Fazer build
flutter build web --release

# 3. Deploy
cd build/web
vercel --prod
```

## Opção 3: Deploy automático (CI/CD)

O deploy acontece automaticamente a cada push para `main` ou `develop`.

## ✅ Vantagens do Vercel

- ⚡ CDN global (milissegundos de latência)
- 🔒 HTTPS automático
- 🌍 Escala infinitamente
- 💰 100% gratuito
- 🔄 Deploy automático do Git
- 📊 Analytics integrado
- 🎯 Preview deploys para PRs

## 🔧 Configuração personalizada

O arquivo `vercel.json` já está configurado com:
- SPA routing (todas rotas → index.html)
- Otimizações de cache
- Headers de segurança

## 📱 Domínio customizado

Para usar seu domínio (dev.medgo.app.br):
1. Vá em Project Settings → Domains
2. Adicione seu domínio
3. Configure o DNS conforme instruções
