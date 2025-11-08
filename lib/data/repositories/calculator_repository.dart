import 'package:medgo/data/models/calculator_form.dart';
import 'package:medgo/data/models/calculators_pagination_model.dart';
import 'package:medgo/data/providers/calculator_service.dart';

class CalculatorRepository {
  final CalculatorProvider provider;

  CalculatorRepository({required this.provider});

  Future<CalculatorsPaginationModel> getCalculators({
    required int currentPage,
    required String search,
  }) async {
    return await provider.getCalculators(
      currentPage: currentPage,
      search: search,
    );
  }

  Future<CalculatorResponseFormModel> initCalculator({
    required String calculatorType,
  }) async {
    return await provider.initCalculator(
      xCalculatorType: calculatorType,
    );
  }

  Future<String> updateCalculator({
    required String calculatorType,
    required String calculatorId,
    required dynamic calculatorObject,
  }) async {
    return await provider.updateCalculator(
      xCalculatorType: calculatorType,
      calculatorId: calculatorId,
      calculatorObject: calculatorObject,
    );
  }

  Future<String> cleanCalculator({
    required String calculatorId,
  }) async {
    return await provider.cleanCalculator(
      calculatorId: calculatorId,
    );
  }
}
