class LastConsultatioModel {
  final String id;
  final String type;
  final String status;
  final String createdAt;

  LastConsultatioModel({
    required this.id,
    required this.type,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'status': status,
      'createdAt': createdAt,
    };
  }

  factory LastConsultatioModel.fromMap({required Map<String, dynamic> map}) {
    return LastConsultatioModel(
      id: map['id'] ?? '1',
      type: map['type'] ?? 'N/A',
      status: map['status'] ?? 'not_initialized',
      createdAt: map['created_at'] ?? 'N/A',
    );
  }
}
