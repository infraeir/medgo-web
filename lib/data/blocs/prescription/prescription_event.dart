abstract class PrescriptionEvent {}

class GetPrescription extends PrescriptionEvent {
  final String consultationId;

  GetPrescription({
    required this.consultationId,
  });
}

class GetPrescriptions extends PrescriptionEvent {
  final String? consultationId;
  final String? calculatorId;

  GetPrescriptions({
    this.consultationId,
    this.calculatorId,
  });
}

class GetNewPrescriptions extends PrescriptionEvent {
  final String? consultationId;
  final String? calculatorId;

  GetNewPrescriptions({
    this.consultationId,
    this.calculatorId,
  });
}

class PatchPrescription extends PrescriptionEvent {
  final List<String> medicationsId;
  final String conductId;
  final String prescriptionId;
  final String consultationId;

  PatchPrescription({
    required this.medicationsId,
    required this.conductId,
    required this.prescriptionId,
    required this.consultationId,
  });
}

class PatchPrescriptionLike extends PrescriptionEvent {
  final List<String> medicationsId;
  final String conductId;
  final String prescriptionId;
  final String consultationId;
  final bool like;

  PatchPrescriptionLike({
    required this.medicationsId,
    required this.conductId,
    required this.prescriptionId,
    required this.consultationId,
    required this.like,
  });
}

class PatchDosageInstructions extends PrescriptionEvent {
  final dynamic data;
  final String prescriptionId;
  final String consultationId;

  PatchDosageInstructions({
    required this.data,
    required this.prescriptionId,
    required this.consultationId,
  });
}

class NewPatchPrescription extends PrescriptionEvent {
  final bool isChosen;
  final String prescriptionItemId;

  NewPatchPrescription({
    required this.isChosen,
    required this.prescriptionItemId,
  });
}

class NewPatchPrescriptionLike extends PrescriptionEvent {
  final String prescriptionItemId;
  final String? consultationId;
  final String? calculatorId;
  final bool isFavorite;

  NewPatchPrescriptionLike({
    required this.prescriptionItemId,
    this.consultationId,
    this.calculatorId,
    required this.isFavorite,
  });
}

class NewPatchDosageInstructions extends PrescriptionEvent {
  final dynamic data;
  final String prescriptionItemId;
  final String? consultationId;
  final String? calculatorId;
  final bool isVacination;

  NewPatchDosageInstructions({
    required this.data,
    required this.prescriptionItemId,
    this.consultationId,
    this.calculatorId,
    required this.isVacination,
  });
}

class CreatePrescription extends PrescriptionEvent {
  final List<String> entitiesIds;
  final Map<String, dynamic> instructions;
  final String? prescriptionId;

  CreatePrescription({
    required this.entitiesIds,
    required this.instructions,
    this.prescriptionId,
  });
}

class DeleteCustomPrescription extends PrescriptionEvent {
  final String prescriptionItemId;
  final String prescriptionId;

  DeleteCustomPrescription({
    required this.prescriptionItemId,
    required this.prescriptionId,
  });
}
