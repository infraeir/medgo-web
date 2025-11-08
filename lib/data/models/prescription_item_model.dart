import 'package:medgo/data/models/prescription_instructions_model.dart';

class PrescriptionItemModel {
  final String id;
  final String type;
  final List<PrescriptionEntityModel> entities;
  final PrescriptionInstructionsModel instructions;
  final bool isChosen;
  final bool isFavorite;

  PrescriptionItemModel({
    required this.id,
    required this.type,
    required this.entities,
    required this.instructions,
    required this.isChosen,
    required this.isFavorite,
  });

  factory PrescriptionItemModel.fromMap(Map<String, dynamic> map) {
    return PrescriptionItemModel(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      entities: (map['entities'] as List<dynamic>?)
              ?.map((entity) => PrescriptionEntityModel.fromMap(entity))
              .toList() ??
          [],
      instructions:
          PrescriptionInstructionsModel.fromMap(map['instructions'] ?? {}),
      isChosen: map['isChosen'] ?? false,
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'entities': entities.map((entity) => entity.toMap()).toList(),
      'instructions': instructions.toMap(),
      'isChosen': isChosen,
      'isFavorite': isFavorite,
    };
  }

  PrescriptionItemModel copyWith({
    String? id,
    String? type,
    List<PrescriptionEntityModel>? entities,
    PrescriptionInstructionsModel? instructions,
    bool? isChosen,
    bool? isFavorite,
  }) {
    return PrescriptionItemModel(
      id: id ?? this.id,
      type: type ?? this.type,
      entities: entities ?? this.entities,
      instructions: instructions ?? this.instructions,
      isChosen: isChosen ?? this.isChosen,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  // Método helper para compatibilidade com código existente
  // Retorna a primeira entidade do array (se existir)
  PrescriptionEntityModel? get entity {
    return entities.isNotEmpty ? entities.first : null;
  }

  // Método helper para obter displayName da primeira entidade
  String get displayName {
    return entity?.name ?? '';
  }

  // Método helper para obter type da primeira entidade
  String get entityType {
    return entity?.type ?? '';
  }

  // Método helper para obter tradeName da primeira entidade
  String get tradeName {
    return entity?.tradeName ?? '';
  }

  // Método helper para obter presentation da primeira entidade
  String get presentation {
    return entity?.presentations.isNotEmpty == true
        ? entity!.presentations.first.registration
        : '';
  }

  // Método helper para obter form da primeira entidade
  String get form {
    return entity?.bases.isNotEmpty == true ? entity!.bases.first : '';
  }

  // Método helper para obter activeIngredient da primeira entidade
  String get activeIngredient {
    return entity?.activeIngredients.isNotEmpty == true
        ? entity!.activeIngredients.first.name
        : '';
  }

  // Método helper para obter activeIngredientConcentration da primeira entidade
  double get activeIngredientConcentration {
    return entity?.presentations.isNotEmpty == true
        ? entity!.presentations.first.packageUnitActiveIngredientConcentration
        : 0.0;
  }

  // Método helper para obter viscosityDropsPerML da primeira entidade
  int get viscosityDropsPerML {
    return entity?.presentations.isNotEmpty == true
        ? entity!.presentations.first.packageUnitViscosityPerUnit
        : 0;
  }

  // Método helper para obter bottleVolumeML da primeira entidade
  int get bottleVolumeML {
    return entity?.presentations.isNotEmpty == true
        ? entity!.presentations.first.package.primary.quantity
        : 0;
  }

  // Método helper para obter susAvailability da primeira entidade
  bool get susAvailability {
    return entity?.availableInSUS ?? false;
  }

  // Método helper para obter commercialAvailability da primeira entidade
  bool get commercialAvailability {
    return entity?.availableInPopularPharmacy ?? false;
  }

  // Método helper para obter bottlePrice da primeira entidade
  double get bottlePrice {
    return entity?.presentations.isNotEmpty == true
        ? entity!.presentations.first.packagePriceValue
        : 0.0;
  }

  // Método helper para obter vaccineName da primeira entidade
  String get vaccineName {
    return entity?.name ?? '';
  }

  // Método helper para obter doseNumber da primeira entidade
  int get doseNumber {
    return 1; // Default value, pode ser ajustado conforme necessário
  }
}

// Modelo para cada entidade individual dentro do array entities
class PrescriptionEntityModel {
  final String id;
  final String name;
  final String anvisaRegistrationCode;
  final String tradeName;
  final String type;
  final List<String> bases;
  final List<String> administrationCategories;
  final List<String> administrationRoutes;
  final List<PrescriptionActiveIngredientModel> activeIngredients;
  final List<PrescriptionPresentationModel> presentations;
  final bool isControlledSubstance;
  final String origin;
  final String version;
  final bool isActive;
  final bool availableInPopularPharmacy;
  final bool availableInSUS;
  final String? leafletUrl;
  final String? doctorId;

  PrescriptionEntityModel({
    required this.id,
    required this.name,
    required this.anvisaRegistrationCode,
    required this.tradeName,
    required this.type,
    required this.bases,
    required this.administrationCategories,
    required this.administrationRoutes,
    required this.activeIngredients,
    required this.presentations,
    required this.isControlledSubstance,
    required this.origin,
    required this.version,
    required this.isActive,
    required this.availableInPopularPharmacy,
    required this.availableInSUS,
    this.leafletUrl,
    this.doctorId,
  });

  factory PrescriptionEntityModel.fromMap(Map<String, dynamic> map) {
    return PrescriptionEntityModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      anvisaRegistrationCode: map['anvisaRegistrationCode'] ?? '',
      tradeName: map['tradeName'] ?? '',
      type: map['type'] ?? '',
      bases: (map['bases'] as List<dynamic>?)?.cast<String>() ?? [],
      administrationCategories:
          (map['administrationCategories'] as List<dynamic>?)?.cast<String>() ??
              [],
      administrationRoutes:
          (map['administrationRoutes'] as List<dynamic>?)?.cast<String>() ?? [],
      activeIngredients: (map['activeIngredients'] as List<dynamic>?)
              ?.map((ingredient) =>
                  PrescriptionActiveIngredientModel.fromMap(ingredient))
              .toList() ??
          [],
      presentations: (map['presentations'] as List<dynamic>?)
              ?.map((presentation) =>
                  PrescriptionPresentationModel.fromMap(presentation))
              .toList() ??
          [],
      isControlledSubstance: map['isControlledSubstance'] ?? false,
      origin: map['origin'] ?? '',
      version: map['version'] ?? '',
      isActive: map['isActive'] ?? false,
      availableInPopularPharmacy: map['availableInPopularPharmacy'] ?? false,
      availableInSUS: map['availableInSUS'] ?? false,
      leafletUrl: map['leafletUrl'],
      doctorId: map['doctorId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'anvisaRegistrationCode': anvisaRegistrationCode,
      'tradeName': tradeName,
      'type': type,
      'bases': bases,
      'administrationCategories': administrationCategories,
      'administrationRoutes': administrationRoutes,
      'activeIngredients':
          activeIngredients.map((ingredient) => ingredient.toMap()).toList(),
      'presentations':
          presentations.map((presentation) => presentation.toMap()).toList(),
      'isControlledSubstance': isControlledSubstance,
      'origin': origin,
      'version': version,
      'isActive': isActive,
      'availableInPopularPharmacy': availableInPopularPharmacy,
      'availableInSUS': availableInSUS,
      'leafletUrl': leafletUrl,
      'doctorId': doctorId,
    };
  }
}

// Modelo para princípio ativo dentro de cada entidade

class PrescriptionActiveIngredientModel {
  final String name;
  final String dcbCode;

  PrescriptionActiveIngredientModel({
    required this.name,
    required this.dcbCode,
  });

  factory PrescriptionActiveIngredientModel.fromMap(Map<String, dynamic> map) {
    return PrescriptionActiveIngredientModel(
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

// Modelo para apresentações dentro de cada entidade
class PrescriptionPresentationModel {
  final String registration;
  final PrescriptionPackageModel package;
  final int packageUnitViscosityPerUnit;
  final double packagePriceValue;
  final double packageUnitActiveIngredientConcentration;
  final String dosageTemplate;

  PrescriptionPresentationModel({
    required this.registration,
    required this.package,
    required this.packageUnitViscosityPerUnit,
    required this.packagePriceValue,
    required this.packageUnitActiveIngredientConcentration,
    required this.dosageTemplate,
  });

  factory PrescriptionPresentationModel.fromMap(Map<String, dynamic> map) {
    return PrescriptionPresentationModel(
      registration: map['registration'] ?? '',
      package: PrescriptionPackageModel.fromMap(map['package'] ?? {}),
      packageUnitViscosityPerUnit: map['packageUnitViscosityPerUnit'] ?? 0,
      packagePriceValue: (map['packagePriceValue'] as num?)?.toDouble() ?? 0.0,
      packageUnitActiveIngredientConcentration:
          (map['packageUnitActiveIngredientConcentration'] as num?)
                  ?.toDouble() ??
              0.0,
      dosageTemplate: map['dosageTemplate'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'registration': registration,
      'package': package.toMap(),
      'packageUnitViscosityPerUnit': packageUnitViscosityPerUnit,
      'packagePriceValue': packagePriceValue,
      'packageUnitActiveIngredientConcentration':
          packageUnitActiveIngredientConcentration,
      'dosageTemplate': dosageTemplate,
    };
  }
}

// Modelo para package dentro de cada apresentação
class PrescriptionPackageModel {
  final PrescriptionPackageUnitModel primary;
  final PrescriptionPackageUnitModel secondary;

  PrescriptionPackageModel({
    required this.primary,
    required this.secondary,
  });

  factory PrescriptionPackageModel.fromMap(Map<String, dynamic> map) {
    return PrescriptionPackageModel(
      primary: PrescriptionPackageUnitModel.fromMap(map['primary'] ?? {}),
      secondary: PrescriptionPackageUnitModel.fromMap(map['secondary'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'primary': primary.toMap(),
      'secondary': secondary.toMap(),
    };
  }
}

// Modelo para package unit (primary/secondary)
class PrescriptionPackageUnitModel {
  final String dispensationUnit;
  final int quantity;
  final PrescriptionConcentrationModel concentration;

  PrescriptionPackageUnitModel({
    required this.dispensationUnit,
    required this.quantity,
    required this.concentration,
  });

  factory PrescriptionPackageUnitModel.fromMap(Map<String, dynamic> map) {
    return PrescriptionPackageUnitModel(
      dispensationUnit: map['dispensationUnit'] ?? '',
      quantity: map['quantity'] ?? 0,
      concentration:
          PrescriptionConcentrationModel.fromMap(map['concentration'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dispensationUnit': dispensationUnit,
      'quantity': quantity,
      'concentration': concentration.toMap(),
    };
  }
}

class PrescriptionConcentrationModel {
  final double value;
  final String unit;

  PrescriptionConcentrationModel({
    required this.value,
    required this.unit,
  });

  factory PrescriptionConcentrationModel.fromMap(Map<String, dynamic> map) {
    return PrescriptionConcentrationModel(
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
