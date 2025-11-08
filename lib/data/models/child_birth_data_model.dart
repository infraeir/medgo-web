class ChildBirthDataModel {
  final String? birthplace;
  final String? birthplaceName;
  final String? childbirthType;
  final String? birthdate;
  final String? birthHour;
  final String? reasonForCesarean;
  final bool? hadBirthCompanion;
  final bool? skinToSkinContact;
  final bool? breastfedInFirstHour;
  final bool? timelyUmbilicalCordClamping;
  final bool? neonatalHospitalization;
  final ApgarModel? apgar;
  final BirthBodyDataModel? birthBodyData;
  final GestationalAgeModel? gestationalAge;

  ChildBirthDataModel({
    this.birthdate, 
    this.birthHour,
    required this.birthplace,
    required this.birthplaceName,
    required this.childbirthType,
    required this.reasonForCesarean,
    required this.hadBirthCompanion,
    required this.skinToSkinContact,
    required this.breastfedInFirstHour,
    required this.timelyUmbilicalCordClamping,
    required this.neonatalHospitalization,
    required this.apgar,
    required this.birthBodyData,
    required this.gestationalAge,
  });

  factory ChildBirthDataModel.fromMap({required Map<String, dynamic> map}) {
    return ChildBirthDataModel(
      birthdate: map['birthdate'],
      birthHour: map['birthHour'],
      birthplace: map['birthplace'],
      birthplaceName: map['birthplaceName'],
      childbirthType: map['childbirthType'],
      reasonForCesarean: map['reasonForCesarean'],
      hadBirthCompanion: map['hadBirthCompanion'],
      skinToSkinContact: map['skinToSkinContact'],
      breastfedInFirstHour: map['breastfedInFirstHour'],
      timelyUmbilicalCordClamping: map['timelyUmbilicalCordClamping'],
      neonatalHospitalization: map['neonatalHospitalization'],
      apgar: map['apgar'] != null ? ApgarModel.fromMap(map: map['apgar']) : null,
      birthBodyData: map['birthBodyData'] != null ? BirthBodyDataModel.fromMap(map: map['birthBodyData']) : null,
      gestationalAge: map['gestationalAge'] != null ? GestationalAgeModel.fromMap(map: map['gestationalAge']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'birthdate' : birthdate,
      'birthHour': birthHour,
      'birthplace': birthplace,
      'birthplaceName': birthplaceName,
      'childbirthType': childbirthType,
      'reasonForCesarean': reasonForCesarean,
      'hadBirthCompanion': hadBirthCompanion,
      'skinToSkinContact': skinToSkinContact,
      'breastfedInFirstHour': breastfedInFirstHour,
      'timelyUmbilicalCordClamping': timelyUmbilicalCordClamping,
      'neonatalHospitalization': neonatalHospitalization,
      'apgar': apgar?.toJson(),
      'birthBodyData': birthBodyData?.toJson(),
      'gestationalAge': gestationalAge?.toJson(),
    };
  }
}

class ApgarModel {
  final int? firstMinute;
  final int? fifthMinute;

  ApgarModel({
    required this.firstMinute,
    required this.fifthMinute,
  });

  factory ApgarModel.fromMap({required Map<String, dynamic> map}) {
    return ApgarModel(
      firstMinute: map['firstMinute'] ?? 0,
      fifthMinute: map['fifthMinute'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstMinute': firstMinute,
      'fifthMinute': fifthMinute,
    };
  }
}

class BirthBodyDataModel {
  final double? headCircumference;
  final double? length;
  final double? weight;

  BirthBodyDataModel({
    required this.headCircumference,
    required this.length,
    required this.weight,
  });

  factory BirthBodyDataModel.fromMap({required Map<String, dynamic> map}) {
    return BirthBodyDataModel(
      headCircumference: map['headCircumference'] ?? 0.0,
      length: map['length'] ?? 0.0,
      weight: map['weight'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'headCircumference': headCircumference,
      'length': length,
      'weight': weight,
    };
  }
}

class GestationalAgeModel {
  final int? inDays;
  final int? inWeeks;
  final String? method;
  final String? examDescription;

  GestationalAgeModel({
    required this.inDays,
    required this.inWeeks,
    required this.method,
    required this.examDescription,
  });

  factory GestationalAgeModel.fromMap({required Map<String, dynamic> map}) {
    return GestationalAgeModel(
      inDays: map['inDays'],
      inWeeks: map['inWeeks'],
      method: map['method'],
      examDescription: map['examDescription'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inDays': inDays,
      'inWeeks': inWeeks,
      'method': method,
      'examDescription': examDescription,
    };
  }
}
