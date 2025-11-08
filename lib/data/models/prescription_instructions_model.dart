class PrescriptionInstructionsModel {
  final String type;
  final String prescription;
  final String duration;

  PrescriptionInstructionsModel({
    required this.type,
    required this.prescription,
    required this.duration,
  });

  factory PrescriptionInstructionsModel.fromMap(Map<String, dynamic> map) {
    return PrescriptionInstructionsModel(
      type: map['type'] ?? '',
      prescription: map['prescription'] ?? '',
      duration: map['duration'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'prescription': prescription,
      'duration': duration,
    };
  }
}
