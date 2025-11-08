import 'package:medgo/data/models/dynamic_prescription_filter_model.dart';

class MedicationModel {
  final String? searchTerm;
  final String displayName;
  final String type;
  final List<MedicationItemModel> medications;
  final Map<String, PresentationModel> presentationsByRegistration;
  final bool availableInPopularPharmacy;
  final bool availableInSUS;
  final bool isControlledSubstance;
  final DynamicPrescriptionFilterModel? filters;

  MedicationModel({
    this.searchTerm,
    required this.displayName,
    required this.type,
    required this.medications,
    required this.presentationsByRegistration,
    required this.availableInPopularPharmacy,
    required this.availableInSUS,
    required this.isControlledSubstance,
    this.filters,
  });

  factory MedicationModel.fromMap(Map<String, dynamic> map) {
    final Map<String, PresentationModel> presentations = {};

    if (map['presentationsByRegistration'] != null) {
      final presentationsMap =
          map['presentationsByRegistration'] as Map<String, dynamic>;
      for (final entry in presentationsMap.entries) {
        presentations[entry.key] = PresentationModel.fromMap(entry.value);
      }
    }

    return MedicationModel(
      searchTerm: map['searchTerm'],
      displayName: map['displayName'] ?? '',
      type: map['type'] ?? '',
      medications: (map['medications'] as List<dynamic>?)
              ?.map((item) => MedicationItemModel.fromMap(item))
              .toList() ??
          [],
      presentationsByRegistration: presentations,
      availableInPopularPharmacy: map['availableInPopularPharmacy'] ?? false,
      availableInSUS: map['availableInSUS'] ?? false,
      isControlledSubstance: map['isControlledSubstance'] ?? false,
      filters: map['filters'] != null
          ? DynamicPrescriptionFilterModel.fromMap(map['filters'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'searchTerm': searchTerm,
      'displayName': displayName,
      'type': type,
      'medications': medications.map((item) => item.toMap()).toList(),
      'presentationsByRegistration': presentationsByRegistration
          .map((key, value) => MapEntry(key, value.toMap())),
      'availableInPopularPharmacy': availableInPopularPharmacy,
      'availableInSUS': availableInSUS,
      'isControlledSubstance': isControlledSubstance,
      'filters': filters?.toMap(),
    };
  }
}

class MedicationItemModel {
  final String id;
  final String name;
  final String anvisaRegistrationCode;
  final String? tradeName;

  MedicationItemModel({
    required this.id,
    required this.name,
    required this.anvisaRegistrationCode,
    this.tradeName,
  });

  factory MedicationItemModel.fromMap(Map<String, dynamic> map) {
    return MedicationItemModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      anvisaRegistrationCode: map['anvisaRegistrationCode'] ?? '',
      tradeName: map['tradeName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'anvisaRegistrationCode': anvisaRegistrationCode,
      'tradeName': tradeName,
    };
  }
}

class ActiveIngredientModel {
  final String name;
  final String dcbCode;

  ActiveIngredientModel({
    required this.name,
    required this.dcbCode,
  });

  factory ActiveIngredientModel.fromMap(Map<String, dynamic> map) {
    return ActiveIngredientModel(
      name: map['name'] ?? '',
      dcbCode: map['dcbCode'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dcbCode': dcbCode,
    };
  }
}

class PresentationModel {
  final String registration;
  final PackageModel package;
  final double? packageUnitViscosityPerUnit;
  final double packagePriceValue;
  final String? packageUnitActiveIngredientConcentration;
  final String dosageTemplate;

  PresentationModel({
    required this.registration,
    required this.package,
    this.packageUnitViscosityPerUnit,
    required this.packagePriceValue,
    this.packageUnitActiveIngredientConcentration,
    required this.dosageTemplate,
  });

  factory PresentationModel.fromMap(Map<String, dynamic> map) {
    return PresentationModel(
      registration: map['registration'] ?? '',
      package: PackageModel.fromMap(map['package'] ?? {}),
      packageUnitViscosityPerUnit:
          map['packageUnitViscosityPerUnit']?.toDouble(),
      packagePriceValue: (map['packagePriceValue'] as num?)?.toDouble() ?? 0.0,
      packageUnitActiveIngredientConcentration:
          map['packageUnitActiveIngredientConcentration'],
      dosageTemplate: map['dosageTemplate'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'registration': registration,
      'package': package.toMap(),
      if (packageUnitViscosityPerUnit != null)
        'packageUnitViscosityPerUnit': packageUnitViscosityPerUnit,
      'packagePriceValue': packagePriceValue,
      if (packageUnitActiveIngredientConcentration != null)
        'packageUnitActiveIngredientConcentration':
            packageUnitActiveIngredientConcentration,
      'dosageTemplate': dosageTemplate,
    };
  }
}

class PackageModel {
  final PackageUnitModel primary;
  final PackageUnitModel secondary;

  PackageModel({
    required this.primary,
    required this.secondary,
  });

  factory PackageModel.fromMap(Map<String, dynamic> map) {
    return PackageModel(
      primary: PackageUnitModel.fromMap(map['primary'] ?? {}),
      secondary: PackageUnitModel.fromMap(map['secondary'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'primary': primary.toMap(),
      'secondary': secondary.toMap(),
    };
  }
}

class PackageUnitModel {
  final String dispensationUnit;
  final int quantity;
  final ConcentrationModel? concentration;

  PackageUnitModel({
    required this.dispensationUnit,
    required this.quantity,
    this.concentration,
  });

  factory PackageUnitModel.fromMap(Map<String, dynamic> map) {
    return PackageUnitModel(
      dispensationUnit: map['dispensationUnit'] ?? '',
      quantity: map['quantity'] ?? 0,
      concentration: map['concentration'] != null
          ? ConcentrationModel.fromMap(map['concentration'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dispensationUnit': dispensationUnit,
      'quantity': quantity,
      if (concentration != null) 'concentration': concentration!.toMap(),
    };
  }
}

class ConcentrationModel {
  final double value;
  final String unit;

  ConcentrationModel({
    required this.value,
    required this.unit,
  });

  factory ConcentrationModel.fromMap(Map<String, dynamic> map) {
    return ConcentrationModel(
      value: (map['value'] as num?)?.toDouble() ?? 0.0,
      unit: map['unit'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'unit': unit,
    };
  }
}
