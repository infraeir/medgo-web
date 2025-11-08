import 'package:medgo/helper/constants.dart';

class Env {
  //Chaves de ambiente
  static final Map<String, String> _keys = {
    Constants.apiUrl: Constants.apiUrl,
    Constants.socketUrl: Constants.socketUrl,
  };

  static String _getKey(String key) {
    if (!_keys.containsKey(key)) {
      throw Exception('Env key $key not found');
    }

    return _keys[key]!;
  }

  static String get apiURL => _getKey(Constants.apiUrl);
  static String get socketURL => _getKey(Constants.socketUrl);
}
