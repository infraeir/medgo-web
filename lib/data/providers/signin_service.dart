import 'dart:convert';
import 'dart:io';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:medgo/env.dart';
import '../../strings/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> postLogin(String email, String password) async {
  http.Client httpClient = http.Client();
  Uri url = Uri.parse(Env.apiURL + API.login);
  SharedPreferences preferences = await SharedPreferences.getInstance();

  var headers = {
    HttpHeaders.contentTypeHeader: API.contentTypeHeader,
  };

  final Map<String, dynamic> body = {
    API.emailHeaderName: email,
    API.passwordHeaderName: password,
  };

  http.Response response = await httpClient.post(
    url,
    headers: headers,
    body: json.encode(body),
  );

  print(jsonDecode(response.body));
  if (response.statusCode >= 200 && response.statusCode <= 299) {
    var result = jsonDecode(response.body);
    preferences.setString('userToken', '${result['accessToken']}');
    preferences.setString('refreshToken', '${result['refreshToken']}');
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(result['accessToken']);

    print(decodedToken["name"]);
    preferences.setString('nameUser', '${decodedToken["name"]}');
    preferences.setString(
        'registrationNumber', '${decodedToken["registrationNumber"]}');
    preferences.setString('emailUser', '${decodedToken["username"]}');

    return true;
  } else {
    print('******* ERROR ********');
    return false;
  }
}

Future<int> recoverPassword(String email) async {
  http.Client httpClient = http.Client();
  Uri url = Uri.parse(Env.apiURL + API.recoverPassword);

  var headers = {
    HttpHeaders.contentTypeHeader: API.contentTypeHeader,
  };

  final Map<String, dynamic> body = {
    API.emailHeaderName: email,
  };

  http.Response response = await httpClient.post(
    url,
    headers: headers,
    body: json.encode(body),
  );

  return response.statusCode;
}

class ResetPasswordResponse {
  final bool success;
  final String message;

  ResetPasswordResponse({required this.success, this.message = ''});
}

Future<ResetPasswordResponse> resetPassword(
  String token,
  String password,
) async {
  http.Client httpClient = http.Client();
  Uri url = Uri.parse(Env.apiURL + API.resetPassword);

  var headers = {
    HttpHeaders.contentTypeHeader: API.contentTypeHeader,
  };

  final Map<String, dynamic> body = {
    'token': token,
    'newPassword': password,
  };

  try {
    http.Response response = await httpClient.post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return ResetPasswordResponse(success: true);
    } else {
      var responseBody = json.decode(response.body);
      return ResetPasswordResponse(
        success: false,
        message:
            responseBody['message'] ?? 'Ocorreu um erro ao redefinir a senha',
      );
    }
  } catch (e) {
    return ResetPasswordResponse(
      success: false,
      message: 'Erro de conexão. Tente novamente mais tarde.',
    );
  }
}
