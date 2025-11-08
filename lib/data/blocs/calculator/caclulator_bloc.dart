import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medgo/data/blocs/calculator/calculator_event.dart';
import 'package:medgo/data/blocs/calculator/calculator_state.dart';
import 'package:medgo/data/models/calculator_form.dart';
import 'package:medgo/data/models/calculators_model.dart';
import 'package:medgo/data/models/calculators_pagination_model.dart';
import 'package:medgo/data/repositories/calculator_repository.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorsState> {
  final CalculatorRepository repository;

  CalculatorBloc({required this.repository}) : super(InitialCalculatorsState());

  @override
  Stream<CalculatorsState> mapEventToState(CalculatorEvent event) async* {
    if (event is GetCalculators) {
      yield CalculatorsLoading();

      try {
        final CalculatorsPaginationModel calculators =
            await repository.getCalculators(
          currentPage: 1,
          search: event.search,
        );

        yield CalculatorsLoaded(calculators: calculators);
      } catch (e) {
        yield CalculatorsError(e: e as Exception);
      }
    } else if (event is LoadMoreData) {
      if (event.currentPage == 1) {
        yield CalculatorsLoading();
      } else {
        yield CalculatorsLoadingMore();
      }

      try {
        final CalculatorsPaginationModel calculators =
            await repository.getCalculators(
          currentPage: event.currentPage,
          search: event.search,
        );

        yield CalculatorsLoaded(
          calculators: CalculatorsPaginationModel(
            calculators: List<CalculatorsModel>.from(event.loadedCalculators)
              ..addAll(calculators.calculators),
            limit: calculators.limit,
            page: calculators.page,
            totalPages: calculators.totalPages,
            total: calculators.total,
          ),
        );
      } catch (e) {
        yield CalculatorsError(e: e as Exception);
      }
    } else if (event is InitConsultation) {
      yield CalculatorsLoading();

      try {
        final CalculatorResponseFormModel responseForm =
            await repository.initCalculator(
          calculatorType: event.xCalculatorType,
        );

        yield CalculatorInitied(
          listForm: responseForm,
        );
      } catch (e) {
        yield CalculatorsError(e: e as Exception);
      }
    } else if (event is PatchCalculator) {
      yield CalculatorsLoading();

      try {
        final String message = await repository.updateCalculator(
          calculatorType: event.xCalculatorType,
          calculatorId: event.calculatorId,
          calculatorObject: event.calculator,
        );

        yield CalculatorsPatched(
          mensagem: message,
        );
      } catch (e) {
        yield CalculatorsError(e: e as Exception);
      }
    } else if (event is CleanCalculator) {
      yield CalculatorsLoading();

      try {
        final String message = await repository.cleanCalculator(calculatorId: event.calculatorId);
        
        yield CalculatorsPatched(
          mensagem: message,
        );
      } catch (e) {
        yield CalculatorsError(e: e as Exception);
      }
    }
  }
}
