import 'package:medgo/data/models/conduct_model.dart';
import 'package:medgo/data/models/prescription_item_model.dart';

class SystemPrescriptionModel {
  final ConductModel conduct;
  final List<PrescriptionItemModel> items;

  SystemPrescriptionModel({
    required this.conduct,
    required this.items,
  });

  factory SystemPrescriptionModel.fromMap(Map<String, dynamic> map) {
    return SystemPrescriptionModel(
      conduct: ConductModel.fromMap(map['conduct'] ?? {}),
      items: (map['items'] as List<dynamic>?)
              ?.map((item) => PrescriptionItemModel.fromMap(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'conduct': conduct.toMap(),
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}
