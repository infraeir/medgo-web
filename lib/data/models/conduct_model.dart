class ConductModel {
  final String id;
  final String name;
  final String originType;
  final String dose;
  final String age;
  final bool accepted;

  ConductModel({
    required this.id,
    required this.name,
    required this.originType,
    required this.dose,
    required this.age,
    required this.accepted,
  });

  factory ConductModel.fromMap(Map<String, dynamic> map) {
    return ConductModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      originType: map['originType'] ?? '',
      dose: map['dose'] ?? '',
      age: map['age'] ?? '',
      accepted: map['accepted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'originType': originType,
      'dose': dose,
      'age': age,
      'accepted': accepted,
    };
  }
}
