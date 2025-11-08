import 'package:medgo/env.dart';
import '../../strings/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> postLogout() async {
  http.Client httpClient = http.Client();
  String url = Env.apiURL + API.logout;
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String userToken = await getUserToken();

  final http.Response response = await httpClient.post(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $userToken',
    },
  ).timeout(
    const Duration(seconds: 12),
  );

  if (response.statusCode >= 204 && response.statusCode <= 299) {
    preferences.clear();
  }

  return;
}

getUserToken() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String stringValue = preferences.getString('userToken') ?? '';
  return stringValue;
}
