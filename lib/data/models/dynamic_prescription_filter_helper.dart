import 'package:medgo/data/models/medication_model.dart';
import 'package:medgo/data/models/dynamic_prescription_filter_model.dart'
    as filter;

/// Helper class para trabalhar com filtros dinâmicos de medicações
/// Facilita a navegação e extração de dados dos filtros hierárquicos
class DynamicPrescriptionFilterHelper {
  final MedicationModel medication;

  DynamicPrescriptionFilterHelper(this.medication);

  /// Retorna true se o medicamento tem filtros dinâmicos configurados
  bool get hasFilters => medication.filters != null;

  /// Retorna todas as categorias disponíveis (ex: "oral", "intravenosa", etc.)
  List<String> getCategoryOptions() {
    if (!hasFilters) return [];
    return medication.filters!.getCategoryKeys();
  }

  /// Retorna as vias de administração para uma categoria específica
  List<String> getRouteOptions(String categoryKey) {
    if (!hasFilters) return [];
    return medication.filters!.getRouteKeysForCategory(categoryKey);
  }

  /// Retorna as bases disponíveis para uma categoria e via específicas
  List<String> getBaseOptions(String categoryKey, String routeKey) {
    if (!hasFilters) return [];
    return medication.filters!.getBaseKeysForRoute(categoryKey, routeKey);
  }

  /// Retorna os princípios ativos disponíveis para uma combinação específica
  List<String> getActiveIngredientIds(
      String categoryKey, String routeKey, String baseKey) {
    if (!hasFilters) return [];
    return medication.filters!
        .getActiveIngredientIdsForBase(categoryKey, routeKey, baseKey);
  }

  /// Retorna as forças organizadas por princípio ativo para uma combinação específica
  Map<String, List<String>> getStrengthsByActiveIngredient(
      String categoryKey, String routeKey, String baseKey) {
    if (!hasFilters) return {};

    final base = medication.filters!
        .getCategory(categoryKey)
        ?.routes[routeKey]
        ?.bases[baseKey];

    if (base == null) return {};

    final Map<String, List<String>> result = {};

    for (final activeIngredient in base.activeIngredients) {
      // Extrair as keys das forças (valor + unidade)
      final strengthKeys = activeIngredient.strengths.map((strength) {
        return '${strength.value} ${strength.unit}';
      }).toList();

      result[activeIngredient.dcbCode] = strengthKeys;
    }

    return result;
  }

  /// Retorna as dosagens disponíveis para um princípio ativo específico
  List<filter.StrengthModel> getStrengthsForActiveIngredient(String categoryKey,
      String routeKey, String baseKey, String activeIngredientId) {
    if (!hasFilters) return [];

    final base = medication.filters!
        .getCategory(categoryKey)
        ?.routes[routeKey]
        ?.bases[baseKey];

    if (base == null) return [];

    final activeIngredient = base.activeIngredients.firstWhere(
        (ingredient) => ingredient.dcbCode == activeIngredientId,
        orElse: () => filter.ActiveIngredientModel(
            name: '', dcbCode: '', combinations: {}, strengths: []));

    return activeIngredient.strengths;
  }

  /// Retorna o nome de um princípio ativo pelo ID
  String? getActiveIngredientNameById(String activeIngredientDcb) {
    try {
      return '';
    } catch (e) {
      return 'Desconhecido';
    }
  }

  /// Retorna as apresentações disponíveis para uma dosagem específica
  List<String> getPresentationsForStrength(filter.StrengthModel strength) {
    return strength.presentations;
  }

  /// Verifica se uma combinação específica é válida
  bool isValidCombination(String categoryKey, String routeKey, String baseKey) {
    if (!hasFilters) return false;

    final category = medication.filters!.getCategory(categoryKey);
    if (category == null) return false;

    final route = category.routes[routeKey];
    if (route == null) return false;

    final base = route.bases[baseKey];
    return base != null;
  }

  /// Retorna todas as combinações válidas disponíveis
  List<PrescriptionCombination> getAllValidCombinations() {
    if (!hasFilters) return [];

    List<PrescriptionCombination> combinations = [];

    for (final categoryKey in getCategoryOptions()) {
      for (final routeKey in getRouteOptions(categoryKey)) {
        for (final baseKey in getBaseOptions(categoryKey, routeKey)) {
          combinations.add(PrescriptionCombination(
            categoryKey: categoryKey,
            routeKey: routeKey,
            baseKey: baseKey,
            activeIngredientIds:
                getActiveIngredientIds(categoryKey, routeKey, baseKey),
          ));
        }
      }
    }

    return combinations;
  }

  /// Método para construir uma prescrição com dosagens específicas
  Map<String, dynamic> buildPrescriptionData({
    required String categoryKey,
    required String routeKey,
    required String baseKey,
    required Map<String, filter.StrengthModel>
        selectedStrengths, // activeIngredientId -> StrengthModel
    required int quantity,
  }) {
    final Map<String, Map<String, dynamic>> strengthsData = {};

    for (final entry in selectedStrengths.entries) {
      final activeIngredientId = entry.key;
      final strength = entry.value;

      strengthsData[activeIngredientId] = {
        'value': strength.value,
        'unit': strength.unit,
        'presentations': strength.presentations,
        'activeIngredientName': getActiveIngredientNameById(activeIngredientId),
      };
    }

    return {
      'category': categoryKey,
      'route': routeKey,
      'base': baseKey,
      'quantity': quantity,
      'strengths': strengthsData,
      'medicationName': medication.displayName,
      'medicationId': medication.medications.isNotEmpty
          ? medication.medications.first.id
          : '',
    };
  }

  /// Retorna as apresentações disponíveis para uma combinação específica de forças
  List<String> getPresentationsForCombination(String categoryKey,
      String routeKey, String baseKey, List<String> selectedStrengthIds) {
    if (!hasFilters || selectedStrengthIds.isEmpty) return [];

    final base = medication.filters!
        .getCategory(categoryKey)
        ?.routes[routeKey]
        ?.bases[baseKey];

    if (base == null) return [];

    // Criar chave da combinação ordenando os IDs das forças
    final sortedStrengthIds = List<String>.from(selectedStrengthIds)..sort();
    final combinationKey = sortedStrengthIds.join('_');

    // Buscar apresentações para esta combinação
    final presentations = base.presentationsByCombination[combinationKey] ?? [];

    return presentations;
  }

  /// Retorna os detalhes de uma apresentação específica
  PresentationModel? getPresentationDetails(String registrationId) {
    return medication.presentationsByRegistration[registrationId];
  }

  /// Retorna todas as apresentações disponíveis como uma lista de modelos
  List<PresentationModel> getAllPresentations() {
    return medication.presentationsByRegistration.values.toList();
  }

  /// Retorna as apresentações filtradas por uma lista de registration IDs
  List<PresentationModel> getPresentationsByIds(List<String> registrationIds) {
    return registrationIds
        .map((id) => medication.presentationsByRegistration[id])
        .whereType<PresentationModel>()
        .toList();
  }
}

/// Classe para representar uma combinação válida de prescrição
class PrescriptionCombination {
  final String categoryKey;
  final String routeKey;
  final String baseKey;
  final List<String> activeIngredientIds;

  PrescriptionCombination({
    required this.categoryKey,
    required this.routeKey,
    required this.baseKey,
    required this.activeIngredientIds,
  });

  @override
  String toString() {
    return 'PrescriptionCombination(category: $categoryKey, route: $routeKey, base: $baseKey, activeIngredients: ${activeIngredientIds.length})';
  }
}
