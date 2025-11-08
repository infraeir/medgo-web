import 'package:medgo/data/models/new_conduct_model.dart';

class NewPrescriptionModel {
  String id;
  String? consultationId;
  String? calculatorId;
  ConductModel conduct;
  List<ItemModel> items;

  NewPrescriptionModel({
    required this.id,
    this.calculatorId,
    this.consultationId,
    required this.conduct,
    required this.items,
  });

  factory NewPrescriptionModel.fromJson(Map<String, dynamic> json) {
    return NewPrescriptionModel(
      id: json['id'],
      consultationId: json['consultationId'],
      conduct: ConductModel.fromJson(json['conduct']),
      items: List<ItemModel>.from(
          json['items'].map((item) => ItemModel.fromJson(item))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'consultationId': consultationId,
      'calculatorId': calculatorId,
      'conduct': conduct.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class ItemModel {
  String id;
  String type;
  EntityModel entity;
  InstructionsModel instructions;
  bool isChosen;
  bool isFavorite;

  ItemModel({
    required this.id,
    required this.type,
    required this.entity,
    required this.instructions,
    required this.isChosen,
    required this.isFavorite,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      type: json['type'],
      entity: EntityModel.fromJson(json['entity']),
      instructions: InstructionsModel.fromJson(json['instructions']),
      isChosen: json['isChosen'],
      isFavorite: json['isFavorite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'entity': entity.toJson(),
      'instructions': instructions.toJson(),
      'isChosen': isChosen,
      'isFavorite': isFavorite,
    };
  }
}

class EntityModel {
  String id;
  String vaccineName;
  int doseNumber;
  String tradeName;
  String presentation;
  String form;
  String activeIngredient;
  num activeIngredientConcentration;
  int viscosityDropsPerML;
  int bottleVolumeML;
  bool susAvailability;
  bool commercialAvailability;
  num bottlePrice;

  EntityModel({
    required this.id,
    required this.vaccineName,
    required this.doseNumber,
    required this.tradeName,
    required this.presentation,
    required this.form,
    required this.activeIngredient,
    required this.activeIngredientConcentration,
    required this.viscosityDropsPerML,
    required this.bottleVolumeML,
    required this.susAvailability,
    required this.commercialAvailability,
    required this.bottlePrice,
  });

  factory EntityModel.fromJson(Map<String, dynamic> json) {
    return EntityModel(
      id: json['id'] ?? '',
      vaccineName: json['vaccineName'] ?? '',
      doseNumber: json['doseNumber'] ?? 0,
      tradeName: json['tradeName'] ?? '',
      presentation: json['presentation'] ?? '',
      form: json['form'] ?? '',
      activeIngredient: json['activeIngredient'] ?? '',
      activeIngredientConcentration:
          json['activeIngredientConcentration'] != null
              ? json['activeIngredientConcentration'] * 1.0
              : 0.0,
      viscosityDropsPerML: json['viscosityDropsPerML'] ?? 0,
      bottleVolumeML: json['bottleVolumeML'] ?? 0,
      susAvailability: json['susAvailability'] ?? false,
      commercialAvailability: json['commercialAvailability'] ?? false,
      bottlePrice:
          json['bottlePrice'] != null ? json['bottlePrice'] * 1.0 : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vaccineName': vaccineName,
      'doseNumber': doseNumber,
    };
  }
}

class InstructionsModel {
  String type;
  String prescription;
  String duration;
  List<dynamic> manualMedicalAdvice;
  DosageDataModel data;

  InstructionsModel({
    required this.type,
    required this.prescription,
    required this.manualMedicalAdvice,
    required this.data,
    required this.duration,
  });

  factory InstructionsModel.fromJson(Map<String, dynamic> json) {
    return InstructionsModel(
      type: json['type'],
      prescription: json['prescription'] ?? '',
      manualMedicalAdvice: json['manualMedicalAdvice'] ?? [],
      data: DosageDataModel.fromJson(json['data'] ?? {}),
      duration: json['duration'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
    };
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
      //TODO
      medicationPresentation: 'oral_solution_drops',

      // Conversão segura para List<String>
      useTurns: _convertToStringList(json['useTurns']),
      meals: _convertToStringList(json['meals']),
      schedules: _convertToStringList(json['schedules']),

      reference: json['reference'],
      pleasureForm: json['pleasureForm'],

      // Conversão segura para String
      additionalInstructions: _convertToString(json['additionalInstructions']),

      intervalBetweenDoses: json['intervalBetweenDoses'],
      timesADay: json['timesADay'],

      durationTreatmentData: json['durationTreatmentData'] != null
          ? DurationTreatmentModel.fromJson(
              json['durationTreatmentData'],
            )
          : null,
    );
  }

  // Método auxiliar para converter para List<String>
  static List<String>? _convertToStringList(dynamic value) {
    if (value == null) return null;

    // Se já for uma List<String>, retorne diretamente
    if (value is List<String>) return value;

    // Se for uma List<dynamic>, converta para List<String>
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }

    // Se for um único valor, coloque em uma lista
    return [value.toString()];
  }

  // Método auxiliar para conversão segura para String
  static String? _convertToString(dynamic value) {
    if (value == null) return null;

    // Se já for uma String, retorne diretamente
    if (value is String) return value;

    // Converta para String
    return value.toString();
  }
}

class CalculatedDosageModel {
  String dosage;
  bool continuousUse;

  CalculatedDosageModel({
    required this.dosage,
    required this.continuousUse,
  });

  factory CalculatedDosageModel.fromJson(Map<String, dynamic> json) {
    return CalculatedDosageModel(
      dosage: json['dosage'] ?? '',
      continuousUse: json['continuousUse'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dosage': dosage,
      'continuousUse': continuousUse,
    };
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
