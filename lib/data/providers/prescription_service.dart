import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:medgo/data/models/new_prescription_model.dart';
import 'package:medgo/data/models/prescription_response_model.dart';
import 'package:medgo/data/providers/auth_interceptor_service.dart';
import 'package:medgo/env.dart';
import 'package:medgo/helper/helper.dart';
import 'package:medgo/data/models/prescription_model.dart';
import 'package:medgo/strings/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrescriptionProvider {
  final http.Client httpClient;
  late final AuthInterceptor _authInterceptor;

  PrescriptionProvider({
    required this.httpClient,
  }) {
    _authInterceptor = AuthInterceptor(httpClient: httpClient);
  }

  Future<PrescriptionModel?> getPrescription({
    required String consultationId,
  }) async {
    String url = '${Env.apiURL}consultations/$consultationId/prescription';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
    };

    final http.Response response = await httpClient
        .get(
          Uri.parse(url),
          headers: headers,
        )
        .timeout(
          const Duration(seconds: 12),
        );

    var result = jsonDecode(response.body);

    if (Helper.verificaStatusCode(statusCode: response.statusCode)) {
      if (response.statusCode == 204) {
        return null;
      }
      late final PrescriptionModel conductModel;

      conductModel = PrescriptionModel.fromJson(result);

      return conductModel;
    } else {
      throw Exception(result['message']);
    }
  }

  Future<List<NewPrescriptionModel>?> getPrescriptions({
    String? consultationId,
    String? calculatorId,
  }) async {
    String url = Env.apiURL;
    if (consultationId != null) {
      url += 'consultations/$consultationId/prescriptions';
    } else {
      url += 'calculators/$calculatorId/prescriptions';
    }
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
      if (response.statusCode == 204) {
        return null;
      }

      // Supondo que `result.data` seja uma lista de JSONs
      final List<NewPrescriptionModel> conductModel =
          (result['data'] as List<dynamic>)
              .map((json) => NewPrescriptionModel.fromJson(json))
              .toList();

      return conductModel;
    } else {
      throw Exception(result['message']);
    }
  }

  Future<PrescriptionResponseModel> getNewPrescriptions({
    String? consultationId,
    String? calculatorId,
  }) async {
    String url = Env.apiURL;
    if (consultationId != null) {
      url += 'consultations/$consultationId/prescriptions-new';
    } else {
      url += 'calculators/$calculatorId/prescriptions-new';
    }
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
      final PrescriptionResponseModel prescriptionModel =
          PrescriptionResponseModel.fromMap(result);

      return prescriptionModel;
    } else {
      throw Exception(result['message']);
    }
  }

  Future<String> updatePrescriptions({
    required List<String> medicationsId,
    required String conductId,
    required String prescriptionId,
    required String consultationId,
  }) async {
    String url =
        '${Env.apiURL}consultations/$consultationId/prescriptions/$prescriptionId/chosen-medications';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
    };

    var obj = {
      "chosenMedications": [
        {
          "conductId": conductId,
          "medicationsIds": medicationsId,
        }
      ]
    };

    final http.Response response = await httpClient
        .patch(
          Uri.parse(url),
          headers: headers,
          body: json.encode(obj),
        )
        .timeout(
          const Duration(seconds: 12),
        );

    if (Helper.verificaStatusCode(statusCode: response.statusCode)) {
      return "Consulta editada com sucesso";
    } else {
      var result = jsonDecode(response.body);

      throw Exception(result['message']);
    }
  }

  Future<String> newUpdatePrescriptions({
    required bool isChosen,
    required String prescriptionItemId,
  }) async {
    String url = '${Env.apiURL}prescription-items/$prescriptionItemId/choose';

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
    };

    var obj = {
      'isChosen': isChosen,
    };

    final http.Response response = await httpClient
        .patch(
          Uri.parse(url),
          headers: headers,
          body: json.encode(obj),
        )
        .timeout(
          const Duration(seconds: 12),
        );

    if (Helper.verificaStatusCode(statusCode: response.statusCode)) {
      return "Consulta editada com sucesso";
    } else {
      var result = jsonDecode(response.body);

      throw Exception(result['message']);
    }
  }

  Future<String> updateDosageInstructions({
    required dynamic data,
    required String prescriptionId,
    required String consultationId,
  }) async {
    String url =
        '${Env.apiURL}consultations/$consultationId/prescriptions/$prescriptionId/dosage-instructions';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
    };

    final http.Response response = await httpClient
        .patch(
          Uri.parse(url),
          headers: headers,
          body: json.encode(data),
        )
        .timeout(
          const Duration(seconds: 12),
        );

    if (Helper.verificaStatusCode(statusCode: response.statusCode)) {
      return "Dosagem atualizada com sucesso";
    } else {
      var result = jsonDecode(response.body);

      throw Exception(result['message']);
    }
  }

  Future<String> newUpdateDosageInstructions({
    required dynamic data,
    required String prescriptionItemId,
    String? consultationId,
    String? calculatorId,
    required bool isVacination,
  }) async {
    String url = Env.apiURL;

    if (consultationId != null) {
      url +=
          'consultations/$consultationId/prescription-items/$prescriptionItemId';
    } else {
      url += 'calculators/$calculatorId/prescription-items/$prescriptionItemId';
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    isVacination
        ? url += '/vaccine-dose-instructions'
        : url += '/medication-instructions';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
    };

    final http.Response response = await httpClient
        .patch(
          Uri.parse(url),
          headers: headers,
          body: json.encode(data),
        )
        .timeout(
          const Duration(seconds: 12),
        );

    if (Helper.verificaStatusCode(statusCode: response.statusCode)) {
      return "Dosagem atualizada com sucesso";
    } else {
      var result = jsonDecode(response.body);

      throw Exception(result['message']);
    }
  }

  Future<String> newUpdatePrescriptionsLike({
    required String prescriptionItemId,
    String? consultationId,
    String? calculatorId,
    required bool isFavorite,
  }) async {
    String url = Env.apiURL;

    if (consultationId != null) {
      url +=
          'consultations/$consultationId/prescription-items/$prescriptionItemId/like';
    } else {
      url +=
          'calculators/$calculatorId/prescription-items/$prescriptionItemId/like';
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
    };

    var obj = {
      'isFavorite': isFavorite,
    };

    final http.Response response = await httpClient
        .patch(
          Uri.parse(url),
          headers: headers,
          body: json.encode(obj),
        )
        .timeout(
          const Duration(seconds: 12),
        );

    if (Helper.verificaStatusCode(statusCode: response.statusCode)) {
      return "Consulta editada com sucesso";
    } else {
      var result = jsonDecode(response.body);

      throw Exception(result['message']);
    }
  }

  Future<String> createPrescription({
    required List<String> entitiesIds,
    required Map<String, dynamic> instructions,
    String? prescriptionId,
  }) async {
    String url =
        '${Env.apiURL}prescriptions/$prescriptionId/prescription-items/custom-medication';

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
    };

    var obj = {
      'entitiesIds': entitiesIds,
      'instructions': instructions,
    };

    final http.Response response = await httpClient
        .patch(
          Uri.parse(url),
          headers: headers,
          body: json.encode(obj),
        )
        .timeout(
          const Duration(seconds: 12),
        );

    if (Helper.verificaStatusCode(statusCode: response.statusCode)) {
      return "Prescrição criada com sucesso";
    } else {
      var result = jsonDecode(response.body);
      throw Exception(result['message']);
    }
  }

  Future<String> deleteCustomPrescription({
    required String prescriptionItemId,
    required String prescriptionId,
  }) async {
    String url =
        '${Env.apiURL}prescriptions/$prescriptionId/prescription-items/$prescriptionItemId';

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
    };

    final http.Response response = await httpClient
        .delete(
          Uri.parse(url),
          headers: headers,
        )
        .timeout(
          const Duration(seconds: 12),
        );

    if (Helper.verificaStatusCode(statusCode: response.statusCode)) {
      return "Prescrição item deletada com sucesso";
    } else {
      var result = jsonDecode(response.body);
      throw Exception(result['message']);
    }
  }
}
