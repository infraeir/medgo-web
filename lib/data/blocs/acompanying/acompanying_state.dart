import 'package:medgo/data/models/companion_model.dart';

abstract class CompanionState {}

class InitialCompanionState extends CompanionState {}

class CompanionLoading extends CompanionState {}

class CompanionPosted extends CompanionState {
  final String mensagem;

  CompanionPosted({required this.mensagem});
}

class CompanionPatched extends CompanionState {
  final List<CompanionModel> companions;

  CompanionPatched({required this.companions});
}

class CompanionPuted extends CompanionState {
  final String mensagem;

  CompanionPuted({required this.mensagem});
}

class CompanionDeleted extends CompanionState {
  final String mensagem;

  CompanionDeleted({required this.mensagem});
}

class CompanionExtraPacthed extends CompanionState {
  final String mensagem;

  CompanionExtraPacthed({required this.mensagem});
}

class CompanionExtraDeleted extends CompanionState {
  final String mensagem;

  CompanionExtraDeleted({required this.mensagem});
}

class CompanionError extends CompanionState {
  final Exception e;

  CompanionError({required this.e});
}
