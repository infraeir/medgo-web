import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medgo/data/blocs/acompanying/acompanying_event.dart';
import 'package:medgo/data/blocs/acompanying/acompanying_state.dart';
import 'package:medgo/data/repositories/acompanying_repository.dart';
import 'package:medgo/data/models/companion_model.dart';

class CompanionBloc extends Bloc<CompanionEvent, CompanionState> {
  final CompanionRepository repository;

  CompanionBloc({required this.repository}) : super(InitialCompanionState());

  @override
  Stream<CompanionState> mapEventToState(CompanionEvent event) async* {
    if (event is PostCompanion) {
      yield CompanionLoading();

      try {
        final String mensagem = await repository.postCompanion(
          gender: event.gender,
          idPatient: event.idPatient,
          name: event.name,
          relationship: event.relationship,
          relationshipAddInfo: event.relationshipAddInfo ?? '',
        );

        yield CompanionPosted(mensagem: mensagem);
      } catch (e) {
        yield CompanionError(e: e as Exception);
      }
    } else if (event is PostExtraCompanion) {
      yield CompanionLoading();
      try {
        final List<CompanionModel> companions =
            await repository.postExtraCompanion(
                consultationsID: event.consultationsID,
                name: event.name,
                gender: event.gender,
                relationship: event.relationship,
                relationshipAddInfo: event.relationshipAddInfo);
        yield CompanionPatched(companions: companions);
      } catch (e) {
        yield CompanionError(e: e as Exception);
      }
    } else if (event is PutCompanion) {
      yield CompanionLoading();

      try {
        final String mensagem = await repository.putCompanion(
          gender: event.gender,
          idPatient: event.idPatient,
          name: event.name,
          relationship: event.relationship,
          idCompanion: event.idCompanion,
          relationshipAddInfo: event.relationshipAddInfo,
        );

        yield CompanionPosted(mensagem: mensagem);
      } catch (e) {
        yield CompanionError(e: e as Exception);
      }
    } else if (event is DeleteCompanion) {
      yield CompanionLoading();

      try {
        final String mensagem = await repository.deleteCompanion(
          idCompanion: event.companionID,
        );

        yield CompanionDeleted(mensagem: mensagem);
      } catch (e) {
        yield CompanionError(e: e as Exception);
      }
    } else if (event is PatchtExtraCompanion) {
      yield CompanionLoading();

      try {
        final String mensagem = await repository.patchExtraCompanion(
          companionID: event.companionID,
          consultationsID: event.consultationsID,
        );

        yield CompanionExtraPacthed(mensagem: mensagem);
      } catch (e) {
        yield CompanionError(e: e as Exception);
      }
    } else if (event is DeleteExtraCompanion) {
      yield CompanionLoading();

      try {
        final String mensagem = await repository.deleteExtraCompanion(
          companionID: event.companionID,
          consultationsID: event.consultationsID,
        );

        yield CompanionExtraDeleted(mensagem: mensagem);
      } catch (e) {
        yield CompanionError(e: e as Exception);
      }
    }
  }
}
