import 'package:medgo/data/models/new_prescription_model.dart';
import 'package:medgo/data/models/prescription_model.dart';
import 'package:medgo/data/models/prescription_response_model.dart';

abstract class PrescriptionState {}

class InitialPrescriptionState extends PrescriptionState {}

class PrescriptionLoading extends PrescriptionState {}

class PrescriptionLoaded extends PrescriptionState {
  final ConductModel prescriptions;

  PrescriptionLoaded({required this.prescriptions});
}

class PrescriptionPatched extends PrescriptionState {
  final String message;

  PrescriptionPatched({required this.message});
}

class PrescriptionPatchedLike extends PrescriptionState {
  final String message;

  PrescriptionPatchedLike({required this.message});
}

class DosageInstructionsPatched extends PrescriptionState {
  final String message;

  DosageInstructionsPatched({required this.message});
}

class PrescriptionByIdLoaded extends PrescriptionState {
  final PrescriptionModel? prescription;

  PrescriptionByIdLoaded({required this.prescription});
}

class PrescriptionsNewByIdLoaded extends PrescriptionState {
  final PrescriptionResponseModel prescription;

  PrescriptionsNewByIdLoaded({required this.prescription});
}

class PrescriptionsByIdLoaded extends PrescriptionState {
  final List<NewPrescriptionModel>? prescription;

  PrescriptionsByIdLoaded({required this.prescription});
}

class PrescriptionError extends PrescriptionState {
  final Exception e;

  PrescriptionError({required this.e});
}

class NewPrescriptionPatched extends PrescriptionState {
  final String message;

  NewPrescriptionPatched({required this.message});
}

class NewPrescriptionPatchedLike extends PrescriptionState {
  final String message;

  NewPrescriptionPatchedLike({required this.message});
}

class NewDosageInstructionsPatched extends PrescriptionState {
  final String message;

  NewDosageInstructionsPatched({required this.message});
}

class PrescriptionCreated extends PrescriptionState {
  final String message;

  PrescriptionCreated({required this.message});
}

class PrescriptionItemDeleted extends PrescriptionState {
  final String message;

  PrescriptionItemDeleted({required this.message});
}
