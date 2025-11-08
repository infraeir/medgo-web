class CalculatorsModel {
  final String id;
  final String name;
  final String type;
  final String status;
  final String consultationType;
  final List<String> references;

  CalculatorsModel({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.consultationType,
    required this.references,
  });

  factory CalculatorsModel.fromMap({required Map<String, dynamic> map}) {
    return CalculatorsModel(
      id: map['id'],
      name: map['name'],
      type: map['type'] ?? 'N/A',
      status: map['status'] ?? 'N/A',
      consultationType: map['consultationType'] ?? 'N/A',
      references: (map['references'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
  factory CalculatorsModel.fromJson(Map<String, dynamic> json) {
    return CalculatorsModel(
      id: json['id'],
      name: json['name'],
      type: json['type'] ?? 'N/A',
      status: json['status'] ?? 'N/A',
      consultationType: json['consultationType'] ?? 'N/A',
      references: (json['references'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'status': status,
      'consultationType': consultationType,
      'references': references,
    };
  }
}
