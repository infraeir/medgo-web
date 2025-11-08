class DischargeModel {
  String? date;
  num? cephalicPerimeter;
  num? length;
  num? weight;

  DischargeModel({
    this.date,
    this.cephalicPerimeter,
    this.length,
    this.weight,
  });

  factory DischargeModel.fromMap({required Map<String, dynamic> map}) {
    return DischargeModel(
      date: map['date'],
      cephalicPerimeter: map['cephalicPerimeter'],
      length: map['length'],
      weight: map['weight'],
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'date': date,
      'cephalicPerimeter': cephalicPerimeter,
      'length': length,
      'weight': weight,
    };
  }

}
