

import 'package:medgo/data/models/patiens_pagination_model.dart';
import 'package:medgo/data/models/patients_model.dart';

abstract class PatientsState {}

class InitialPatientsState extends PatientsState {}

class PatientsLoading extends PatientsState {}

class PatientsLoadingMore extends PatientsState {}

class PatientsLoaded extends PatientsState {
  final PatientsPaginationModel patients;

  PatientsLoaded({required this.patients});
}

class PatientLoaded extends PatientsState {
  final PatientsModel patient;

  PatientLoaded({required this.patient});
}

class PatientsPosted extends PatientsState {
  final String mensagem;

  PatientsPosted({required this.mensagem});
}

class PatientsPuted extends PatientsState {
  final String mensagem;
  
  PatientsPuted({required this.mensagem});
}

class PatientDeleted extends PatientsState {
  final String mensagem;
  
  PatientDeleted({required this.mensagem});
}

class PatientsError extends PatientsState {
  final Exception e;

  PatientsError({required this.e});
}
