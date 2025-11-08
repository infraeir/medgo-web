class ConductModel {
  String id;
  String name;
  String originType;
  bool accepted;

  ConductModel({
    required this.id,
    required this.name,
    required this.originType,
    required this.accepted,
  });

  factory ConductModel.fromJson(Map<String, dynamic> json) {
    return ConductModel(
      id: json['id'],
      name: json['name'],
      originType: json['originType'],
      accepted: json['accepted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'originType': originType,
      'accepted': accepted,
    };
  }
}