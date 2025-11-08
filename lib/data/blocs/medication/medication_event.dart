import 'package:medgo/data/models/medication_model.dart';

abstract class MedicationsEvent {}

class GetMedications extends MedicationsEvent {
  final List<MedicationModel> loadedMedications;
  String? search;
  List<String>? types;
  List<String>? tokens;
  bool? sus;
  bool? popularPharmacy;

  GetMedications({
    this.search,
    this.types,
    this.tokens,
    this.sus,
    this.popularPharmacy,
    required this.loadedMedications,
  });

  List<Object> get props => [...loadedMedications];
}

class GetMedication extends MedicationsEvent {
  final String id;

  GetMedication({
    required this.id,
  });
}

class LoadMoreDataMedication extends MedicationsEvent {
  final int currentPage;
  final String search;
  final List<MedicationModel> loadedMedications;
  final List<String>? types;
  final List<String>? tokens;
  final bool? sus;
  final bool? popularPharmacy;

  LoadMoreDataMedication({
    required this.currentPage,
    required this.search,
    required this.loadedMedications,
    this.types,
    this.tokens,
    this.sus,
    this.popularPharmacy,
  });
}

class PostMedications extends MedicationsEvent {
  final String nomeMedicamento;

  PostMedications({
    required this.nomeMedicamento,
  });
}

class PutMedications extends MedicationsEvent {
  final String id;
  final String nomeMedicamento;

  PutMedications({
    required this.id,
    required this.nomeMedicamento,
  });
}

class DeleteMedication extends MedicationsEvent {
  final String id;

  DeleteMedication({
    required this.id,
  });
}
