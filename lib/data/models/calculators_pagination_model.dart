import 'package:medgo/data/models/calculators_model.dart';

class CalculatorsPaginationModel {
  final List<CalculatorsModel> calculators;
  final int limit;
  final int page;
  final int totalPages;
  final int total;

  CalculatorsPaginationModel({
    required this.calculators,
    required this.limit,
    required this.page,
    required this.totalPages,
    required this.total,
  });
}
