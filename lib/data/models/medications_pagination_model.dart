import 'package:medgo/data/models/medication_model.dart';

class MedicationsPaginationModel {
  final List<MedicationModel> medications;
  final int total;
  final int limit;
  final int page;
  final int totalPages;
  final bool hasPrevPage;
  final bool hasNextPage;
  final int? prevPage;
  final int? nextPage;

  MedicationsPaginationModel({
    required this.medications,
    required this.total,
    required this.limit,
    required this.page,
    required this.totalPages,
    required this.hasPrevPage,
    required this.hasNextPage,
    this.prevPage,
    this.nextPage,
  });

  factory MedicationsPaginationModel.fromMap(Map<String, dynamic> map) {
    return MedicationsPaginationModel(
      medications: (map['data'] as List<dynamic>?)
              ?.map((item) => MedicationModel.fromMap(item))
              .toList() ??
          [],
      total: map['total'] ?? 0,
      limit: map['limit'] ?? 0,
      page: map['page'] ?? 0,
      totalPages: map['totalPages'] ?? 0,
      hasPrevPage: map['hasPrevPage'] ?? false,
      hasNextPage: map['hasNextPage'] ?? false,
      prevPage: map['prevPage'],
      nextPage: map['nextPage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': medications.map((item) => item.toMap()).toList(),
      'total': total,
      'limit': limit,
      'page': page,
      'totalPages': totalPages,
      'hasPrevPage': hasPrevPage,
      'hasNextPage': hasNextPage,
      'prevPage': prevPage,
      'nextPage': nextPage,
    };
  }
}
