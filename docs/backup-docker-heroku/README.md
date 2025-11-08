# 📦 Backup - Docker, Heroku & CI/CD

Este diretório contém os arquivos de configuração antigos que não são mais usados no projeto.

## 🐳 Docker
- `Dockerfile` - Build multi-stage com Flutter e nginx
- `docker-compose.yml` - Orquestração de containers
- `nginx.conf` - Configuração do servidor nginx
- `.dockerignore` - Arquivos ignorados no build Docker
- `makefile` - Comandos para gerenciar containers

## 🚀 Heroku
- `heroku.yml` - Configuração para deploy via container
- `Procfile` - Comando de inicialização do Heroku
- `server.js` - Servidor Node.js/Express (alternativa ao nginx)
- `package.json.heroku-only` - Dependências Node.js para Heroku

## 🔄 CI/CD
- `.gitlab-ci.yml` - Pipeline GitLab CI/CD

## 📜 Scripts
- `build.sh` - Script de build para Vercel (tentativa)
- `build-local.sh` - Script para build local

## ⚠️ Por que não usar mais?

### Docker
- **Complexidade desnecessária** para Flutter Web
- Requer nginx/servidor apenas para servir arquivos estáticos
- Mais lento que CDN

### Heroku
- **Custo**: $7/mês vs gratuito (Vercel/Netlify)
- **Cold start**: App dorme após 30min
- **Sem CDN**: Performance inferior
- **Limitações**: Não ideal para SPA

### Solução atual: Vercel
- ✅ 100% gratuito
- ✅ CDN global
- ✅ Deploy automático
- ✅ Sem servidor necessário
- ✅ Build local + deploy de estáticos

## 📅 Data do backup
Novembro 2025

## 🔙 Para restaurar (se necessário)
```bash
cp backup-docker-heroku/* .
```
