import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medgo/data/blocs/consultation/consultation_event.dart';
import 'package:medgo/data/blocs/consultation/consultation_state.dart';
import 'package:medgo/data/repositories/consultation_repository.dart';
import 'package:medgo/data/models/block_model.dart';
import 'package:medgo/data/models/consultation_model.dart';
import 'package:medgo/widgets/dynamic_form/form_model.dart';

class ConsultationBloc extends Bloc<ConsultationEvent, ConsultationState> {
  final ConsultationRepository repository;

  ConsultationBloc({required this.repository})
      : super(InitialConsultationState());

  @override
  Stream<ConsultationState> mapEventToState(ConsultationEvent event) async* {
    if (event is GetConsultations) {
      yield ConsultationLoading();

      try {
        final List<ConsultationModel> consultations =
            await repository.getConsultations(idPatient: event.idPatient);

        yield ConsultationLoaded(consultations: consultations);
      } catch (e) {
        yield ConsultationError(e: e as Exception);
      }
    }

    if (event is GetConsultationById) {
      yield ConsultationLoading();

      try {
        final ConsultationModel consultation = await repository
            .getConsultationById(idConsultation: event.idConsultation);

        yield ConsultationByIdLoaded(consultation: consultation);
      } catch (e) {
        yield ConsultationError(e: e as Exception);
      }
    }

    if (event is GetConsultationReport) {
      yield ConsultationReportLoading();

      try {
        final BlocksModel report = await repository.getConsultationReport(
            idConsultation: event.idConsultation);

        yield ConsultationReportLoaded(
          report: report,
        );
      } catch (e) {
        yield ConsultationError(e: e as Exception);
      }
    }

    if (event is GetConsultationForm) {
      yield ConsultationLoading();

      try {
        final List<ResponseForm> form = await repository.getFormDynamic(
            idConsultation: event.idConsultation);

        yield ConsultationFormLoaded(
          form: form,
        );
      } catch (e) {
        yield ConsultationError(e: e as Exception);
      }
    }

    if (event is PostConsultation) {
      yield ConsultationLoading();

      try {
        final ConsultationModel consultation =
            await repository.postConsultation(
          companions: event.companions,
          patient: event.patient,
          pregnancy: event.pregnancy,
        );

        yield ConsultationPosted(consultation: consultation);
      } catch (e) {
        yield ConsultationError(e: e as Exception);
      }
    }

    if (event is PatchConsultation) {
      yield ConsultationLoading();

      try {
        final String consultation = await repository.updateConsultation(
          consultation: event.consultation,
          consultationId: event.consultationId,
        );

        yield ConsultationPatched(consultation: consultation);
      } catch (e) {
        yield ConsultationError(e: e as Exception);
      }
    }

    if (event is PatchPartialConsultation) {
      yield ConsultationPartialLoading();

      try {
        final String consultation = await repository.updateConsultationPartial(
          consultation: event.consultation,
          objectUpdate: event.objectUpdate,
        );

        yield ConsultationPatchedPartial(consultation: consultation);
      } catch (e) {
        yield ConsultationError(e: e as Exception);
      }
    }

    if (event is PatchMinimizedConsultation) {
      yield ConsultationMnimizedLoading();

      try {
        final String message = await repository.updateMinimized(
          objectUpdate: event.objectUpdate,
          consultation: event.consultation,
        );

        yield ConsultationDinamicoMinimized(message: message);
      } catch (e) {
        yield MinimizedError(e: e as Exception);
      }
    }

    if (event is FinishConsultation) {
      yield ConsultationFinalLoading();

      try {
        final String consultation = await repository.finishConsultation(
          consultation: event.consultation,
        );

        yield ConsultationFinished(consultation: consultation);
      } catch (e) {
        yield ConsultationError(e: e as Exception);
      }
    }

    if (event is DeleteConsultation) {
      yield ConsultationLoading();

      try {
        final String message = await repository.deleteConsultation(
          consultationId: event.consultationId,
        );

        yield ConsultationDeleted(message: message);
      } catch (e) {
        yield ConsultationError(e: e as Exception);
      }
    }
  }
}
