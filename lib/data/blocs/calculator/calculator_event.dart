import 'package:medgo/data/models/calculators_model.dart';

abstract class CalculatorEvent {}

class GetCalculators extends CalculatorEvent {
  final List<CalculatorsModel> loadedCalculators;
  final String search;

  GetCalculators({
    required this.search,
    required this.loadedCalculators,
  });

  List<Object> get props => [...loadedCalculators];
}

class GetCalculator extends CalculatorEvent {
  final String id;

  GetCalculator({
    required this.id,
  });
}

class LoadMoreData extends CalculatorEvent {
  final int currentPage;
  final String search;
  final List<CalculatorsModel> loadedCalculators;

  LoadMoreData({
    required this.currentPage,
    required this.search,
    required this.loadedCalculators,
  });
}

class InitConsultation extends CalculatorEvent {
  final String xCalculatorType;

  InitConsultation({
    required this.xCalculatorType,
  });
}

class PatchCalculator extends CalculatorEvent {
  final dynamic calculator;
  final String calculatorId;
  final String xCalculatorType;

  PatchCalculator({
    required this.calculator,
    required this.calculatorId,
    required this.xCalculatorType,
  });
}

class CleanCalculator extends CalculatorEvent {
  final String calculatorId;

  CleanCalculator({
    required this.calculatorId,
  });
}