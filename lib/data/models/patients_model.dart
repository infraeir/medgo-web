import 'package:medgo/data/models/companion_model.dart';
import 'package:medgo/data/models/last_consultation.model.dart';

class PatientsModel {
  final String id;
  final String name;
  final String gender;
  final String dateOfBirth;
  final String ageAtConsultation;
  final String ethnicity;
  final String motherName;
  final String fatherName;
  final String age;
  String? cpf;
  final String lastConsultationAt;
  final LastConsultatioModel lastConsultationData;
  final String createdAt;
  final String updatedAt;
  final List<CompanionModel> companions;

  PatientsModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.dateOfBirth,
    required this.ageAtConsultation,
    required this.ethnicity,
    required this.motherName,
    required this.fatherName,
    required this.age,
    required this.lastConsultationAt,
    required this.lastConsultationData,
    required this.createdAt,
    required this.updatedAt,
    required this.companions,
    this.cpf,
  });

  factory PatientsModel.fromMap({required Map<String, dynamic> map}) {
    return PatientsModel(
      id: map['id'],
      name: map['name'],
      gender: map['gender'] ?? 'N/A',
      dateOfBirth: map['dateOfBirth'] ?? 'N/A',
      ageAtConsultation: map['ageAtConsultation'] ?? 'N/A',
      age: map['age'] ?? 'N/A',
      ethnicity: map['ethnicity'] ?? 'N/A',
      motherName: map['motherName'] ?? 'N/A',
      fatherName: map['fatherName'] ?? 'N/A',
      lastConsultationAt: 'N/A',
      cpf: map['cpf'] ?? '000.000.000-00',
      lastConsultationData: LastConsultatioModel.fromMap(
        map: map['lastConsultationData'] ?? {},
      ),
      createdAt: map['createdAt'] ?? 'N/A',
      updatedAt: map['updatedAt'] ?? 'N/A',
      companions: map['companions'] != null
          ? map['companions']
              .map<CompanionModel>(
                (item) => CompanionModel.fromMap(map: item),
              )
              .toList()
          : [],
    );
  }

  factory PatientsModel.fromJson(Map<String, dynamic> json) {
    return PatientsModel(
      id: json['id'],
      name: json['name'],
      gender: json['gender'] ?? 'N/A',
      dateOfBirth: json['dateOfBirth'] ?? 'N/A',
      ageAtConsultation: json['ageAtConsultation'] ?? 'N/A',
      age: json['age'] ?? 'N/A',
      ethnicity: json['ethnicity'] ?? 'N/A',
      motherName: json['motherName'] ?? 'N/A',
      fatherName: json['fatherName'] ?? 'N/A',
      lastConsultationAt: json['lastConsultationAt'] ?? 'N/A',
      lastConsultationData: LastConsultatioModel.fromMap(
        map: json['lastConsultationData'] ?? {},
      ),
      createdAt: json['createdAt'] ?? 'N/A',
      updatedAt: json['updatedAt'] ?? 'N/A',
      companions: json['companions'] != null
          ? (json['companions'] as List)
              .map<CompanionModel>(
                (item) => CompanionModel.fromMap(map: item),
              )
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'ethnicity': ethnicity,
      'motherName': motherName,
      'fatherName': fatherName,
      'age': age,
      'lastConsultationAt': lastConsultationAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'companions': companions.map((companion) => companion.toJson()).toList(),
    };
  }
}
