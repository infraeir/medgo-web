import 'package:medgo/data/models/block_model.dart';
import 'package:medgo/data/models/consultation_model.dart';
import 'package:medgo/widgets/dynamic_form/form_model.dart';

abstract class ConsultationState {}

class InitialConsultationState extends ConsultationState {}

class ConsultationLoading extends ConsultationState {}

class ConsultationReportLoading extends ConsultationState {}

class ConsultationMnimizedLoading extends ConsultationState {}

class ConsultationPartialLoading extends ConsultationState {}

class ConsultationFinalLoading extends ConsultationState {}

class ConsultationLoaded extends ConsultationState {
  final List<ConsultationModel> consultations;

  ConsultationLoaded({required this.consultations});
}

class ConsultationByIdLoaded extends ConsultationState {
  final ConsultationModel consultation;

  ConsultationByIdLoaded({required this.consultation});
}

class ConsultationReportLoaded extends ConsultationState {
  final BlocksModel report;

  ConsultationReportLoaded({required this.report});
}

class ConsultationFormLoaded extends ConsultationState {
  final List<ResponseForm> form;

  ConsultationFormLoaded({required this.form});
}

class ConsultationPosted extends ConsultationState {
  final ConsultationModel consultation;

  ConsultationPosted({required this.consultation});
}

class ConsultationPatched extends ConsultationState {
  final String consultation;

  ConsultationPatched({required this.consultation});
}

class ConsultationDinamicoMinimized extends ConsultationState {
  final String message;

  ConsultationDinamicoMinimized({required this.message});
}

class ConsultationPatchedPartial extends ConsultationState {
  final String consultation;

  ConsultationPatchedPartial({required this.consultation});
}

class ConsultationFinished extends ConsultationState {
  final String consultation;

  ConsultationFinished({required this.consultation});
}

class ConsultationDeleted extends ConsultationState {
  final String message;

  ConsultationDeleted({required this.message});
}

class ConsultationError extends ConsultationState {
  final Exception e;

  ConsultationError({required this.e});
}

class MinimizedError extends ConsultationState {
  final Exception e;

  MinimizedError({required this.e});
}
