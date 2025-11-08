import 'package:medgo/data/models/patients_model.dart';

abstract class PatientsEvent {}

class GetPatients extends PatientsEvent {
  final List<PatientsModel> loadedPatients;
  final String search;

  GetPatients({
    required this.search,
    required this.loadedPatients,
  });

  List<Object> get props => [...loadedPatients];
}

class GetPatient extends PatientsEvent {
  final String id;

  GetPatient({
    required this.id,
  });
}

class LoadMoreData extends PatientsEvent {
  final int currentPage;
  final String search;
  final List<PatientsModel> loadedPatients;

  LoadMoreData({
    required this.currentPage,
    required this.search,
    required this.loadedPatients,
  });
}

class PostPatients extends PatientsEvent {
  final String nome;
  final String dataNasc;
  final String sexo;
  final String cor;
  final String? nomeMae;
  final String? nomePai;

  PostPatients({
    required this.cor,
    required this.nome,
    required this.nomeMae,
    required this.nomePai,
    required this.dataNasc,
    required this.sexo,
  });
}

class PutPatients extends PatientsEvent {
  final String id;
  final String nome;
  final String dataNasc;
  final String sexo;
  final String cor;
  final String nomeMae;
  final String nomePai;

  PutPatients({
    required this.id,
    required this.cor,
    required this.nome,
    required this.nomeMae,
    required this.nomePai,
    required this.dataNasc,
    required this.sexo,
  });
}

class DeletePatient extends PatientsEvent {
  final String id;

  DeletePatient({
    required this.id,
  });
}
