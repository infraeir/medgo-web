import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:medgo/data/providers/auth_interceptor_service.dart';
import 'package:medgo/env.dart';
import 'package:medgo/helper/helper.dart';
import 'package:medgo/data/models/medications_pagination_model.dart';
import 'package:medgo/strings/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicationProvider {
  final http.Client httpClient;
  late final AuthInterceptor _authInterceptor;

  MedicationProvider({
    required this.httpClient,
  }) {
    _authInterceptor = AuthInterceptor(httpClient: httpClient);
  }

  Future<MedicationsPaginationModel> getMedications({
    required int currentPage,
    String? search,
    List<String>? types,
    List<String>? tokens,
    bool? sus,
    bool? popularPharmacy,
  }) async {
    String url =
        '${Env.apiURL}medications/search?limit=${10}&page=$currentPage&sort=name&order=asc';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    if (search != null) {
      if (search.length >= 3) {
        url = '$url&search=$search';
      }
    }

    if (types != null && types.isNotEmpty) {
      url = '$url&types=${types.join(",")}';
    }

    if (tokens != null && tokens.isNotEmpty) {
      url = '$url&tokens=${tokens.join(",")}';
    }

    if (sus != null) {
      url = '$url&sus=$sus';
    }

    if (popularPharmacy != null) {
      url = '$url&popularPharmacy=$popularPharmacy';
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
      return MedicationsPaginationModel.fromMap(result);
    } else {
      throw Exception(result['message']);
    }
  }
}
