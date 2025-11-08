import 'package:medgo/strings/strings.dart';

class PrescriptionModel {
  String id;
  List<ConductModel> conducts;

  PrescriptionModel({
    required this.id,
    required this.conducts,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: json['id'],
      conducts: json['conducts'] != null
          ? json['conducts']
              .map<ConductModel>(
                (item) => ConductModel.fromJson(item),
              )
              .toList()
          : [],
    );
  }
}

class ConductModel {
  String id;
  String age;
  String dose;
  String name;
  String originType;
  bool accepted;
  List<MedicationPrescriptionModel> medications;
  List<String> chosenMedicationIds;

  ConductModel({
    required this.id,
    required this.age,
    required this.dose,
    required this.name,
    required this.originType,
    required this.accepted,
    required this.medications,
    required this.chosenMedicationIds,
  });

  factory ConductModel.fromJson(Map<String, dynamic> json) {
    return ConductModel(
      id: json['id'],
      age: json['age'],
      dose: json['dose'],
      name: json['name'],
      originType: json['originType'],
      accepted: json['accepted'],
      medications: json['medications'] != null
          ? json['medications']
              .map<MedicationPrescriptionModel>(
                (item) => MedicationPrescriptionModel.fromJson(item),
              )
              .toList()
          : [],
      chosenMedicationIds: json['chosenMedicationIds'] != null
          ? json['chosenMedicationIds']
              .map<String>(
                (item) => item.toString(),
              )
              .toList()
          : [],
    );
  }
}

class MedicationPrescriptionModel {
  String id;
  String tradeName;
  String presentation;
  String form;
  String activeIngredient;
  double activeIngredientConcentration;
  int viscosityDropsPerML;
  int bottleVolumeML;
  bool susAvailability;
  bool commercialAvailability;
  DosageInstructionsModel dosageInstructions;
  double? bottlePrice;

  MedicationPrescriptionModel({
    required this.id,
    required this.tradeName,
    required this.presentation,
    required this.form,
    required this.activeIngredient,
    required this.activeIngredientConcentration,
    required this.viscosityDropsPerML,
    required this.bottleVolumeML,
    required this.susAvailability,
    required this.commercialAvailability,
    required this.dosageInstructions,
    this.bottlePrice,
  });

  factory MedicationPrescriptionModel.fromJson(Map<String, dynamic> json) {
    return MedicationPrescriptionModel(
      id: json['id'],
      tradeName: json['tradeName'],
      presentation: json['presentation'],
      form: json['form'],
      activeIngredient: json['activeIngredient'],
      activeIngredientConcentration: json['activeIngredientConcentration'],
      viscosityDropsPerML: json['viscosityDropsPerML'],
      bottleVolumeML: json['bottleVolumeML'],
      susAvailability: json['susAvailability'],
      commercialAvailability: json['commercialAvailability'],
      dosageInstructions:
          DosageInstructionsModel.fromJson(json['dosageInstructions']),
      bottlePrice: json['bottlePrice'],
    );
  }
}

class DosageInstructionsModel {
  String type;
  bool isFavorite;
  DosageDataModel data;
  CalculatedDosageModel calculatedDosage;
  List<String> manualDosage;

  DosageInstructionsModel({
    required this.type,
    required this.isFavorite,
    required this.data,
    required this.calculatedDosage,
    required this.manualDosage,
  });

  factory DosageInstructionsModel.fromJson(Map<String, dynamic> json) {
    return DosageInstructionsModel(
      type: json['type'] ?? Strings.simple,
      isFavorite: json['isFavorite'] ?? false,
      data: DosageDataModel.fromJson(json['data'] ?? {}),
      calculatedDosage:
          CalculatedDosageModel.fromJson(json['calculatedDosage']),
      manualDosage: json['manualDosage'] != null
          ? List<String>.from(json['manualDosage'])
          : [],
    );
  }
}

class DosageDataModel {
  int? quantity;
  String? pleasureForm;
  String? additionalInstructions;
  String? medicationPresentation;
  String? intervalBetweenDoses;
  String? reference;
  List<String>? useTurns;
  List<String>? meals;
  List<String>? schedules;
  int? timesADay;
  DurationTreatmentModel? durationTreatmentData;

  DosageDataModel({
    this.quantity,
    this.medicationPresentation,
    this.additionalInstructions,
    this.pleasureForm,
    this.intervalBetweenDoses,
    this.useTurns,
    this.meals,
    this.schedules,
    this.reference,
    this.timesADay,
    this.durationTreatmentData,
  });

  factory DosageDataModel.fromJson(Map<String, dynamic> json) {
    return DosageDataModel(
      quantity: json['quantity'],
      medicationPresentation: json['medicationPresentation'],
      useTurns: json['useTurns'],
      meals: json['meals'],
      schedules: json['schedules'],
      reference: json['reference'],
      pleasureForm: json['pleasureForm'],
      additionalInstructions: json['additionalInstructions'],
      intervalBetweenDoses: json['intervalBetweenDoses'],
      timesADay: json['timesADay'],
      durationTreatmentData: json['durationTreatmentData'] != null
          ? DurationTreatmentModel.fromJson(
              json['durationTreatmentData'],
            )
          : null,
    );
  }
}

class CalculatedDosageModel {
  bool continuousUse;
  String dosage;

  CalculatedDosageModel({
    required this.continuousUse,
    required this.dosage,
  });

  factory CalculatedDosageModel.fromJson(Map<String, dynamic> json) {
    return CalculatedDosageModel(
      continuousUse: json['continuousUse'],
      dosage: json['dosage'],
    );
  }
}

class DurationTreatmentModel {
  String? form;
  String? unit;
  int? duration;

  DurationTreatmentModel({
    required this.form,
    required this.unit,
    required this.duration,
  });

  factory DurationTreatmentModel.fromJson(Map<String, dynamic> json) {
    return DurationTreatmentModel(
      form: json['form'],
      unit: json['unit'],
      duration: json['duration'],
    );
  }
}
