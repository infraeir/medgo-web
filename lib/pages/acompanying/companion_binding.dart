import 'package:get_it/get_it.dart';
import 'package:medgo/data/blocs/acompanying/acompanying_bloc.dart';
import 'package:medgo/data/repositories/acompanying_repository.dart';
import 'package:medgo/data/providers/acompanying_service.dart';
import 'package:medgo/data/blocs/consultation/consultation_bloc.dart';
import 'package:medgo/data/repositories/consultation_repository.dart';
import 'package:medgo/data/providers/consultation_service.dart';
import 'package:medgo/data/blocs/patients/patients_service_bloc.dart';
import 'package:medgo/data/repositories/patients_repository.dart';
import 'package:medgo/data/providers/patients_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void setUpCompanion() {
  // Blocs
  GetIt.I.allowReassignment = true;

  // Repositories
  GetIt.I.registerFactory<CompanionRepository>(
    () => CompanionRepository(
      provider: GetIt.I.get(),
    ),
  );
  GetIt.I.registerFactory<PatientsRepository>(
    () => PatientsRepository(
      provider: GetIt.I.get(),
    ),
  );
  GetIt.I.registerFactory<ConsultationRepository>(
    () => ConsultationRepository(
      provider: GetIt.I.get(),
    ),
  );

  // Provider
  GetIt.I.registerFactory<CompanionProvider>(
    () => CompanionProvider(
      httpClient: GetIt.I.get(),
    ),
  );
  GetIt.I.registerFactory<PatientsProvider>(
    () => PatientsProvider(
      httpClient: GetIt.I.get(),
    ),
  );
  GetIt.I.registerFactory<ConsultationProvider>(
    () => ConsultationProvider(
      httpClient: GetIt.I.get(),
    ),
  );

  GetIt.I.registerFactory<CompanionBloc>(
    () => CompanionBloc(
      repository: GetIt.I.get(),
    ),
  );
  GetIt.I.registerFactory<PatientsBloc>(
    () => PatientsBloc(
      repository: GetIt.I.get(),
    ),
  );
  GetIt.I.registerFactory<ConsultationBloc>(
    () => ConsultationBloc(
      repository: GetIt.I.get(),
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
