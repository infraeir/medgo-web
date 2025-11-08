class CompanionModel {
  final String id;
  final String name;
  final String gender;
  final String relationship;
  final String createdAt;
  final String updatedAt;

  CompanionModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.createdAt,
    required this.updatedAt,
    required this.relationship,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'relationship': relationship,
    };
  }

  factory CompanionModel.fromMap({required Map<String, dynamic> map}) {
    return CompanionModel(
      id: map['id'],
      name: map['name'] ?? 'N/A',
      gender: map['gender'] ?? 'N/A',
      createdAt: map['createdAt'] ?? 'N/A',
      updatedAt: map['updatedAt'] ?? 'N/A',
      relationship: map['relationship'] ?? 'N/A',
    );
  }



}
