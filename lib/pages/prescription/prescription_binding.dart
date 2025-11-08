import 'package:get_it/get_it.dart';
import 'package:medgo/data/blocs/medication/medication_bloc.dart';
import 'package:medgo/data/blocs/prescription/prescription_bloc.dart';
import 'package:medgo/data/repositories/medication_repository.dart';
import 'package:medgo/data/repositories/prescription_repository.dart';
import 'package:medgo/data/providers/prescription_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../data/providers/medication_service.dart';

void setUpPrescription() {
  // Blocs
  GetIt.I.allowReassignment = true;

  // Repositories
  GetIt.I.registerFactory<PrescriptionRepository>(
    () => PrescriptionRepository(
      provider: GetIt.I.get(),
    ),
  );
  GetIt.I.registerFactory<MedicationRepository>(
    () => MedicationRepository(
      provider: GetIt.I.get(),
    ),
  );

  // Provider
  GetIt.I.registerFactory<PrescriptionProvider>(
    () => PrescriptionProvider(
      httpClient: GetIt.I.get(),
    ),
  );
  GetIt.I.registerFactory<MedicationProvider>(
    () => MedicationProvider(
      httpClient: GetIt.I.get(),
    ),
  );

  // Bloc
  GetIt.I.registerFactory<PrescriptionBloc>(
    () => PrescriptionBloc(
      repository: GetIt.I.get(),
    ),
  );
  GetIt.I.registerFactory<MedicationBloc>(
    () => MedicationBloc(
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
