import 'package:medgo/data/models/doctor_model.dart';
import 'package:medgo/widgets/dynamic_form/form_model.dart';

class CalculatorResponseFormModel {
  final String id;
  final String type;
  final String status;
  final String consultationType;
  final bool hasPrescription;
  final DoctorModel doctor;
  final List<String> allowedDiagnosesTypes;
  final List<ResponseForm> responseForm;

  CalculatorResponseFormModel({
    required this.id,
    required this.type,
    required this.status,
    required this.consultationType,
    required this.responseForm,
    required this.allowedDiagnosesTypes,
    required this.doctor,
    required this.hasPrescription,
  });

  factory CalculatorResponseFormModel.fromMap(
      {required Map<String, dynamic> map}) {
    return CalculatorResponseFormModel(
      id: map['id'],
      type: map['type'] ?? 'N/A',
      status: map['status'] ?? 'N/A',
      consultationType: map['consultationType'] ?? 'N/A',
      hasPrescription: map['hasPrescription'] ?? true,
      doctor: DoctorModel.fromMap(map: map['doctor']),
      allowedDiagnosesTypes: (map['allowedDiagnosesTypes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      responseForm: (map['form'] as List<dynamic>?)
              ?.map((e) => ResponseForm.fromJson(e))
              .toList() ??
          [],
    );
  }
  factory CalculatorResponseFormModel.fromJson(Map<String, dynamic> json) {
    return CalculatorResponseFormModel(
      id: json['id'],
      type: json['type'] ?? 'N/A',
      status: json['status'] ?? 'N/A',
      doctor: DoctorModel.fromMap(map: json['doctor']),
      consultationType: json['consultationType'] ?? 'N/A',
      hasPrescription: json['hasPrescription'] ?? true,
      allowedDiagnosesTypes: (json['allowedDiagnosesTypes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      responseForm: (json['form'] as List<dynamic>?)
              ?.map((e) => ResponseForm.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'status': status,
      'consultationType': consultationType,
      'hasPrescription': hasPrescription,
    };
  }
}
