import 'package:medgo/data/models/companion_model.dart';
import 'package:medgo/data/providers/consultation_service.dart';
import 'package:medgo/data/models/block_model.dart';
import 'package:medgo/data/models/consultation_model.dart';
import 'package:medgo/data/models/pregnancy_model.dart';
import 'package:medgo/data/models/patients_model.dart';
import 'package:medgo/widgets/dynamic_form/form_model.dart';

class ConsultationRepository {
  final ConsultationProvider provider;

  ConsultationRepository({required this.provider});

  Future<List<ConsultationModel>> getConsultations(
      {required String idPatient}) async {
    return await provider.getConsultations(
      idPatient: idPatient,
    );
  }

  Future<ConsultationModel> getConsultationById(
      {required String idConsultation}) async {
    return await provider.getConsultationById(
      idConsultation: idConsultation,
    );
  }

  Future<List<ResponseForm>> getFormDynamic(
      {required String idConsultation}) async {
    return await provider.getFormDynamic(
      idConsultation: idConsultation,
    );
  }

  Future<BlocksModel> getConsultationReport(
      {required String idConsultation}) async {
    return await provider.getConsultationReport(
      idConsultation: idConsultation,
    );
  }

  Future<ConsultationModel> postConsultation({
    required PatientsModel patient,
    required List<CompanionModel> companions,
    PregnancyModel? pregnancy,
  }) async {
    return await provider.postConsultation(
      companions: companions,
      patient: patient,
      pregnancy: pregnancy,
    );
  }

  Future<String> updateConsultation({
    required dynamic consultation,
    required String consultationId,
  }) async {
    return await provider.updateConsultation(
      consultation: consultation,
      consultationId: consultationId,
    );
  }

  Future<String> updateConsultationPartial({
    required ConsultationModel consultation,
    dynamic objectUpdate,
  }) async {
    return await provider.updateConsultationPartial(
      consultation: consultation,
      objectUpdate: objectUpdate,
    );
  }

  Future<String> updateMinimized({
    required ConsultationModel consultation,
    dynamic objectUpdate,
  }) async {
    return await provider.updateMinimized(
      consultation: consultation,
      objectUpdate: objectUpdate,
    );
  }

  Future<String> finishConsultation(
      {required ConsultationModel consultation}) async {
    return await provider.finishConsultation(
      consultation: consultation,
    );
  }

  Future<String> deleteConsultation({required String consultationId}) async {
    return await provider.deleteConsultation(
      consultationId: consultationId,
    );
  }
}
