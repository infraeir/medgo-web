import 'package:medgo/data/providers/patients_service.dart';
import 'package:medgo/data/models/patiens_pagination_model.dart';
import 'package:medgo/data/models/patients_model.dart';

class PatientsRepository {
  final PatientsProvider provider;

  PatientsRepository({required this.provider});

  Future<PatientsPaginationModel> getPatients({
    required int currentPage,
    required String search,
  }) async {
    return await provider.getPatients(
      currentPage: currentPage,
      search: search,
    );
  }

  Future<PatientsModel> getPatientById({
    required String id,
  }) async {
    return await provider.getPatientById(
      id: id,
    );
  }

  Future<String> postPatients({
    required String nome,
    required String dataNasc,
    required String sexo,
    required String cor,
    required String? nomeMae,
    required String? nomePai,
  }) async {
    return await provider.postPatients(
      cor: cor,
      dataNasc: dataNasc,
      nome: nome,
      nomeMae: nomeMae,
      nomePai: nomePai,
      sexo: sexo,
    );
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
    return await provider.putPatients(
      id: id,
      cor: cor,
      dataNasc: dataNasc,
      nome: nome,
      nomeMae: nomeMae,
      nomePai: nomePai,
      sexo: sexo,
    );
  }

  Future<String> deletePatient({
    required String id,
  }) async {
    return await provider.deletePatient(
      id: id,
    );
  }
}
