import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:medgo/data/providers/auth_interceptor_service.dart';
import 'package:medgo/env.dart';
import 'package:medgo/helper/helper.dart';
import 'package:medgo/data/models/patiens_pagination_model.dart';
import 'package:medgo/data/models/patients_model.dart';
import 'package:medgo/strings/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientsProvider {
  final http.Client httpClient;
  late final AuthInterceptor _authInterceptor;

  PatientsProvider({
    required this.httpClient,
  }) {
    _authInterceptor = AuthInterceptor(httpClient: httpClient);
  }

  Future<PatientsPaginationModel> getPatients({
    required int currentPage,
    required String search,
  }) async {
    String url =
        '${Env.apiURL}patients?limit=${20}&page=$currentPage&sort=name&order=asc';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    if (search.length >= 3) {
      url = '$url&search=$search';
    }

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
    };

    final response = await _authInterceptor.sendRequest(() => httpClient
        .get(
          Uri.parse(url),
          headers: headers,
        )
        .timeout(
          const Duration(seconds: 12),
        ));

    var result = jsonDecode(response.body);

    if (Helper.verificaStatusCode(statusCode: response.statusCode)) {
      late final List<PatientsModel> patients = [];

      for (var item in result["data"]) {
        patients.add(
          PatientsModel.fromMap(map: item),
        );
      }

      return PatientsPaginationModel(
        patients: patients,
        limit: result["limit"],
        page: result["page"],
        totalPages: result["totalPages"],
        total: result["total"],
      );
    } else {
      throw Exception(result['message']);
    }
  }

  Future<PatientsModel> getPatientById({
    required String id,
  }) async {
    String url = '${Env.apiURL}patients/$id';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
    };

    final response = await _authInterceptor.sendRequest(() => httpClient
        .get(
          Uri.parse(url),
          headers: headers,
        )
        .timeout(
          const Duration(seconds: 12),
        ));

    var result = jsonDecode(response.body);

    if (Helper.verificaStatusCode(statusCode: response.statusCode)) {
      return PatientsModel.fromMap(map: result);
    } else {
      throw Exception(result['message']);
    }
  }

  Future<String> postPatients({
    required String nome,
    required String dataNasc,
    required String sexo,
    required String cor,
    required String? nomeMae,
    required String? nomePai,
  }) async {
    String url = '${Env.apiURL}patients';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
    };

    final Map<String, dynamic> body = {
      "name": nome,
      "gender": sexo,
      "dateOfBirth": dataNasc,
      "ethnicity": cor,
      "motherName": nomeMae,
      "fatherName": nomePai,
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
      return "Paciente registrado com sucesso";
    } else {
      throw Exception(result['message']);
    }
  }

  Future<String> putPatients({
    required String id,
    required String nome,
    required String dataNasc,
    required String sexo,
    required String cor,
    required String nomeMae,
    required String nomePai,
  }) async {
    String url = '${Env.apiURL}patients/$id';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
    };

    final Map<String, dynamic> body = {
      "name": nome,
      "gender": sexo,
      "dateOfBirth": dataNasc,
      "ethnicity": cor,
      "motherName": nomeMae,
      "fatherName": nomePai,
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
      return "Paciente editado com sucesso";
    } else {
      throw Exception(result['message']);
    }
  }

  Future<String> deletePatient({
    required String id,
  }) async {
    String url = '${Env.apiURL}patients/$id';
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

    if (Helper.verificaStatusCode(statusCode: response.statusCode)) {
      return "Paciente deletado com sucesso";
    } else {
      throw Exception('Erro ao deletar paciente');
    }
  }
}
