import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:medgo/data/providers/auth_interceptor_service.dart';
import 'package:medgo/env.dart';
import 'package:medgo/helper/helper.dart';
import 'package:medgo/data/models/companion_model.dart';
import 'package:medgo/data/models/block_model.dart';
import 'package:medgo/data/models/consultation_model.dart';
import 'package:medgo/data/models/pregnancy_model.dart';
import 'package:medgo/data/models/patients_model.dart';
import 'package:medgo/strings/api.dart';
import 'package:medgo/strings/strings.dart';
import 'package:medgo/widgets/dynamic_form/form_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsultationProvider {
  final http.Client httpClient;
  late final AuthInterceptor _authInterceptor;

  ConsultationProvider({
    required this.httpClient,
  }) {
    _authInterceptor = AuthInterceptor(httpClient: httpClient);
  }

  Future<List<ConsultationModel>> getConsultations({
    required String idPatient,
  }) async {
    String url = '${Env.apiURL}patients/$idPatient/consultations';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
      Strings.xConsultationType: Strings.childcare,
    };

    final response = await _authInterceptor.sendRequest(() => httpClient
        .get(
          Uri.parse(url),
          headers: headers,
        )
        .timeout(
          const Duration(seconds: 12),
        ));

    if (Helper.verificaStatusCode(statusCode: response.statusCode)) {
      var result = jsonDecode(response.body);

      late final List<ConsultationModel> patients = [];

      for (var item in result["data"]) {
        patients.add(
          ConsultationModel.fromMap(map: item),
        );
      }

      return patients;
    } else {
      var result = jsonDecode(response.body);

      throw Exception(result['message']);
    }
  }

  Future<ConsultationModel> getConsultationById({
    required String idConsultation,
  }) async {
    String url = '${Env.apiURL}consultations/$idConsultation';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
      Strings.xConsultationType: Strings.childcare,
    };

    final response = await _authInterceptor.sendRequest(() => httpClient
        .get(
          Uri.parse(url),
          headers: headers,
        )
        .timeout(
          const Duration(seconds: 12),
        ));

    if (Helper.verificaStatusCode(statusCode: response.statusCode)) {
      var result = jsonDecode(response.body);

      ConsultationModel consulta = ConsultationModel.fromMap(map: result);

      return consulta;
    } else {
      var result = jsonDecode(response.body);

      throw Exception(result['message']);
    }
  }

  Future<List<ResponseForm>> getFormDynamic(
      {required String idConsultation}) async {
    String url = '${Env.apiURL}consultations/$idConsultation/dynamic';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
      Strings.xConsultationType: Strings.childcare,
    };

    final response = await _authInterceptor.sendRequest(() => http.Client()
        .get(
          Uri.parse(url),
          headers: headers,
        )
        .timeout(
          const Duration(seconds: 12),
        ));

    if (Helper.verificaStatusCode(statusCode: response.statusCode)) {
      final jsonResult = jsonDecode(response.body);
      final form = jsonResult['form'] ?? [];

      List<ResponseForm> formResponse = [];

      form.forEach(
          (element) => formResponse.add(ResponseForm.fromJson(element)));

      return formResponse;
    } else {
      var result = jsonDecode(response.body);

      throw Exception(result['message']);
    }
  }

  Future<BlocksModel> getConsultationReport({
    required String idConsultation,
  }) async {
    String url = '${Env.apiURL}consultations/$idConsultation/report';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
      Strings.xConsultationType: Strings.childcare,
    };

    final response = await _authInterceptor.sendRequest(() => httpClient
        .get(
          Uri.parse(url),
          headers: headers,
        )
        .timeout(
          const Duration(seconds: 12),
        ));

    if (Helper.verificaStatusCode(statusCode: response.statusCode)) {
      var result = jsonDecode(utf8.decode(response.bodyBytes));

      BlocksModel blocks = BlocksModel.fromJson(
        result,
        idConsultation,
      );

      return blocks;
    } else {
      var result = jsonDecode(response.body);

      throw Exception(result['message']);
    }
  }

  Future<ConsultationModel> postConsultation({
    required PatientsModel patient,
    required List<CompanionModel> companions,
    PregnancyModel? pregnancy,
  }) async {
    String url = '${Env.apiURL}patients/${patient.id}/consultations';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
      Strings.xConsultationType: Strings.childcare,
    };

    List<String> companionIds =
        companions.map((companion) => companion.id).toList();

    final Map<String, dynamic> body = {
      "companionIds": companionIds,
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

    if (Helper.verificaStatusCode(statusCode: response.statusCode)) {
      var result = jsonDecode(response.body);

      ConsultationModel consulta = ConsultationModel.fromMap(map: result);
      return consulta;
    } else {
      var result = jsonDecode(response.body);

      throw Exception(result['message']);
    }
  }

  Future<String> updateConsultation({
    required String consultationId,
    required dynamic consultation,
  }) async {
    String url = '${Env.apiURL}consultations/$consultationId';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
      Strings.xConsultationType: Strings.childcare,
    };

    Map<String, dynamic> body = {
      'data': consultation,
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

    if (Helper.verificaStatusCode(statusCode: response.statusCode)) {
      return "Consulta editada com sucesso";
    } else {
      var result = jsonDecode(response.body);

      throw Exception(result['message']);
    }
  }

  Future<String> updateConsultationPartial({
    required ConsultationModel consultation,
    dynamic objectUpdate,
  }) async {
    String url = '${Env.apiURL}consultations/${consultation.id}';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
      Strings.xConsultationType: Strings.childcare,
    };

    var body = {
      'data': objectUpdate,
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

    if (Helper.verificaStatusCode(statusCode: response.statusCode)) {
      return "Consulta editada com sucesso";
    } else {
      var result = jsonDecode(response.body);

      throw Exception(result['message']);
    }
  }

  Future<String> updateMinimized({
    required ConsultationModel consultation,
    dynamic objectUpdate,
  }) async {
    String url = '${Env.apiURL}consultations/${consultation.id}/settings';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
      Strings.xConsultationType: Strings.childcare,
    };

    final response = await _authInterceptor.sendRequest(() => httpClient
        .patch(
          Uri.parse(url),
          headers: headers,
          body: json.encode(objectUpdate),
        )
        .timeout(
          const Duration(seconds: 12),
        ));

    if (Helper.verificaStatusCode(statusCode: response.statusCode)) {
      return "Consulta editada com sucesso";
    } else {
      var result = jsonDecode(response.body);

      throw Exception(result['message']);
    }
  }

  Future<String> finishConsultation({
    required ConsultationModel consultation,
  }) async {
    String url = '${Env.apiURL}consultations/${consultation.id}/finish';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
      Strings.xConsultationType: Strings.childcare,
    };

    final response = await _authInterceptor.sendRequest(() => httpClient
        .patch(
          Uri.parse(url),
          headers: headers,
          body: json.encode(''),
        )
        .timeout(
          const Duration(seconds: 12),
        ));

    if (Helper.verificaStatusCode(statusCode: response.statusCode)) {
      return "Consulta finalizada com sucesso";
    } else {
      var result = jsonDecode(response.body);

      throw Exception(result['message']);
    }
  }

  Future<String> deleteConsultation({
    required String consultationId,
  }) async {
    String url = '${Env.apiURL}consultations/$consultationId';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
      Strings.xConsultationType: Strings.childcare,
    };

    final response = await _authInterceptor.sendRequest(() => httpClient
        .delete(
          Uri.parse(url),
          headers: headers,
          body: json.encode(''),
        )
        .timeout(
          const Duration(seconds: 12),
        ));

    if (Helper.verificaStatusCode(statusCode: response.statusCode)) {
      return "Consulta cancelada com sucesso";
    } else {
      var result = jsonDecode(response.body);

      throw Exception(result['message']);
    }
  }
}
