# MedGo

## Utilizamos o GitFlow para organização de nossas features


## Como rodar o projeto

- Abrir o Projeto em sua IDE de preferência, selecionar o device desejado para mobile no SO desejado.

### Padrão do projeto

- Clean Project

### Dependências usadas

- [HttpCLient](https://pub.dev/packages/http_client)
- [Lottie](https://pub.dev/packages/lottie)
- [Firebase](https://firebase.google.com/?hl=pt) -> Analytics, Crashlytics, Messaging, Remote Config e etc...
- [GetIt](https://pub.dev/packages/get_it)


### Configuração do Docker para deploy web com Nginx
docker build --network=host -t registry.heroku.com/medgo-app-testing/web .
docker push registry.heroku.com/medgo-app-testing/web
heroku container:release web -a medgo-app-testing
