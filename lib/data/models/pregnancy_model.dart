class PregnancyModel {
  bool? plannedPregnancy;
  String? pregnancyType;
  int? totalTwins;
  bool? riskPregnancy;
  String? riskPregnancyDetail;
  bool? prenatalCareCompleted;

  PregnancyModel({
    this.plannedPregnancy,
    required this.pregnancyType,
    required this.totalTwins,
    this.riskPregnancy,
    required this.riskPregnancyDetail,
    required this.prenatalCareCompleted,
  });

  factory PregnancyModel.fromMap({required Map<String, dynamic> map}) {
    return PregnancyModel(
      plannedPregnancy: map['plannedPregnancy'],
      pregnancyType: map['pregnancyType'],
      totalTwins: map['totalTwins'],
      riskPregnancy: map['riskPregnancy'],
      riskPregnancyDetail: map['riskPregnancyDetail'],
      prenatalCareCompleted: map['prenatalCareCompleted'],
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'plannedPregnancy': plannedPregnancy,
      'pregnancyType': pregnancyType,
      'totalTwins': totalTwins,
      'riskPregnancy': riskPregnancy,
      'riskPregnancyDetail': riskPregnancyDetail,
      'prenatalCareCompleted': prenatalCareCompleted,
    };
  }

}
