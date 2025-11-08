import 'package:medgo/data/models/dynamic_prescription_filter_helper.dart';
import 'package:medgo/data/models/dynamic_prescription_filter_model.dart'
    as filter;
import 'package:medgo/data/models/medical_enums.dart';
import 'package:medgo/data/models/medication_model.dart';
import 'package:medgo/widgets/prescription/prescription_forms/types_prescription_medgo/models/simple_prescription_state.dart';

/// Controlador que gerencia a lógica de negócio da prescrição simples
class SimplePrescriptionController {
  final MedicationModel medication;
  final SimplePrescriptionState state;
  late final DynamicPrescriptionFilterHelper _helper;

  SimplePrescriptionController({
    required this.medication,
    required this.state,
  }) {
    _helper = DynamicPrescriptionFilterHelper(medication);
  }

  // Getters para verificar se helper tem filtros
  bool get hasFilters => _helper.hasFilters;

  // Métodos auxiliares para obter o display name das keys
  String getCategoryDisplay(String code) {
    return MedicalEnums.getAdministrationType(code)?.display ?? code;
  }

  String getRouteDisplay(String code) {
    return MedicalEnums.getDrugAdministrationRoute(code)?.display ?? code;
  }

  String getBaseDisplay(String code) {
    return MedicalEnums.getBase(code)?.display ?? code;
  }

  // Métodos para obter opções disponíveis
  List<String> getCategoryOptions() => _helper.getCategoryOptions();

  List<String> getRouteOptions(String categoryKey) =>
      _helper.getRouteOptions(categoryKey);

  List<String> getBaseOptions(String categoryKey, String routeKey) =>
      _helper.getBaseOptions(categoryKey, routeKey);

  Map<String, List<String>> getStrengthsByActiveIngredient(
    String categoryKey,
    String routeKey,
    String baseKey,
  ) =>
      _helper.getStrengthsByActiveIngredient(categoryKey, routeKey, baseKey);

  // Método para obter os activeIngredients da base selecionada
  List<filter.ActiveIngredientModel> getActiveIngredientsForSelectedBase() {
    if (state.selectedCategory == null ||
        state.selectedRoute == null ||
        state.selectedBase == null) {
      return [];
    }

    final base = medication.filters!
        .getCategory(state.selectedCategory!)
        ?.routes[state.selectedRoute!]
        ?.bases[state.selectedBase!];

    return base?.activeIngredients ?? [];
  }

  // Método para verificar se uma força é permitida baseada nas combinações já selecionadas
  bool isStrengthAllowed(
      filter.ActiveIngredientModel activeIngredient, String strengthKey) {
    // Encontrar o modelo de força específico
    final strengthModel = activeIngredient.strengths.firstWhere(
      (strength) => '${strength.value} ${strength.unit}' == strengthKey,
      orElse: () => filter.StrengthModel(value: 0, unit: ''),
    );

    // Se o modelo de força não foi encontrado, não permite
    if (strengthModel.id == null) {
      return false;
    }

    // Se não há forças selecionadas ainda, permite qualquer uma
    if (state.selectedStrengthsByActiveIngredient.isEmpty) {
      return true;
    }

    // Se o ingrediente ativo não tem combinações definidas, permite todas
    try {
      if (activeIngredient.combinations.isEmpty) {
        return true;
      }
    } catch (e) {
      print('Erro ao acessar combinations para ${activeIngredient.name}: $e');
      return true; // Em caso de erro, permite por segurança
    }

    // Obter a lista de combinações permitidas para esta força específica
    List<String>? allowedCombinations;
    try {
      allowedCombinations = activeIngredient.combinations[strengthModel.id];
    } catch (e) {
      print(
          'Erro ao acessar combinations[${strengthModel.id}] para ${activeIngredient.name}: $e');
      return true; // Em caso de erro, permite por segurança
    }

    // Se não há combinações definidas para esta força específica, permite
    if (allowedCombinations == null || allowedCombinations.isEmpty) {
      return true;
    }

    // Se há apenas uma força selecionada e é do mesmo ingrediente ativo, permite
    if (state.selectedStrengthsByActiveIngredient.length == 1 &&
        state.selectedStrengthsByActiveIngredient
            .containsKey(activeIngredient.dcbCode)) {
      return true;
    }

    // Verifica se alguma das forças já selecionadas está na lista de combinações permitidas
    for (final selectedEntry
        in state.selectedStrengthsByActiveIngredient.entries) {
      final selectedDcb = selectedEntry.key;
      final selectedStrength = selectedEntry.value;

      // Se este é o mesmo ingrediente ativo, pula a verificação
      if (selectedDcb == activeIngredient.dcbCode) {
        continue;
      }

      // Encontra o modelo da força selecionada para obter seu ID
      final selectedActiveIngredient = getActiveIngredientsForSelectedBase()
          .firstWhere((ingredient) => ingredient.dcbCode == selectedDcb,
              orElse: () => filter.ActiveIngredientModel(
                  name: '', dcbCode: '', combinations: {}, strengths: []));

      if (selectedActiveIngredient.dcbCode.isEmpty) {
        continue;
      }

      final selectedStrengthModel =
          selectedActiveIngredient.strengths.firstWhere(
        (strength) => '${strength.value} ${strength.unit}' == selectedStrength,
        orElse: () => filter.StrengthModel(value: 0, unit: ''),
      );

      // Verifica se o ID da força selecionada está nas combinações permitidas
      if (selectedStrengthModel.id != null &&
          !allowedCombinations.contains(selectedStrengthModel.id)) {
        return false; // Combinação não permitida
      }
    }

    return true; // Combinação permitida
  }

  // Método para selecionar uma força e encontrar incompatibilidades
  List<String> getIncompatibleStrengths(
      filter.ActiveIngredientModel targetActiveIngredient,
      String targetStrengthKey) {
    // Encontrar o modelo de força específico do chip clicado
    final targetStrengthModel = targetActiveIngredient.strengths.firstWhere(
      (strength) => '${strength.value} ${strength.unit}' == targetStrengthKey,
      orElse: () => filter.StrengthModel(value: 0, unit: ''),
    );

    // Se o modelo de força não foi encontrado ou não tem ID, retorna vazio
    if (targetStrengthModel.id == null) {
      return [];
    }

    // Se o ingrediente ativo não tem combinações definidas, não há incompatibilidades
    try {
      if (targetActiveIngredient.combinations.isEmpty) {
        return [];
      }
    } catch (e) {
      print(
          'Erro ao acessar combinations para ${targetActiveIngredient.name}: $e');
      return []; // Em caso de erro, não remove nada
    }

    // Obter a lista de combinações permitidas para esta força específica
    List<String>? allowedCombinations;
    try {
      allowedCombinations =
          targetActiveIngredient.combinations[targetStrengthModel.id];
    } catch (e) {
      print(
          'Erro ao acessar combinations[${targetStrengthModel.id}] para ${targetActiveIngredient.name}: $e');
      return []; // Em caso de erro, não remove nada
    }

    // Se não há combinações definidas para esta força específica, não há incompatibilidades
    if (allowedCombinations == null || allowedCombinations.isEmpty) {
      return [];
    }

    final List<String> dcbsToRemove = [];

    // Verifica todas as forças selecionadas atualmente
    for (final selectedEntry
        in state.selectedStrengthsByActiveIngredient.entries) {
      final selectedDcb = selectedEntry.key;
      final selectedStrength = selectedEntry.value;

      // Se este é o mesmo ingrediente ativo, pula a verificação
      if (selectedDcb == targetActiveIngredient.dcbCode) {
        continue;
      }

      // Encontra o modelo da força selecionada para obter seu ID
      final selectedActiveIngredient = getActiveIngredientsForSelectedBase()
          .firstWhere((ingredient) => ingredient.dcbCode == selectedDcb,
              orElse: () => filter.ActiveIngredientModel(
                  name: '', dcbCode: '', combinations: {}, strengths: []));

      if (selectedActiveIngredient.dcbCode.isEmpty) {
        continue;
      }

      final selectedStrengthModel =
          selectedActiveIngredient.strengths.firstWhere(
        (strength) => '${strength.value} ${strength.unit}' == selectedStrength,
        orElse: () => filter.StrengthModel(value: 0, unit: ''),
      );

      // Se o ID da força selecionada não está nas combinações permitidas, marca para remoção
      if (selectedStrengthModel.id != null &&
          !allowedCombinations.contains(selectedStrengthModel.id)) {
        dcbsToRemove.add(selectedDcb);
      }
    }

    return dcbsToRemove;
  }

  // Getters para validações de estado
  bool get shouldShowRoutes {
    return hasFilters &&
        state.selectedCategory != null &&
        getRouteOptions(state.selectedCategory!).isNotEmpty;
  }

  bool get shouldShowBases {
    return shouldShowRoutes &&
        state.selectedRoute != null &&
        getBaseOptions(state.selectedCategory!, state.selectedRoute!)
            .isNotEmpty;
  }

  bool get canShowStrengths {
    return state.selectedCategory != null &&
        state.selectedRoute != null &&
        state.selectedBase != null &&
        shouldShowBases;
  }

  bool get canShowQuantityAdm {
    if (!canShowStrengths) return false;

    // Verifica se todos os ingredientes ativos disponíveis têm uma força selecionada
    final strengthsByActiveIngredient = getStrengthsByActiveIngredient(
      state.selectedCategory!,
      state.selectedRoute!,
      state.selectedBase!,
    );

    for (final activeIngredient in getActiveIngredientsForSelectedBase()) {
      if (strengthsByActiveIngredient.containsKey(activeIngredient.dcbCode)) {
        // Se este ingrediente tem forças disponíveis mas nenhuma selecionada, não pode mostrar
        if (!state.selectedStrengthsByActiveIngredient
            .containsKey(activeIngredient.dcbCode)) {
          return false;
        }
      }
    }

    // Se chegou aqui, todos os ingredientes disponíveis têm forças selecionadas
    return state.selectedStrengthsByActiveIngredient.isNotEmpty;
  }

  // Métodos para atualizar estado com validações
  void selectCategory(String? categoryKey) {
    state.updateCategory(categoryKey);
  }

  void selectRoute(String? routeKey) {
    state.updateRoute(routeKey);
  }

  void selectBase(String? baseKey) {
    state.updateBase(baseKey);
  }

  void selectStrength(String dcbCode, String? strengthKey) {
    state.updateStrength(dcbCode, strengthKey);
  }

  void selectStrengthAndClearIncompatible(
      filter.ActiveIngredientModel targetActiveIngredient,
      String targetStrengthKey) {
    // Primeiro, seleciona a força
    state.updateStrength(targetActiveIngredient.dcbCode, targetStrengthKey);

    // Em seguida, encontra e remove as incompatíveis
    final incompatibleDcbs =
        getIncompatibleStrengths(targetActiveIngredient, targetStrengthKey);
    if (incompatibleDcbs.isNotEmpty) {
      state.clearIncompatibleStrengths(incompatibleDcbs);
    }
  }

  void selectPleasureForm(String pleasureForm) {
    state.updatePleasureForm(pleasureForm);
  }

  void selectIntervalForm(String intervalForm) {
    state.updateIntervalForm(intervalForm);
  }

  void selectTurnForm(List<String> turnForm) {
    state.updateTurnForm(turnForm);
  }

  void selectMealsForm(List<String> mealsForm) {
    state.updateMealsForm(mealsForm);
  }

  void selectTimeForm(List<String> timeForm) {
    state.updateTimeForm(timeForm);
  }

  void selectReferenceForm(String referenceForm) {
    state.updateReferenceForm(referenceForm);
  }

  void selectDurationForm(String durationForm) {
    state.updateDurationForm(durationForm);
  }

  void selectUnidadeForm(String unidadeForm) {
    state.updateUnidadeForm(unidadeForm);
  }

  // Método para resetar tudo
  void reset() {
    state.reset();
  }
}
