import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medgo/data/blocs/patients/patients_service_event.dart';
import 'package:medgo/data/blocs/patients/patients_service_state.dart';
import 'package:medgo/data/repositories/patients_repository.dart';
import 'package:medgo/data/models/patiens_pagination_model.dart';
import 'package:medgo/data/models/patients_model.dart';

class PatientsBloc extends Bloc<PatientsEvent, PatientsState> {
  final PatientsRepository repository;

  PatientsBloc({required this.repository}) : super(InitialPatientsState());

  @override
  Stream<PatientsState> mapEventToState(PatientsEvent event) async* {
    if (event is GetPatients) {
      yield PatientsLoading();

      try {
        final PatientsPaginationModel patients = await repository.getPatients(
          currentPage: 1,
          search: event.search,
        );

        yield PatientsLoaded(patients: patients);
      } catch (e) {
        yield PatientsError(e: e as Exception);
      }
    } else if (event is LoadMoreData) {
      if (event.currentPage == 1) {
        yield PatientsLoading();
      } else {
        yield PatientsLoadingMore();
      }

      try {
        final PatientsPaginationModel patients = await repository.getPatients(
          currentPage: event.currentPage,
          search: event.search,
        );

        yield PatientsLoaded(
            patients: PatientsPaginationModel(
                patients: List<PatientsModel>.from(event.loadedPatients)
                  ..addAll(patients.patients),
                limit: patients.limit,
                page: patients.page,
                totalPages: patients.totalPages,
                total: patients.total));
      } catch (e) {
        yield PatientsError(e: e as Exception);
      }
    } else if (event is GetPatient) {
      yield PatientsLoading();

      try {
        final PatientsModel patient =
            await repository.getPatientById(id: event.id);

        yield PatientLoaded(patient: patient);
      } catch (e) {
        yield PatientsError(e: e as Exception);
      }
    } else if (event is PostPatients) {
      yield PatientsLoading();

      try {
        final String mensagem = await repository.postPatients(
          cor: event.cor,
          dataNasc: event.dataNasc,
          nome: event.nome,
          nomeMae: event.nomeMae,
          nomePai: event.nomePai,
          sexo: event.sexo,
        );

        yield PatientsPosted(mensagem: mensagem);
      } catch (e) {
        yield PatientsError(e: e as Exception);
      }
    } else if (event is PutPatients) {
      yield PatientsLoading();

      try {
        final String mensagem = await repository.putPatients(
          id: event.id,
          cor: event.cor,
          dataNasc: event.dataNasc,
          nome: event.nome,
          nomeMae: event.nomeMae,
          nomePai: event.nomePai,
          sexo: event.sexo,
        );

        yield PatientsPuted(mensagem: mensagem);
      } catch (e) {
        yield PatientsError(e: e as Exception);
      }
    } else if (event is DeletePatient) {
      yield PatientsLoading();

      try {
        final String mensagem = await repository.deletePatient(
          id: event.id,
        );

        yield PatientDeleted(mensagem: mensagem);
      } catch (e) {
        yield PatientsError(e: e as Exception);
      }
    }
  }
}
