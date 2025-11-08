import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:medgo/env.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medgo/strings/api.dart';

class AuthInterceptor {
  final http.Client httpClient;

  AuthInterceptor({required this.httpClient});

  Future<http.Response> sendRequest(
    Future<http.Response> Function() request,
  ) async {
    try {
      // Primeira tentativa
      var response = await request();

      if (response.statusCode == 401) {
        // Tenta renovar o token
        final newToken = await _refreshToken();

        if (newToken != null) {
          // Atualiza o token nas SharedPreferences
          final preferences = await SharedPreferences.getInstance();
          await preferences.setString('userToken', newToken);

          // Espera um momento para garantir que o token foi atualizado
          await Future.delayed(const Duration(milliseconds: 100));

          // Refaz a requisição com o novo token
          final headers = {
            HttpHeaders.authorizationHeader: 'Bearer $newToken',
            HttpHeaders.contentTypeHeader: API.applicationJson,
          };

          // Extrai a URL original da primeira requisição
          final originalRequest = await request();
          final originalUrl = originalRequest.request?.url;

          // Faz uma nova requisição com o token atualizado
          final newResponse = await httpClient
              .get(
                originalUrl!,
                headers: headers,
              )
              .timeout(const Duration(seconds: 12));

          return newResponse;
        }
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> _refreshToken() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final refreshToken = preferences.getString('refreshToken') ?? '';

      final response = await httpClient.get(
        Uri.parse('${Env.apiURL}auth/doctors/refresh'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $refreshToken',
          HttpHeaders.contentTypeHeader: API.applicationJson,
        },
      ).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        // Atualiza os dois tokens
        await preferences.setString('userToken', result['accessToken']);
        await preferences.setString('refreshToken', result['refreshToken']);

        return result['accessToken'];
      }
      return null;
    } catch (e) {
      print('Erro ao atualizar token: $e');
      return null;
    }
  }
}
