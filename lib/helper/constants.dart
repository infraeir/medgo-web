import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static String get apiUrl => dotenv.env['API_URL'] ?? 'fallback_value';
  static String get socketUrl => dotenv.env['SOCKET_URL'] ?? 'fallback_value';
}
