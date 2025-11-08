import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medgo/data/blocs/medication/medication_event.dart';
import 'package:medgo/data/blocs/medication/medication_state.dart';
import 'package:medgo/data/models/medications_pagination_model.dart';
import 'package:medgo/data/repositories/medication_repository.dart';

class MedicationBloc extends Bloc<MedicationsEvent, MedicationsState> {
  final MedicationRepository repository;

  MedicationBloc({required this.repository}) : super(InitialMedicationsState());

  @override
  Stream<MedicationsState> mapEventToState(MedicationsEvent event) async* {
    if (event is GetMedications) {
      yield MedicationsLoading();

      try {
        final MedicationsPaginationModel medications =
            await repository.getMedications(
          currentPage: 1,
          tokens: event.tokens,
          types: event.types,
          sus: event.sus,
          popularPharmacy: event.popularPharmacy,
        );

        yield MedicationsLoaded(medications: medications);
      } catch (e) {
        yield MedicationsError(e: e as Exception);
      }
    } else if (event is LoadMoreDataMedication) {
      if (event.currentPage == 1) {
        yield MedicationsLoading();
      } else {
        yield MedicationsLoadingMore();
      }

      try {
        final MedicationsPaginationModel medications =
            await repository.getMedications(
          currentPage: event.currentPage,
          search: event.search,
          types: event.types,
          tokens: event.tokens,
          sus: event.sus,
          popularPharmacy: event.popularPharmacy,
        );

        yield MedicationsLoaded(
          medications: MedicationsPaginationModel(
            medications: [
              ...event.loadedMedications,
              ...medications.medications,
            ],
            total: medications.total,
            limit: medications.limit,
            page: medications.page,
            totalPages: medications.totalPages,
            hasPrevPage: medications.hasPrevPage,
            hasNextPage: medications.hasNextPage,
            prevPage: medications.prevPage,
            nextPage: medications.nextPage,
          ),
        );
      } catch (e) {
        yield MedicationsError(e: e as Exception);
      }
    }
  }
}
