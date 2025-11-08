import 'package:medgo/data/models/calculator_form.dart';
import 'package:medgo/data/models/calculators_pagination_model.dart';
import 'package:medgo/data/models/calculators_model.dart';

abstract class CalculatorsState {}

class InitialCalculatorsState extends CalculatorsState {}

class CalculatorsLoading extends CalculatorsState {}

class CalculatorsLoadingMore extends CalculatorsState {}

class CalculatorsLoaded extends CalculatorsState {
  final CalculatorsPaginationModel calculators;

  CalculatorsLoaded({required this.calculators});
}

class CalculatorLoaded extends CalculatorsState {
  final CalculatorsModel calculator;

  CalculatorLoaded({required this.calculator});
}

class CalculatorInitied extends CalculatorsState {
  final CalculatorResponseFormModel listForm;

  CalculatorInitied({required this.listForm});
}

class CalculatorsPosted extends CalculatorsState {
  final String mensagem;

  CalculatorsPosted({required this.mensagem});
}

class CalculatorsPatched extends CalculatorsState {
  final String mensagem;

  CalculatorsPatched({required this.mensagem});
}

class CalculatorDeleted extends CalculatorsState {
  final String mensagem;

  CalculatorDeleted({required this.mensagem});
}

class CalculatorsError extends CalculatorsState {
  final Exception e;

  CalculatorsError({required this.e});
}
