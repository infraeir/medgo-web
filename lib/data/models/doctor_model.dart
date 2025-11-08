class DoctorModel {
  String? id;
  String? name;
  String? registrationNumber;

  DoctorModel({
    this.id,
    required this.name,
    required this.registrationNumber,
  });

  factory DoctorModel.fromMap({required Map<String, dynamic> map}) {
    return DoctorModel(
      id: map['id'],
      name: map['name'] ?? 'N/A',
      registrationNumber: map['registrationNumber'] ?? 'N/A',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'registrationNumber': registrationNumber,
    };
  }
}
