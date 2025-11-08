import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:medgo/data/models/calculator_form.dart';
import 'package:medgo/data/models/calculators_model.dart';
import 'package:medgo/data/models/calculators_pagination_model.dart';
import 'package:medgo/data/providers/auth_interceptor_service.dart';
import 'package:medgo/env.dart';
import 'package:medgo/helper/helper.dart';
import 'package:medgo/strings/api.dart';
import 'package:medgo/strings/strings.dart';
import 'package:medgo/widgets/dynamic_form/form_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculatorProvider {
  final http.Client httpClient;
  late final AuthInterceptor _authInterceptor;

  CalculatorProvider({
    required this.httpClient,
  }) {
    _authInterceptor = AuthInterceptor(httpClient: httpClient);
  }

  Future<CalculatorsPaginationModel> getCalculators({
    required int currentPage,
    required String search,
  }) async {
    String url =
        '${Env.apiURL}calculators/types?limit=${20}&page=$currentPage&sort=createdAt&order=asc';
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
      late final List<CalculatorsModel> patients = [];

      for (var item in result["data"]) {
        patients.add(
          CalculatorsModel.fromMap(map: item),
        );
      }

      return CalculatorsPaginationModel(
          calculators: patients,
          limit: result["limit"],
          page: result["page"],
          totalPages: result["totalPages"],
          total: result["total"]);
    } else {
      throw Exception(result['message']);
    }
  }

  Future<CalculatorResponseFormModel> initCalculator({
    required String xCalculatorType,
  }) async {
    String url = '${Env.apiURL}calculators/init';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
      Strings.xCalculatorType: xCalculatorType,
    };

    final http.Response response = await http.Client()
        .post(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode({}),
        )
        .timeout(
          const Duration(seconds: 12),
        );

    if (Helper.verificaStatusCode(statusCode: response.statusCode)) {
      final jsonResult = jsonDecode(response.body);

      CalculatorResponseFormModel responseForm =
          CalculatorResponseFormModel.fromJson(jsonResult);

      return responseForm;
    } else {
      var result = jsonDecode(response.body);

      throw Exception(result['message']);
    }
  }

  Future<String> updateCalculator({
    required String xCalculatorType,
    required dynamic calculatorObject,
    required String calculatorId,
  }) async {
    String url = '${Env.apiURL}calculators/$calculatorId';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
      Strings.xCalculatorType: xCalculatorType,
    };

    Map<String, dynamic> body = {
      'data': calculatorObject,
    };

    final http.Response response = await httpClient
        .patch(
          Uri.parse(url),
          headers: headers,
          body: json.encode(body),
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

  Future<String> cleanCalculator({
    required String calculatorId,
  }) async {
    String url = '${Env.apiURL}calculators/$calculatorId/clean';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    final http.Response response =
        await httpClient.post(Uri.parse(url), headers: headers).timeout(
              const Duration(seconds: 12),
            );

    if (Helper.verificaStatusCode(statusCode: response.statusCode)) {
      return "Calculadora limpa com sucesso";
    } else {
      var result = jsonDecode(response.body);

      throw Exception(result['message']);
    }
  }

  Future<List<ResponseForm>> getFormDynamic({
    required String idCalculator,
    required String xCalculatorType,
  }) async {
    String url = '${Env.apiURL}calculators/$idCalculator/dynamic';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: API.applicationJson,
      Strings.xCalculatorType: xCalculatorType,
    };

    final http.Response response = await http.Client()
        .get(
          Uri.parse(url),
          headers: headers,
        )
        .timeout(
          const Duration(seconds: 12),
        );

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
}
