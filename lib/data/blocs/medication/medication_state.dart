import 'package:medgo/data/models/medication_model.dart';
import 'package:medgo/data/models/medications_pagination_model.dart';

abstract class MedicationsState {}

class InitialMedicationsState extends MedicationsState {}

class MedicationsLoading extends MedicationsState {}

class MedicationsLoadingMore extends MedicationsState {}

class MedicationsLoaded extends MedicationsState {
  final MedicationsPaginationModel medications;

  MedicationsLoaded({required this.medications});
}

class MedicationLoaded extends MedicationsState {
  final MedicationModel medication;

  MedicationLoaded({required this.medication});
}

class MedicationsPosted extends MedicationsState {
  final String mensagem;

  MedicationsPosted({required this.mensagem});
}

class MedicationsPuted extends MedicationsState {
  final String mensagem;

  MedicationsPuted({required this.mensagem});
}

class MedicationDeleted extends MedicationsState {
  final String mensagem;

  MedicationDeleted({required this.mensagem});
}

class MedicationsError extends MedicationsState {
  final Exception e;

  MedicationsError({required this.e});
}
