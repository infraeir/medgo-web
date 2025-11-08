class FoodDataModel {
  String? foodType;
  bool? difficultyBreastfeeding;
  String? reasonForDifficultyBreastfeeding;
  bool? stoppedBreastfeeding;
  num? stoppedBreastfeedingAge;
  bool? maternalIronSupplementation;
  String? approximateWeaningDate;
  String? reasonForEarlyWeaning;


  FoodDataModel({
    this.foodType,
    this.difficultyBreastfeeding,
    this.reasonForDifficultyBreastfeeding,
    this.stoppedBreastfeeding,
    this.stoppedBreastfeedingAge,
    this.maternalIronSupplementation,
    this.approximateWeaningDate,
    this.reasonForEarlyWeaning,
  });

  factory FoodDataModel.fromMap({required Map<String, dynamic> map}) {
    return FoodDataModel(
      foodType: map['foodType'],
      difficultyBreastfeeding: map['difficultyBreastfeeding'],
      reasonForDifficultyBreastfeeding: map['reasonForDifficultyBreastfeeding'],
      stoppedBreastfeeding: map['stoppedBreastfeeding'],
      stoppedBreastfeedingAge: map['stoppedBreastfeedingAge'],
      maternalIronSupplementation: map['maternalIronSupplementation'],
      approximateWeaningDate: map['approximateWeaningDate'],
      reasonForEarlyWeaning: map['reasonForEarlyWeaning'],
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'foodType': foodType,
      'difficultyBreastfeeding': difficultyBreastfeeding,
      'reasonForDifficultyBreastfeeding': reasonForDifficultyBreastfeeding,
      'stoppedBreastfeeding': stoppedBreastfeeding,
      'stoppedBreastfeedingAge': stoppedBreastfeedingAge,
      'maternalIronSupplementation': maternalIronSupplementation,
      'approximateWeaningDate': approximateWeaningDate,
      'reasonForEarlyWeaning': reasonForEarlyWeaning,
    };
  }

}
