class DynamicPrescriptionFilterModel {
  final Map<String, CategoryModel> categories;

  DynamicPrescriptionFilterModel({
    required this.categories,
  });

  factory DynamicPrescriptionFilterModel.fromMap(Map<String, dynamic> map) {
    final Map<String, CategoryModel> categories = {};

    if (map['categories'] != null) {
      final categoriesMap = map['categories'] as Map<String, dynamic>;
      for (final entry in categoriesMap.entries) {
        categories[entry.key] = CategoryModel.fromMap(entry.value);
      }
    }

    return DynamicPrescriptionFilterModel(
      categories: categories,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categories':
          categories.map((key, value) => MapEntry(key, value.toMap())),
    };
  }

  // Helper methods para acessar dados dinamicamente
  List<String> getCategoryKeys() => categories.keys.toList();

  CategoryModel? getCategory(String categoryKey) => categories[categoryKey];

  List<String> getRouteKeysForCategory(String categoryKey) {
    return categories[categoryKey]?.routes.keys.toList() ?? [];
  }

  List<String> getBaseKeysForRoute(String categoryKey, String routeKey) {
    return categories[categoryKey]?.routes[routeKey]?.bases.keys.toList() ?? [];
  }

  List<String> getActiveIngredientIdsForBase(
      String categoryKey, String routeKey, String baseKey) {
    return categories[categoryKey]
            ?.routes[routeKey]
            ?.bases[baseKey]
            ?.activeIngredients
            .map((ingredient) => ingredient.dcbCode)
            .toList() ??
        [];
  }
}

class CategoryModel {
  final Map<String, RouteModel> routes;

  CategoryModel({
    required this.routes,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    final Map<String, RouteModel> routes = {};

    if (map['routes'] != null) {
      final routesMap = map['routes'] as Map<String, dynamic>;
      for (final entry in routesMap.entries) {
        routes[entry.key] = RouteModel.fromMap(entry.value);
      }
    }

    return CategoryModel(routes: routes);
  }

  Map<String, dynamic> toMap() {
    return {
      'routes': routes.map((key, value) => MapEntry(key, value.toMap())),
    };
  }
}

class RouteModel {
  final Map<String, BaseModel> bases;

  RouteModel({
    required this.bases,
  });

  factory RouteModel.fromMap(Map<String, dynamic> map) {
    final Map<String, BaseModel> bases = {};

    if (map['bases'] != null) {
      final basesMap = map['bases'] as Map<String, dynamic>;
      for (final entry in basesMap.entries) {
        bases[entry.key] = BaseModel.fromMap(entry.value);
      }
    }

    return RouteModel(bases: bases);
  }

  Map<String, dynamic> toMap() {
    return {
      'bases': bases.map((key, value) => MapEntry(key, value.toMap())),
    };
  }
}

class BaseModel {
  final List<ActiveIngredientModel> activeIngredients;
  final Map<String, List<String>> presentationsByCombination;

  BaseModel({
    required this.activeIngredients,
    required this.presentationsByCombination,
  });

  factory BaseModel.fromMap(Map<String, dynamic> map) {
    final Map<String, List<String>> presentations = {};

    if (map['presentationsByCombination'] != null) {
      final presentationsMap =
          map['presentationsByCombination'] as Map<String, dynamic>;
      for (final entry in presentationsMap.entries) {
        presentations[entry.key] = (entry.value as List<dynamic>?)
                ?.map((item) => item.toString())
                .toList() ??
            [];
      }
    }

    return BaseModel(
      activeIngredients: (map['activeIngredients'] as List<dynamic>?)
              ?.map((item) => ActiveIngredientModel.fromMap(item))
              .toList() ??
          [],
      presentationsByCombination: presentations,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'activeIngredients':
          activeIngredients.map((item) => item.toMap()).toList(),
      'presentationsByCombination': presentationsByCombination,
    };
  }
}

class ActiveIngredientModel {
  final String name;
  final String dcbCode;
  final Map<String, List<String>> combinations;
  final List<StrengthModel> strengths;

  ActiveIngredientModel({
    required this.name,
    required this.dcbCode,
    required this.combinations,
    required this.strengths,
  });

  factory ActiveIngredientModel.fromMap(Map<String, dynamic> map) {
    final Map<String, List<String>> combinations = {};

    // Garantir que combinations nunca seja null
    try {
      if (map['combinations'] != null) {
        final combinationsMap = map['combinations'] as Map<String, dynamic>?;
        if (combinationsMap != null) {
          for (final entry in combinationsMap.entries) {
            if (entry.value != null) {
              combinations[entry.key] = (entry.value as List<dynamic>?)
                      ?.map((item) => item?.toString() ?? '')
                      .where((item) => item.isNotEmpty)
                      .toList() ??
                  [];
            }
          }
        }
      }
    } catch (e) {
      // Se houver erro ao processar combinações, usa mapa vazio
      print('Erro ao processar combinations: $e');
    }

    return ActiveIngredientModel(
      name: map['name'] ?? '',
      dcbCode: map['dcbCode'] ?? '',
      combinations: combinations,
      strengths: (map['strengths'] as List<dynamic>?)
              ?.map((item) => StrengthModel.fromMap(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dcbCode': dcbCode,
      'combinations': combinations,
      'strengths': strengths.map((item) => item.toMap()).toList(),
    };
  }
}

class ActiveIngredientStrengthModel {
  final List<StrengthModel> strengths;

  ActiveIngredientStrengthModel({
    required this.strengths,
  });

  factory ActiveIngredientStrengthModel.fromMap(Map<String, dynamic> map) {
    return ActiveIngredientStrengthModel(
      strengths: (map['strengths'] as List<dynamic>?)
              ?.map((item) => StrengthModel.fromMap(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'strengths': strengths.map((item) => item.toMap()).toList(),
    };
  }
}

class StrengthModel {
  final String? id;
  final double value;
  final String unit;
  final bool? marked;
  final List<String> presentations;
  final Map<String, List<PreviousStrengthModel>>? allowedPreviousStrengths;

  StrengthModel({
    this.id,
    required this.value,
    required this.unit,
    this.marked,
    this.presentations = const [],
    this.allowedPreviousStrengths,
  });

  factory StrengthModel.fromMap(Map<String, dynamic> map) {
    Map<String, List<PreviousStrengthModel>>? allowedPreviousStrengths;

    if (map['allowedPreviousStrengths'] != null) {
      allowedPreviousStrengths = {};
      final previousStrengthsMap =
          map['allowedPreviousStrengths'] as Map<String, dynamic>;
      for (final entry in previousStrengthsMap.entries) {
        allowedPreviousStrengths[entry.key] = (entry.value as List<dynamic>)
            .map((item) => PreviousStrengthModel.fromMap(item))
            .toList();
      }
    }

    return StrengthModel(
      id: map['id'],
      value: map['value'] != null ? (map['value'] as num).toDouble() : 0.0,
      unit: map['unit'] ?? '',
      marked: map['marked'],
      presentations: (map['presentations'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      allowedPreviousStrengths: allowedPreviousStrengths,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'value': value,
      'unit': unit,
      if (marked != null) 'marked': marked,
      'presentations': presentations,
      if (allowedPreviousStrengths != null)
        'allowedPreviousStrengths': allowedPreviousStrengths!.map(
          (key, value) =>
              MapEntry(key, value.map((item) => item.toMap()).toList()),
        ),
    };
  }
}

class PreviousStrengthModel {
  final double value;
  final String unit;

  PreviousStrengthModel({
    required this.value,
    required this.unit,
  });

  factory PreviousStrengthModel.fromMap(Map<String, dynamic> map) {
    return PreviousStrengthModel(
      value: (map['value'] as num).toDouble(),
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
