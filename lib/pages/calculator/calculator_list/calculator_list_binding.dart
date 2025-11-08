import 'package:get_it/get_it.dart';
import 'package:medgo/data/blocs/calculator/caclulator_bloc.dart';
import 'package:medgo/data/providers/calculator_service.dart';
import 'package:medgo/data/repositories/calculator_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void setUpCalculators() {
  // Blocs
  GetIt.I.allowReassignment = true;

  GetIt.I.registerFactory<CalculatorBloc>(
    () => CalculatorBloc(
      repository: GetIt.I.get(),
    ),
  );

  // Repositories
  GetIt.I.registerFactory<CalculatorRepository>(
    () => CalculatorRepository(
      provider: GetIt.I.get(),
    ),
  );

  // Provider
  GetIt.I.registerFactory<CalculatorProvider>(
    () => CalculatorProvider(
      httpClient: GetIt.I.get(),
    ),
  );

  // Provider
  GetIt.I.registerFactory<http.Client>(
    () => http.Client(),
  );
  // Services
  GetIt.I.registerLazySingletonAsync<SharedPreferences>(
      () async => SharedPreferences.getInstance());
}
