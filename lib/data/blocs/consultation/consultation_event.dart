import 'package:medgo/data/models/companion_model.dart';
import 'package:medgo/data/models/consultation_model.dart';
import 'package:medgo/data/models/pregnancy_model.dart';
import 'package:medgo/data/models/patients_model.dart';

abstract class ConsultationEvent {}

class GetConsultations extends ConsultationEvent {
  final String idPatient;

  GetConsultations({
    required this.idPatient,
  });
}

class GetConsultationById extends ConsultationEvent {
  final String idConsultation;

  GetConsultationById({
    required this.idConsultation,
  });
}

class GetConsultationForm extends ConsultationEvent {
  final String idConsultation;

  GetConsultationForm({
    required this.idConsultation,
  });
}

class GetConsultationReport extends ConsultationEvent {
  final String idConsultation;

  GetConsultationReport({
    required this.idConsultation,
  });
}

class PostConsultation extends ConsultationEvent {
  final PatientsModel patient;
  final List<CompanionModel> companions;
  final PregnancyModel? pregnancy;
  final String? status;

  PostConsultation({
    required this.patient,
    required this.companions,
    this.pregnancy,
    this.status,
  });
}

class PatchConsultation extends ConsultationEvent {
  final dynamic consultation;
  final String consultationId;

  PatchConsultation({
    required this.consultation,
    required this.consultationId,
  });
}

class PatchPartialConsultation extends ConsultationEvent {
  final ConsultationModel consultation;
  dynamic objectUpdate;

  PatchPartialConsultation({
    required this.consultation,
    this.objectUpdate,
  });
}

class PatchMinimizedConsultation extends ConsultationEvent {
  final ConsultationModel consultation;
  dynamic objectUpdate;

  PatchMinimizedConsultation({
    required this.consultation,
    this.objectUpdate,
  });
}

class FinishConsultation extends ConsultationEvent {
  final ConsultationModel consultation;

  FinishConsultation({
    required this.consultation,
  });
}

class DeleteConsultation extends ConsultationEvent {
  final String consultationId;

  DeleteConsultation({
    required this.consultationId,
  });
}
