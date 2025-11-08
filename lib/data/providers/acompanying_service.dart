import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:medgo/data/providers/auth_interceptor_service.dart';
import 'package:medgo/env.dart';
import 'package:medgo/helper/helper.dart';
import 'package:medgo/data/models/companion_model.dart';
import 'package:medgo/strings/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanionProvider {
  final http.Client httpClient;
  late final AuthInterceptor _authInterceptor;

  CompanionProvider({
    required this.httpClient,
  }) {
    _authInterceptor = AuthInterceptor(httpClient: httpClient);
  }

  Future<String> postCompanion({
    required String idPatient,
    required String name,
    required String gender,
    required String relationship,
    required String relationshipAddInfo,
  }) async {
    String url = '${Env.apiURL}patients/$idPatient/companions';

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
    };

    final Map<String, dynamic> body = {
      "name": name,
      "gender": gender,
      "relationship": relationship,
      "relationshipAddInfo": relationshipAddInfo,
    };

    final response = await _authInterceptor.sendRequest(() => httpClient
        .post(
          Uri.parse(url),
          headers: headers,
          body: json.encode(body),
        )
        .timeout(
          const Duration(seconds: 12),
        ));

    var result = jsonDecode(response.body);

    if (Helper.verificaStatusCode(statusCode: response.statusCode)) {
      return "Acompanhante registrado com sucesso";
    } else {
      throw Exception(result['message']);
    }
  }

  Future<List<CompanionModel>> postExtraCompanion({
    required String consultationsID,
    required String name,
    required String gender,
    required String relationship,
    required String relationshipAddInfo,
  }) async {
    String url = '${Env.apiURL}consultations/$consultationsID/companion';

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
    };

    final Map<String, dynamic> body = {
      "name": name,
      "gender": gender,
      "relationship": relationship,
      "relationshipAddInfo": relationshipAddInfo,
    };

    final response = await _authInterceptor.sendRequest(() => httpClient
        .patch(
          Uri.parse(url),
          headers: headers,
          body: json.encode(body),
        )
        .timeout(
          const Duration(seconds: 12),
        ));

    var result = jsonDecode(response.body);
    List<CompanionModel> companions = [];

    if (result is List) {
      companions =
          result.map((item) => CompanionModel.fromMap(map: item)).toList();
    }

    if (Helper.verificaStatusCode(statusCode: response.statusCode)) {
      return companions;
    } else {
      throw Exception(result['message']);
    }
  }

  Future<String> patchExtraCompanion({
    required String consultationsID,
    required String companionID,
  }) async {
    String url =
        '${Env.apiURL}consultations/$consultationsID/companion/$companionID';

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
    };

    final response = await _authInterceptor.sendRequest(() => httpClient
        .patch(
          Uri.parse(url),
          headers: headers,
        )
        .timeout(
          const Duration(seconds: 12),
        ));

    var result = jsonDecode(response.body);

    if (Helper.verificaStatusCode(statusCode: response.statusCode)) {
      return result['message'];
    } else {
      throw Exception(result['message']);
    }
  }

  Future<String> deleteExtraCompanion({
    required String consultationsID,
    required String companionID,
  }) async {
    String url =
        '${Env.apiURL}consultations/$consultationsID/companion/$companionID';

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
    };

    final response = await _authInterceptor.sendRequest(() => httpClient
        .delete(
          Uri.parse(url),
          headers: headers,
        )
        .timeout(
          const Duration(seconds: 12),
        ));

    var result = jsonDecode(response.body);

    if (Helper.verificaStatusCode(statusCode: response.statusCode)) {
      return result['message'];
    } else {
      throw Exception(result['message']);
    }
  }

  Future<String> putCompanion({
    required String idCompanion,
    required String idPatient,
    required String name,
    required String gender,
    required String relationship,
    required String relationshipAddInfo,
  }) async {
    String url = '${Env.apiURL}patients/$idPatient/companions/$idCompanion';

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
    };

    final Map<String, dynamic> body = {
      "name": name,
      "gender": gender,
      "relationship": relationship,
      "relationshipAddInfo": relationshipAddInfo,
    };

    final response = await _authInterceptor.sendRequest(() => httpClient
        .patch(
          Uri.parse(url),
          headers: headers,
          body: json.encode(body),
        )
        .timeout(
          const Duration(seconds: 12),
        ));

    var result = jsonDecode(response.body);

    if (Helper.verificaStatusCode(statusCode: response.statusCode)) {
      return "Acompanhante editado com sucesso";
    } else {
      throw Exception(result['message']);
    }
  }

  Future<String> deleteCompanion({
    required String idCompanion,
  }) async {
    String url = '${Env.apiURL}companions/$idCompanion';

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    final response = await _authInterceptor.sendRequest(() => httpClient
        .delete(
          Uri.parse(url),
          headers: headers,
        )
        .timeout(
          const Duration(seconds: 12),
        ));

    if (Helper.verificaStatusCode(statusCode: response.statusCode)) {
      return "Acompanhante deletado com sucesso";
    } else {
      throw Exception('Erro ao deletar acompanhante');
    }
  }
}
