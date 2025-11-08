class PhysicalExamModel {
  num? headCircumference;
  num? length;
  num? weight;
  num? heartFrequency;
  num? respiratoryFrequency;



  PhysicalExamModel({
    this.headCircumference,
    this.length,
    this.weight,
    this.heartFrequency,
    this.respiratoryFrequency,
  });

  factory PhysicalExamModel.fromMap({required Map<String, dynamic> map}) {
    return PhysicalExamModel(
      headCircumference: map['headCircumference'],
      length: map['length'],
      weight: map['weight'],
      heartFrequency: map['heartFrequency'],
      respiratoryFrequency: map['respiratoryFrequency'],
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'headCircumference': headCircumference,
      'length': length,
      'weight': weight,
      'heartFrequency': heartFrequency,
      'respiratoryFrequency': respiratoryFrequency,
    };
  }

}
