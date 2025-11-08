import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medgo/data/blocs/prescription/prescription_event.dart';
import 'package:medgo/data/blocs/prescription/prescription_state.dart';
import 'package:medgo/data/models/new_prescription_model.dart';
import 'package:medgo/data/models/prescription_response_model.dart';
import 'package:medgo/data/repositories/prescription_repository.dart';
import 'package:medgo/data/models/prescription_model.dart';

class PrescriptionBloc extends Bloc<PrescriptionEvent, PrescriptionState> {
  final PrescriptionRepository repository;

  PrescriptionBloc({required this.repository})
      : super(InitialPrescriptionState());

  @override
  Stream<PrescriptionState> mapEventToState(PrescriptionEvent event) async* {
    if (event is GetPrescription) {
      yield PrescriptionLoading();

      try {
        final PrescriptionModel? prescription = await repository
            .getPrescription(consultationId: event.consultationId);

        yield PrescriptionByIdLoaded(prescription: prescription);
      } catch (e) {
        yield PrescriptionError(e: e as Exception);
      }
    } else if (event is GetNewPrescriptions) {
      yield PrescriptionLoading();

      try {
        final PrescriptionResponseModel prescription =
            await repository.getNewPrescriptions(
          consultationId: event.consultationId,
          calculatorId: event.calculatorId,
        );

        yield PrescriptionsNewByIdLoaded(prescription: prescription);
      } catch (e) {
        yield PrescriptionError(e: e as Exception);
      }
    } else if (event is GetPrescriptions) {
      yield PrescriptionLoading();

      try {
        final List<NewPrescriptionModel>? prescription =
            await repository.getPrescriptions(
          consultationId: event.consultationId,
          calculatorId: event.calculatorId,
        );

        yield PrescriptionsByIdLoaded(prescription: prescription);
      } catch (e) {
        yield PrescriptionError(e: e as Exception);
      }
    } else if (event is PatchPrescription) {
      yield PrescriptionLoading();

      try {
        final String consultation = await repository.patchPrescription(
          conductId: event.conductId,
          consultationId: event.consultationId,
          medicationsId: event.medicationsId,
          prescriptionId: event.prescriptionId,
        );

        yield PrescriptionPatched(message: consultation);
      } catch (e) {
        yield PrescriptionError(e: e as Exception);
      }
    } else if (event is PatchDosageInstructions) {
      yield PrescriptionLoading();

      try {
        final String result = await repository.patchDosageInstructions(
          data: event.data,
          consultationId: event.consultationId,
          prescriptionId: event.prescriptionId,
        );

        yield DosageInstructionsPatched(message: result);
      } catch (e) {
        yield PrescriptionError(e: e as Exception);
      }
    }

    if (event is NewPatchPrescription) {
      yield PrescriptionLoading();

      try {
        final String consultation = await repository.newPatchPrescription(
          isChosen: event.isChosen,
          prescriptionItemId: event.prescriptionItemId,
        );

        yield NewPrescriptionPatched(message: consultation);
      } catch (e) {
        yield PrescriptionError(e: e as Exception);
      }
    } else if (event is NewPatchDosageInstructions) {
      yield PrescriptionLoading();

      try {
        final String result = await repository.newPatchDosageInstructions(
          data: event.data,
          consultationId: event.consultationId,
          calculatorId: event.calculatorId,
          isVacination: event.isVacination,
          prescriptionItemId: event.prescriptionItemId,
        );

        yield NewDosageInstructionsPatched(message: result);
      } catch (e) {
        yield PrescriptionError(e: e as Exception);
      }
    } else if (event is NewPatchPrescriptionLike) {
      yield PrescriptionLoading();

      try {
        final String response = await repository.newUpdatePrescriptionsLike(
          isFavorite: event.isFavorite,
          consultationId: event.consultationId,
          calculatorId: event.calculatorId,
          prescriptionItemId: event.prescriptionItemId,
        );

        yield NewPrescriptionPatchedLike(message: response);
      } catch (e) {
        yield PrescriptionError(e: e as Exception);
      }
    } else if (event is CreatePrescription) {
      yield PrescriptionLoading();

      try {
        final String response = await repository.createPrescription(
          entitiesIds: event.entitiesIds,
          instructions: event.instructions,
          prescriptionId: event.prescriptionId,
        );

        yield PrescriptionCreated(message: response);
      } catch (e) {
        yield PrescriptionError(e: e as Exception);
      }
    } else if (event is DeleteCustomPrescription) {
      yield PrescriptionLoading();

      try {
        final String response = await repository.deleteCustomPrescription(
          prescriptionItemId: event.prescriptionItemId,
          prescriptionId: event.prescriptionId,
        );

        yield PrescriptionItemDeleted(message: response);
      } catch (e) {
        yield PrescriptionError(e: e as Exception);
      }
    }
  }
}
