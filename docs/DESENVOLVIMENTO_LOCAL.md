# 💻 Desenvolvimento Local

## 📋 Pré-requisitos

- [FVM (Flutter Version Management)](https://fvm.app/) instalado
- Git configurado

## 🚀 Setup Inicial

```bash
# 1. Clonar o repositório
git clone <repository-url>
cd medgo

# 2. Instalar versão específica do Flutter via FVM
fvm use 3.35.4

# 3. Instalar dependências
fvm flutter pub get

# 4. Verificar configuração
fvm flutter doctor
```

## 🏃 Executar o Projeto

### Web (Desenvolvimento)
```bash
fvm flutter run -d chrome
# ou
fvm flutter run -d web-server --web-port 3000
```

### Web (Build de Produção)
```bash
fvm flutter build web --release
```

### Android
```bash
fvm flutter run -d <device-id>
```

### iOS
```bash
fvm flutter run -d <device-id>
```

## 🔧 Comandos Úteis

### Análise de código
```bash
fvm flutter analyze
```

### Formatar código
```bash
fvm flutter format .
```

### Testes
```bash
fvm flutter test
```

### Limpar build
```bash
fvm flutter clean
```

### Listar dispositivos
```bash
fvm flutter devices
```

## 📦 Gerenciar Dependências

### Adicionar pacote
```bash
fvm flutter pub add <package_name>
```

### Atualizar dependências
```bash
fvm flutter pub upgrade
```

### Ver pacotes desatualizados
```bash
fvm flutter pub outdated
```

## 🌐 Deploy

### Vercel (Produção)
```bash
# 1. Build local
fvm flutter build web --release

# 2. Commit e push
git add build/web pubspec.yaml
git commit -m "build: Atualiza build web"
git push origin main

# Vercel faz deploy automático
```

## 🔍 Debug

### Hot Reload
Durante o desenvolvimento, use `r` no terminal para hot reload.

### Hot Restart
Use `R` (maiúsculo) para hot restart.

### DevTools
```bash
fvm flutter pub global activate devtools
fvm flutter pub global run devtools
```

## 📁 Estrutura do Projeto

```
lib/
├── data/          # Modelos, repositórios, providers
├── helper/        # Utilitários e constantes
├── pages/         # Telas da aplicação
├── strings/       # Textos e APIs
├── themes/        # Tema e estilos
├── widgets/       # Componentes reutilizáveis
└── main.dart      # Ponto de entrada
```

## ⚙️ Configuração do FVM

O projeto usa FVM para gerenciar a versão do Flutter. As configurações estão em:
- `.fvm/fvm_config.json` - Versão do Flutter
- `.vscode/settings.json` - Integração com VS Code

## 🆘 Problemas Comuns

### Erro: Flutter not found
```bash
# Certifique-se de usar fvm antes dos comandos
fvm flutter <command>
```

### Erro: SDK version mismatch
```bash
# Reinstale a versão correta
fvm use 3.35.4 --force
fvm flutter pub get
```

### Erro: Web not enabled
```bash
fvm flutter config --enable-web
```

## 🔗 Links Úteis

- [Documentação Flutter](https://docs.flutter.dev/)
- [FVM Documentation](https://fvm.app/)
- [Pub.dev](https://pub.dev/) - Pacotes Flutter
