import 'package:medgo/data/models/patients_model.dart';

class PatientsPaginationModel {
  final List<PatientsModel> patients;
  final int limit;
  final int page;
  final int totalPages;
  final int total;

  PatientsPaginationModel({
    required this.patients,
    required this.limit,
    required this.page,
    required this.totalPages,
    required this.total,
  });
}
