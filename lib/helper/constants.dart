import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static String get apiUrl => dotenv.env['API_URL'] ?? ' https://api-testing.medgo.tec.br/v1/';
  static String get socketUrl => dotenv.env['SOCKET_URL'] ?? ' https://api-testing.medgo.tec.br/';
}
