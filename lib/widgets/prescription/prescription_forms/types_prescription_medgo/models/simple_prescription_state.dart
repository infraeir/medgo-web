import 'package:flutter/material.dart';
import 'package:medgo/widgets/news_widgets/count_input/count_input_controller.dart';

/// Classe que gerencia todo o estado da prescrição simples
class SimplePrescriptionState extends ChangeNotifier {
  // Estado da seleção dinâmica
  String? selectedCategory;
  String? selectedRoute;
  String? selectedBase;

  // Estado das forças selecionadas por ingrediente ativo (dcbCode -> strengthKey)
  Map<String, String> selectedStrengthsByActiveIngredient = {};

  // Controller para quantidade por administração
  late final CountInputController quantityController;

  // Controladores para forma de aprazamento
  String selectedPleasureForm = 'interval';
  String selectedIntervalForm = '';
  List<String> selectedTurnForm = [];
  List<String> selectedMealsForm = [];
  List<String> selectedTimeForm = [];
  String selectedReferenceForm = '';
  String selectedDurationForm = 'continuous_use';
  String selectedUnidadeForm = 'days';
  late final CountInputController numVezesController;
  late final CountInputController duracaoController;
  late final TextEditingController otherIntervalController;
  bool showOtherIntervalField = false;

  SimplePrescriptionState() {
    _initializeControllers();
  }

  void _initializeControllers() {
    quantityController = CountInputController(1);
    numVezesController = CountInputController(1);
    duracaoController = CountInputController(1);
    otherIntervalController = TextEditingController();
  }

  @override
  void dispose() {
    quantityController.dispose();
    numVezesController.dispose();
    duracaoController.dispose();
    otherIntervalController.dispose();
    super.dispose();
  }

  // Métodos para atualizar o estado

  void updateCategory(String? category) {
    selectedCategory = category;
    selectedRoute = null;
    selectedBase = null;
    selectedStrengthsByActiveIngredient.clear();
    notifyListeners();
  }

  void updateRoute(String? route) {
    selectedRoute = route;
    selectedBase = null;
    selectedStrengthsByActiveIngredient.clear();
    notifyListeners();
  }

  void updateBase(String? base) {
    selectedBase = base;
    selectedStrengthsByActiveIngredient.clear();
    notifyListeners();
  }

  void updateStrength(String dcbCode, String? strengthKey) {
    if (strengthKey != null) {
      selectedStrengthsByActiveIngredient[dcbCode] = strengthKey;
    } else {
      selectedStrengthsByActiveIngredient.remove(dcbCode);
    }
    notifyListeners();
  }

  void clearIncompatibleStrengths(List<String> dcbCodesToRemove) {
    for (final dcbCode in dcbCodesToRemove) {
      selectedStrengthsByActiveIngredient.remove(dcbCode);
    }
    notifyListeners();
  }

  void updatePleasureForm(String pleasureForm) {
    selectedPleasureForm = pleasureForm;
    // Reset campos quando muda o tipo
    selectedIntervalForm = '';
    showOtherIntervalField = false;
    notifyListeners();
  }

  void updateIntervalForm(String intervalForm) {
    selectedIntervalForm = intervalForm;
    showOtherIntervalField = intervalForm == 'other';
    notifyListeners();
  }

  void updateTurnForm(List<String> turnForm) {
    selectedTurnForm = turnForm;
    notifyListeners();
  }

  void updateMealsForm(List<String> mealsForm) {
    selectedMealsForm = mealsForm;
    notifyListeners();
  }

  void updateTimeForm(List<String> timeForm) {
    selectedTimeForm = timeForm;
    notifyListeners();
  }

  void updateReferenceForm(String referenceForm) {
    selectedReferenceForm = referenceForm;
    notifyListeners();
  }

  void updateDurationForm(String durationForm) {
    selectedDurationForm = durationForm;
    notifyListeners();
  }

  void updateUnidadeForm(String unidadeForm) {
    selectedUnidadeForm = unidadeForm;
    notifyListeners();
  }

  // Getters para facilitar o acesso

  bool get hasSelectedCategory => selectedCategory != null;
  bool get hasSelectedRoute => selectedRoute != null;
  bool get hasSelectedBase => selectedBase != null;
  bool get hasSelectedStrengths =>
      selectedStrengthsByActiveIngredient.isNotEmpty;

  int get quantity => quantityController.value;
  int get numVezes => numVezesController.value;
  int get duracao => duracaoController.value;
  String get otherInterval => otherIntervalController.text;

  // Método para resetar todo o estado
  void reset() {
    selectedCategory = null;
    selectedRoute = null;
    selectedBase = null;
    selectedStrengthsByActiveIngredient.clear();
    selectedPleasureForm = 'interval';
    selectedIntervalForm = '';
    selectedTurnForm.clear();
    selectedMealsForm.clear();
    selectedTimeForm.clear();
    selectedReferenceForm = '';
    selectedDurationForm = 'continuous_use';
    selectedUnidadeForm = 'days';
    showOtherIntervalField = false;

    quantityController.value = 1;
    numVezesController.value = 1;
    duracaoController.value = 1;
    otherIntervalController.clear();

    notifyListeners();
  }
}
