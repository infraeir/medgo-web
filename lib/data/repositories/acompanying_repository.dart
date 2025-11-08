import 'package:medgo/data/providers/acompanying_service.dart';
import 'package:medgo/data/models/companion_model.dart';

class CompanionRepository {
  final CompanionProvider provider;

  CompanionRepository({required this.provider});

  Future<String> postCompanion({
    required String idPatient,
    required String name,
    required String gender,
    required String relationship,
    required String relationshipAddInfo,
  }) async {
    return await provider.postCompanion(
      gender: gender,
      idPatient: idPatient,
      name: name,
      relationship: relationship,
      relationshipAddInfo: relationshipAddInfo,
    );
  }

  Future<List<CompanionModel>> postExtraCompanion({
    required String consultationsID,
    required String name,
    required String gender,
    required String relationship,
    required String relationshipAddInfo,
  }) async {
    return await provider.postExtraCompanion(
      gender: gender,
      consultationsID: consultationsID,
      name: name,
      relationship: relationship,
      relationshipAddInfo: relationshipAddInfo,
    );
  }

  Future<String> putCompanion({
    required String idCompanion,
    required String idPatient,
    required String name,
    required String gender,
    required String relationship,
    required String relationshipAddInfo,
  }) async {
    return await provider.putCompanion(
      idCompanion: idCompanion,
      gender: gender,
      idPatient: idPatient,
      name: name,
      relationship: relationship,
      relationshipAddInfo: relationshipAddInfo,
    );
  }

  Future<String> deleteCompanion({
    required String idCompanion,
  }) async {
    return await provider.deleteCompanion(
      idCompanion: idCompanion,
    );
  }

  Future<String> patchExtraCompanion({
    required String companionID,
    required String consultationsID,
  }) async {
    return await provider.patchExtraCompanion(
      companionID: companionID,
      consultationsID: consultationsID,
    );
  }

  Future<String> deleteExtraCompanion({
    required String companionID,
    required String consultationsID,
  }) async {
    return await provider.deleteExtraCompanion(
      companionID: companionID,
      consultationsID: consultationsID,
    );
  }
}
