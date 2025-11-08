import 'package:medgo/data/models/new_prescription_model.dart';
import 'package:medgo/data/models/prescription_response_model.dart';
import 'package:medgo/data/providers/prescription_service.dart';
import 'package:medgo/data/models/prescription_model.dart';

class PrescriptionRepository {
  final PrescriptionProvider provider;

  PrescriptionRepository({required this.provider});

  Future<PrescriptionModel?> getPrescription(
      {required String consultationId}) async {
    return await provider.getPrescription(
      consultationId: consultationId,
    );
  }

  Future<List<NewPrescriptionModel>?> getPrescriptions({
    String? consultationId,
    String? calculatorId,
  }) async {
    return await provider.getPrescriptions(
      consultationId: consultationId,
      calculatorId: calculatorId,
    );
  }

  Future<PrescriptionResponseModel> getNewPrescriptions({
    String? consultationId,
    String? calculatorId,
  }) async {
    return await provider.getNewPrescriptions(
      consultationId: consultationId,
      calculatorId: calculatorId,
    );
  }

  Future<String> patchPrescription({
    required List<String> medicationsId,
    required String conductId,
    required String prescriptionId,
    required String consultationId,
  }) async {
    return await provider.updatePrescriptions(
      conductId: conductId,
      consultationId: consultationId,
      medicationsId: medicationsId,
      prescriptionId: prescriptionId,
    );
  }

  Future<String> newPatchPrescription({
    required bool isChosen,
    required String prescriptionItemId,
  }) async {
    return await provider.newUpdatePrescriptions(
      isChosen: isChosen,
      prescriptionItemId: prescriptionItemId,
    );
  }

  Future<String> patchDosageInstructions({
    required dynamic data,
    required String prescriptionId,
    required String consultationId,
  }) async {
    return await provider.updateDosageInstructions(
      data: data,
      consultationId: consultationId,
      prescriptionId: prescriptionId,
    );
  }

  Future<String> newPatchDosageInstructions({
    required dynamic data,
    required String prescriptionItemId,
    String? consultationId,
    String? calculatorId,
    required bool isVacination,
  }) async {
    return await provider.newUpdateDosageInstructions(
      data: data,
      consultationId: consultationId,
      calculatorId: calculatorId,
      isVacination: isVacination,
      prescriptionItemId: prescriptionItemId,
    );
  }

  Future<String> newUpdatePrescriptionsLike({
    required String prescriptionItemId,
    String? consultationId,
    String? calculatorId,
    required bool isFavorite,
  }) async {
    return await provider.newUpdatePrescriptionsLike(
      consultationId: consultationId,
      calculatorId: calculatorId,
      prescriptionItemId: prescriptionItemId,
      isFavorite: isFavorite,
    );
  }

  Future<String> deleteCustomPrescription({
    required String prescriptionItemId,
    required String prescriptionId,
  }) async {
    return await provider.deleteCustomPrescription(
      prescriptionItemId: prescriptionItemId,
      prescriptionId: prescriptionId,
    );
  }

  Future<String> createPrescription({
    required List<String> entitiesIds,
    required Map<String, dynamic> instructions,
    String? prescriptionId,
  }) async {
    return await provider.createPrescription(
      entitiesIds: entitiesIds,
      instructions: instructions,
      prescriptionId: prescriptionId,
    );
  }
}
