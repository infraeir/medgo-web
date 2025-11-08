import 'package:medgo/data/models/prescription_item_model.dart';
import 'package:medgo/data/models/system_prescription_model.dart';

class PrescriptionResponseModel {
  final String id;
  final String origin;
  final String? consultationId;
  final String? calculatorId;
  final List<SystemPrescriptionModel> system;
  final List<PrescriptionItemModel> custom;

  PrescriptionResponseModel({
    required this.id,
    required this.origin,
    this.consultationId,
    this.calculatorId,
    required this.system,
    required this.custom,
  });

  factory PrescriptionResponseModel.fromMap(Map<String, dynamic> map) {
    return PrescriptionResponseModel(
      id: map['id'] ?? '',
      origin: map['origin'] ?? '',
      consultationId: map['consultationId'],
      calculatorId: map['calculatorId'],
      system: (map['system'] as List<dynamic>?)
              ?.map((item) => SystemPrescriptionModel.fromMap(item))
              .toList() ??
          [],
      custom: (map['custom'] as List<dynamic>?)
              ?.map((item) => PrescriptionItemModel.fromMap(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'origin': origin,
      'consultationId': consultationId,
      'system': system.map((item) => item.toMap()).toList(),
      'custom': custom,
    };
  }
}
