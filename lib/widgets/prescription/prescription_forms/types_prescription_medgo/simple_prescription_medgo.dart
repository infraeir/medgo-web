// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medgo/data/models/dynamic_prescription_filter_helper.dart';
import 'package:medgo/data/models/dynamic_prescription_filter_model.dart'
    as filter;
import 'package:medgo/data/models/medical_enums.dart';
import 'package:medgo/data/models/medication_model.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/input_chip.dart';
import 'package:medgo/widgets/news_widgets/count_input/count_input.dart';
import 'package:medgo/widgets/news_widgets/count_input/count_input_controller.dart';
import 'package:medgo/widgets/news_widgets/short_text_input.dart';
import 'package:medgo/widgets/prescription/widget/custom_chip_multiple_wrap.dart';
import 'package:medgo/widgets/prescription/widget/custom_chip_wrap.dart';
import 'package:medgo/widgets/prescription/prescription_forms/simple_form_variables.dart';
import 'package:medgo/widgets/scrollbar/custom_scroll_bar.dart';

class SimplePrescriptionMedgo extends StatefulWidget {
  final MedicationModel medication;

  const SimplePrescriptionMedgo({
    super.key,
    required this.medication,
  });

  @override
  State<SimplePrescriptionMedgo> createState() =>
      _SimplePrescriptionMedgoState();
}

class _SimplePrescriptionMedgoState extends State<SimplePrescriptionMedgo> {
  late final DynamicPrescriptionFilterHelper _helper;
  late final ScrollController _scrollController;

  // Estado da seleção dinâmica
  String? selectedCategory;
  String? selectedRoute;
  String? selectedBase;

  // Estado das forças selecionadas por ingrediente ativo (dcbCode -> strengthKey)
  Map<String, String> selectedStrengthsByActiveIngredient = {};

  // Controller para quantidade por administração
  late CountInputController _quantityController;

  // Controller para quantidade a ser dispensada
  late CountInputController _quantityToDispenseController;

  // Controller para instruções adicionais
  late TextEditingController _additionalInstructionsController;

  // Apresentação selecionada
  String? selectedPresentationId;

  // Controladores para forma de aprazamento
  String selectedPleasureForm = 'interval';
  String selectedIntervalForm = '';
  List<String> selectedTurnForm = [];
  List<String> selectedMealsForm = [];
  List<String> selectedTimeForm = [];
  String selectedReferenceForm = '';
  String selectedDurationForm = 'continuous_use';
  String selectedUnidadeForm = 'days';
  late CountInputController _numVezesController;
  late CountInputController _duracaoController;
  late TextEditingController _otherIntervalController;
  bool showOtherIntervalField = false;

  @override
  void initState() {
    super.initState();
    _helper = DynamicPrescriptionFilterHelper(widget.medication);
    _scrollController = ScrollController();
    _quantityController = CountInputController(1);
    _quantityToDispenseController = CountInputController(1);
    _numVezesController = CountInputController(1);
    _duracaoController = CountInputController(1);
    _otherIntervalController = TextEditingController();
    _additionalInstructionsController = TextEditingController();
    selectedPresentationId = 'base'; // Inicializar com base selecionada
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _quantityController.dispose();
    _quantityToDispenseController.dispose();
    _numVezesController.dispose();
    _duracaoController.dispose();
    _otherIntervalController.dispose();
    _additionalInstructionsController.dispose();
    super.dispose();
  }

  // Métodos auxiliares para obter o display name das keys
  String _getCategoryDisplay(String code) {
    return MedicalEnums.getAdministrationType(code)?.display ?? code;
  }

  String _getRouteDisplay(String code) {
    return MedicalEnums.getDrugAdministrationRoute(code)?.display ?? code;
  }

  String _getBaseDisplay(String code) {
    return MedicalEnums.getBase(code)?.display ?? code;
  }

  // Método para obter os activeIngredients da base selecionada
  List<filter.ActiveIngredientModel> _getActiveIngredientsForSelectedBase() {
    if (selectedCategory == null ||
        selectedRoute == null ||
        selectedBase == null) {
      return [];
    }

    final base = widget.medication.filters!
        .getCategory(selectedCategory!)
        ?.routes[selectedRoute!]
        ?.bases[selectedBase!];

    return base?.activeIngredients ?? [];
  }

  // Método para verificar se uma força é permitida baseada nas combinações já selecionadas
  bool _isStrengthAllowed(
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
    if (selectedStrengthsByActiveIngredient.isEmpty) {
      return true;
    }

    // Debug: verificar se combinations é válido
    try {
      // Se o ingrediente ativo não tem combinações definidas, permite todas
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
    if (selectedStrengthsByActiveIngredient.length == 1 &&
        selectedStrengthsByActiveIngredient
            .containsKey(activeIngredient.dcbCode)) {
      return true;
    }

    // Verifica se alguma das forças já selecionadas está na lista de combinações permitidas
    for (final selectedEntry in selectedStrengthsByActiveIngredient.entries) {
      final selectedDcb = selectedEntry.key;
      final selectedStrength = selectedEntry.value;

      // Se este é o mesmo ingrediente ativo, pula a verificação
      if (selectedDcb == activeIngredient.dcbCode) {
        continue;
      }

      // Encontra o modelo da força selecionada para obter seu ID
      final selectedActiveIngredient = _getActiveIngredientsForSelectedBase()
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

  // Método para resetar seleções quando categoria/base/rota mudam
  void _resetSelectionsFromLevel(String level) {
    switch (level) {
      case 'category':
        selectedRoute = null;
        selectedBase = null;
        selectedStrengthsByActiveIngredient.clear();
        selectedPresentationId = null;
        break;
      case 'route':
        selectedBase = null;
        selectedStrengthsByActiveIngredient.clear();
        selectedPresentationId = null;
        break;
      case 'base':
        selectedStrengthsByActiveIngredient.clear();
        selectedPresentationId = 'base'; // Resetar para base como padrão
        break;
    }
  }

  // Método para selecionar uma força e desmarcar todas as forças que não são aceitas com ela
  void _selectStrengthAndClearIncompatible(
      filter.ActiveIngredientModel targetActiveIngredient,
      String targetStrengthKey) {
    // Encontrar o modelo de força específico do chip clicado
    final targetStrengthModel = targetActiveIngredient.strengths.firstWhere(
      (strength) => '${strength.value} ${strength.unit}' == targetStrengthKey,
      orElse: () => filter.StrengthModel(value: 0, unit: ''),
    );

    setState(() {
      // Primeiro, marca a força clicada como selecionada
      selectedStrengthsByActiveIngredient[targetActiveIngredient.dcbCode] =
          targetStrengthKey;

      // Se o modelo de força não foi encontrado ou não tem ID, retorna
      if (targetStrengthModel.id == null) {
        return;
      }

      // Se o ingrediente ativo não tem combinações definidas, não precisa remover outras
      try {
        if (targetActiveIngredient.combinations.isEmpty) {
          return;
        }
      } catch (e) {
        print(
            'Err ao acessar combinations para ${targetActiveIngredient.name}: $e');
        return;
      }

      // Obter a lista de combinações permitidas para esta força específica
      List<String>? allowedCombinations;
      try {
        allowedCombinations =
            targetActiveIngredient.combinations[targetStrengthModel.id];
      } catch (e) {
        print(
            'Erro ao acessar combinations[${targetStrengthModel.id}] para ${targetActiveIngredient.name}: $e');
        return;
      }

      // Se não há combinações definidas para esta força específica, não precisa remover outras
      if (allowedCombinations == null || allowedCombinations.isEmpty) {
        return;
      }

      // Lista das forças que devem ser removidas
      final List<String> dcbsToRemove = [];

      // Verifica todas as forças selecionadas atualmente
      for (final selectedEntry in selectedStrengthsByActiveIngredient.entries) {
        final selectedDcb = selectedEntry.key;
        final selectedStrength = selectedEntry.value;

        // Se este é o mesmo ingrediente ativo, pula a verificação
        if (selectedDcb == targetActiveIngredient.dcbCode) {
          continue;
        }

        // Encontra o modelo da força selecionada para obter seu ID
        final selectedActiveIngredient = _getActiveIngredientsForSelectedBase()
            .firstWhere((ingredient) => ingredient.dcbCode == selectedDcb,
                orElse: () => filter.ActiveIngredientModel(
                    name: '', dcbCode: '', combinations: {}, strengths: []));

        if (selectedActiveIngredient.dcbCode.isEmpty) {
          continue;
        }

        final selectedStrengthModel =
            selectedActiveIngredient.strengths.firstWhere(
          (strength) =>
              '${strength.value} ${strength.unit}' == selectedStrength,
          orElse: () => filter.StrengthModel(value: 0, unit: ''),
        );

        // Se o ID da força selecionada não está nas combinações permitidas, marca para remoção
        if (selectedStrengthModel.id != null &&
            !allowedCombinations.contains(selectedStrengthModel.id)) {
          dcbsToRemove.add(selectedDcb);
        }
      }

      // Remove as forças incompatíveis
      for (final dcbToRemove in dcbsToRemove) {
        selectedStrengthsByActiveIngredient.remove(dcbToRemove);
      }

      // Reseta a apresentação selecionada para base pois as forças mudaram
      selectedPresentationId = 'base';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_helper.hasFilters) {
      return const Center(
        child: Text('Medicação sem filtros dinâmicos configurados'),
      );
    }

    return SizedBox(
      height: 600,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 4,
              bottom: 15,
            ),
            child: _buildDynamicPrescriptionForm(),
          ),
          _buildFloatingCard(),
        ],
      ),
    );
  }

  Widget _buildDynamicPrescriptionForm() {
    return CustomScrollbar(
      controller: _scrollController,
      trackMargin: const EdgeInsets.only(
        bottom: 100,
        top: 40,
      ),
      child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'Prescrição Simples',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                    const Divider(
                      height: 10,
                      color: AppTheme.themeAccent,
                    ),
                    const SizedBox(height: 6),
                    _buildMedicationHeader(),
                    const SizedBox(height: 6),
                    _buildThreeColumnSelection(),
                    const SizedBox(height: 6),
                    _buildStrengths(),
                    const SizedBox(height: 6),
                    _buildQuantityAdm(),
                    const SizedBox(height: 6),
                    _buildPleasureForm(),
                    const SizedBox(height: 6),
                    _buildDurationSection(),
                    const SizedBox(height: 6),
                    _buildQuantityToDispenseSection(),
                    const SizedBox(height: 6),
                    _buildAdditionalInstructionsSection(),
                    const SizedBox(height: 120),
                  ],
                ),
              ))),
    );
  }

  Widget _buildFloatingCard() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.primary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.primary.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Primeira linha: Nome medicamento - Base (dose) ----- quantidade a ser dispensada
            Row(
              children: [
                _buildMedicationDoseInfo(),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
                    child: Divider(color: AppTheme.info, height: 1),
                  ),
                ),
                _buildQuantityToDispense(),
              ],
            ),
            if (_canShowQuantityAdm && _getAprazamentoInfo().isNotEmpty) ...[
              _buildAprazamentoAndDuration(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationDoseInfo() {
    if (!_canShowQuantityAdm) {
      return Text(
        'Complete a configuração',
        style: TextStyle(
          fontSize: 12,
          color: Colors.white.withOpacity(0.8),
        ),
      );
    }

    final medicationName = widget.medication.displayName;
    final baseName = selectedBase != null ? _getBaseDisplay(selectedBase!) : '';
    final doseInfo = _getDoseInfo();

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
        children: [
          TextSpan(
            text: medicationName,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          if (baseName.isNotEmpty) ...[
            const TextSpan(text: ' - '),
            TextSpan(
              text: baseName,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
          if (doseInfo.isNotEmpty) ...[
            const TextSpan(text: ' ('),
            TextSpan(
              text: doseInfo,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const TextSpan(text: ')'),
          ],
        ],
      ),
    );
  }

  /// Calcula a quantidade total de unidades primárias baseada na apresentação selecionada
  String _calculateTotalQuantityDisplay(int quantity) {
    if (selectedPresentationId == null || selectedPresentationId == 'base') {
      final baseName =
          selectedBase != null ? _getBaseDisplay(selectedBase!) : '';
      return 'Qtd: $quantity $baseName';
    }

    final presentation =
        _helper.getPresentationDetails(selectedPresentationId!);
    if (presentation == null) {
      final baseName =
          selectedBase != null ? _getBaseDisplay(selectedBase!) : '';
      return 'Qtd: $quantity $baseName';
    }

    // Calcular quantidade total de unidades primárias (comprimidos, cápsulas, etc.)
    final totalPrimaryUnits = quantity * presentation.package.primary.quantity;
    final primaryTranslatedUnit = MedicalEnums.translateDispensationUnit(
        presentation.package.primary.dispensationUnit, selectedBase);

    // Pluralizar a unidade primária
    final pluralPrimaryUnit = totalPrimaryUnits > 1
        ? _pluralize(primaryTranslatedUnit)
        : primaryTranslatedUnit;

    // Traduzir a unidade secundária (caixa, frasco, etc.)
    final secondaryTranslatedUnit = MedicalEnums.translateDispensationUnit(
        presentation.package.secondary.dispensationUnit, selectedBase);

    // Mostrar: "03 caixas (10 comprimidos / caixa)"
    return '${quantity.toString().padLeft(2, '0')} $secondaryTranslatedUnit (${presentation.package.primary.quantity} $pluralPrimaryUnit / $secondaryTranslatedUnit)';
  }

  Widget _buildQuantityToDispense() {
    if (!_canShowQuantityAdm) {
      return const SizedBox.shrink();
    }

    final quantity = _quantityToDispenseController.value;
    final displayText = _calculateTotalQuantityDisplay(quantity);

    return Text(
      displayText,
      style: TextStyle(
        fontSize: 12,
        color: Colors.white.withOpacity(0.8),
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildAprazamentoAndDuration() {
    final aprazamentoInfo = _getAprazamentoInfo();
    final durationInfo = _getDurationInfo();

    if (aprazamentoInfo.isEmpty && durationInfo.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (aprazamentoInfo.isNotEmpty) ...[
            Text(
              aprazamentoInfo,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (durationInfo.isNotEmpty) const SizedBox(height: 4),
          ],
          if (durationInfo.isNotEmpty)
            Text(
              ', ${durationInfo.toLowerCase()}.',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
        ],
      ),
    );
  }

  String _getDoseInfo() {
    if (!_canShowQuantityAdm) return '';

    final List<String> doseComponents = [];

    // Filtrar apenas os ingredientes que têm forças selecionadas
    final activeIngredientsWithStrengths =
        _getActiveIngredientsForSelectedBase()
            .where((ingredient) => selectedStrengthsByActiveIngredient
                .containsKey(ingredient.dcbCode))
            .toList();

    for (final activeIngredient in activeIngredientsWithStrengths) {
      final selectedStrength =
          selectedStrengthsByActiveIngredient[activeIngredient.dcbCode];

      if (selectedStrength != null) {
        // Mostrar princípio ativo + força (sem calcular dose total)
        doseComponents.add('${activeIngredient.name} $selectedStrength');
      }
    }

    return doseComponents.join(' + ');
  }

  String _getAprazamentoInfo() {
    final quantity = _quantityController.value;
    final baseName = selectedBase != null ? _getBaseDisplay(selectedBase!) : '';
    final pluralBaseName = MedicalEnums.pluralizeUnit(baseName, quantity);

    switch (selectedPleasureForm) {
      case 'interval':
        if (selectedIntervalForm.isNotEmpty) {
          if (selectedIntervalForm == 'other') {
            return 'Tomar $quantity $pluralBaseName, ${_otherIntervalController.text}';
          } else {
            final intervalText =
                MedicalEnums.translateInterval(selectedIntervalForm);
            return 'Tomar $quantity $pluralBaseName, de $intervalText';
          }
        }
        break;
      case 'times_a_day':
        final numVezes = _numVezesController.value;
        final pluralVezes = MedicalEnums.pluralizeUnit('vez', numVezes);
        return 'Tomar $quantity $pluralBaseName, $numVezes $pluralVezes ao dia';
      case 'turning':
        if (selectedTurnForm.isNotEmpty) {
          final turnos = selectedTurnForm
              .map((turn) => MedicalEnums.translateTurn(turn).toLowerCase())
              .toList();

          if (turnos.length == 1) {
            return 'Tomar $quantity $pluralBaseName pela ${turnos[0]}';
          } else if (turnos.length == 2) {
            return 'Tomar $quantity $pluralBaseName pela ${turnos[0]} e pela ${turnos[1]}';
          } else {
            // Para 3 ou mais turnos, usar vírgulas e "e" antes do último
            final lastTurn = turnos.removeLast();
            return 'Tomar $quantity $pluralBaseName pela ${turnos.join(', ')} e pela $lastTurn';
          }
        }
        break;
      case 'meals':
        if (selectedReferenceForm.isNotEmpty && selectedMealsForm.isNotEmpty) {
          final reference =
              MedicalEnums.translateMealReference(selectedReferenceForm)
                  .toLowerCase();
          final meals = selectedMealsForm
              .map((meal) => MedicalEnums.translateMealType(meal))
              .toList();

          // Determinar a preposição correta baseado na referência
          String preposition;
          if (reference == 'após') {
            preposition = 'o';
          } else {
            preposition = 'do';
          }

          if (meals.length == 1) {
            return 'Tomar $quantity $pluralBaseName $reference $preposition ${meals[0]}';
          } else if (meals.length == 2) {
            return 'Tomar $quantity $pluralBaseName $reference $preposition ${meals[0]} e $preposition ${meals[1]}';
          } else {
            // Para 3 refeições, usar vírgulas e "e" antes da última
            final lastMeal = meals.removeLast();
            return 'Tomar $quantity $pluralBaseName $reference $preposition ${meals.join(', $preposition ')} e $preposition $lastMeal';
          }
        }
        break;
      case 'schedules':
        if (selectedTimeForm.isNotEmpty) {
          // Formatar horários convertendo "12 hour" para "às 12 horas"
          final formattedTimes = selectedTimeForm.map((time) {
            // Remove " hour" ou " hours" e adiciona "às X horas"
            final hourMatch =
                RegExp(r'(\d+)\s*(?:hour|hours)?').firstMatch(time);
            if (hourMatch != null) {
              final hour = hourMatch.group(1);
              return 'às $hour ${hour == '1' ? 'hora' : 'horas'}';
            }
            return 'às $time';
          }).toList();

          if (formattedTimes.length == 1) {
            return 'Tomar $quantity $pluralBaseName ${formattedTimes.first}';
          } else if (formattedTimes.length == 2) {
            return 'Tomar $quantity $pluralBaseName ${formattedTimes[0]} e ${formattedTimes[1]}';
          } else {
            final lastTime = formattedTimes.removeLast();
            return 'Tomar $quantity $pluralBaseName ${formattedTimes.join(', ')} e $lastTime';
          }
        }
        break;
    }
    return '';
  }

  String _getDurationInfo() {
    switch (selectedDurationForm) {
      case 'continuous_use':
        return 'Uso contínuo';
      case 'immediate_use':
        return 'Uso imediato';
      case 'per':
        final duracao = _duracaoController.value;
        final unidade =
            MedicalEnums.translateTimeUnit(selectedUnidadeForm, duracao);
        return 'Por $duracao $unidade';
      case 'for_until':
        final duracao = _duracaoController.value;
        final unidade =
            MedicalEnums.translateTimeUnit(selectedUnidadeForm, duracao);
        return 'Até $duracao $unidade';
      case 'symptoms':
        return 'Enquanto durarem os sintomas';
      default:
        return '';
    }
  }

  Widget _buildMedicationHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 6.0,
        ),
        child: Row(
          children: [
            SvgPicture.asset('assets/icons/${widget.medication.type}.svg'),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                widget.medication.displayName,
                style: AppTheme.p(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThreeColumnSelection() {
    if (!_helper.hasFilters) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Expanded(
              child: Divider(
                color: AppTheme.themeAccent,
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Coluna 1 (Esquerda): Base / Via / Categoria
            Expanded(
              flex: 1,
              child: _buildLeftColumn(),
            ),
            const SizedBox(width: 8),
            // Coluna 2 (Meio): Via / Categoria / Nenhum
            Expanded(
              flex: 1,
              child: _buildMiddleColumn(),
            ),
            const SizedBox(width: 8),
            // Coluna 3 (Direita): Categoria / Nenhum / Nenhum
            Expanded(
              flex: 1,
              child: _buildRightColumn(),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildLeftColumn() {
    // Posição 1: Base -> Via -> Categoria
    if (selectedCategory != null && selectedRoute != null && shouldShowBases) {
      // Mostra Base
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Base',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.secondaryText,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: _helper
                .getBaseOptions(selectedCategory!, selectedRoute!)
                .map((baseKey) => InputChipMedgo(
                      selectedChip: selectedBase == baseKey,
                      title: _getBaseDisplay(baseKey),
                      onSelected: (selected) {
                        setState(() {
                          selectedBase = selected ? baseKey : null;
                          // Reset das forças e apresentação quando a base muda
                          _resetSelectionsFromLevel('base');
                        });
                      },
                    ))
                .toList(),
          ),
        ],
      );
    } else if (selectedCategory != null && shouldShowRoutes) {
      // Mostra Via de Administração
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Via de Administração',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.secondaryText,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: _helper
                .getRouteOptions(selectedCategory!)
                .map((routeKey) => InputChipMedgo(
                      selectedChip: selectedRoute == routeKey,
                      title: _getRouteDisplay(routeKey),
                      onSelected: (selected) {
                        setState(() {
                          selectedRoute = selected ? routeKey : null;
                          selectedBase = null;
                        });
                      },
                    ))
                .toList(),
          ),
        ],
      );
    } else {
      // Mostra Categoria (estado inicial)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categoria',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.secondaryText,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: _helper
                .getCategoryOptions()
                .map((categoryKey) => InputChipMedgo(
                      selectedChip: selectedCategory == categoryKey,
                      title: _getCategoryDisplay(categoryKey),
                      onSelected: (selected) {
                        setState(() {
                          selectedCategory = selected ? categoryKey : null;
                          selectedRoute = null;
                          selectedBase = null;
                        });
                      },
                    ))
                .toList(),
          ),
        ],
      );
    }
  }

  Widget _buildMiddleColumn() {
    // Posição 2: Via -> Categoria -> Nenhum
    if (selectedCategory != null && selectedRoute != null && shouldShowBases) {
      // Mostra Via de Administração
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Via de Administração',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.secondaryText,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: _helper
                .getRouteOptions(selectedCategory!)
                .map((routeKey) => InputChipMedgo(
                      selectedChip: selectedRoute == routeKey,
                      title: _getRouteDisplay(routeKey),
                      onSelected: (selected) {
                        setState(() {
                          selectedRoute = selected ? routeKey : null;
                          selectedBase = null;
                        });
                      },
                    ))
                .toList(),
          ),
        ],
      );
    } else if (selectedCategory != null && shouldShowRoutes) {
      // Mostra Categoria
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categoria',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.secondaryText,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: _helper
                .getCategoryOptions()
                .map((categoryKey) => InputChipMedgo(
                      selectedChip: selectedCategory == categoryKey,
                      title: _getCategoryDisplay(categoryKey),
                      onSelected: (selected) {
                        setState(() {
                          selectedCategory = selected ? categoryKey : null;
                          selectedRoute = null;
                          selectedBase = null;
                        });
                      },
                    ))
                .toList(),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildRightColumn() {
    // Posição 3: Categoria -> Nenhum -> Nenhum
    if (selectedCategory != null && selectedRoute != null && shouldShowBases) {
      // Mostra Categoria
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categoria',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.secondaryText,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: _helper
                .getCategoryOptions()
                .map((categoryKey) => InputChipMedgo(
                      selectedChip: selectedCategory == categoryKey,
                      title: _getCategoryDisplay(categoryKey),
                      onSelected: (selected) {
                        setState(() {
                          selectedCategory = selected ? categoryKey : null;
                          selectedRoute = null;
                          selectedBase = null;
                        });
                      },
                    ))
                .toList(),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildStrengths() {
    if (!_canShowStrengths) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Expanded(
              child: Divider(
                color: AppTheme.themeAccent,
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ..._buildActiveIngredientsWithStrengths(),
      ],
    );
  }

  List<Widget> _buildActiveIngredientsWithStrengths() {
    final List<Widget> widgets = [];

    // Obter as forças disponíveis para a combinação atual
    final strengthsByActiveIngredient = _helper.getStrengthsByActiveIngredient(
      selectedCategory!,
      selectedRoute!,
      selectedBase!,
    );

    // Obter os ingredientes ativos da base selecionada
    final activeIngredientsFromBase = _getActiveIngredientsForSelectedBase();

    // Filtrar apenas os ingredientes ativos que têm forças disponíveis
    for (final activeIngredient in activeIngredientsFromBase) {
      if (strengthsByActiveIngredient.containsKey(activeIngredient.dcbCode)) {
        final strengths =
            strengthsByActiveIngredient[activeIngredient.dcbCode]!;

        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nome do princípio ativo
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Priníipio Ativo',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.secondaryText,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 160,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        activeIngredient.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                // Chips de força
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Força',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: strengths.map((strengthKey) {
                        final isSelected = selectedStrengthsByActiveIngredient[
                                activeIngredient.dcbCode] ==
                            strengthKey;
                        final isAllowed =
                            _isStrengthAllowed(activeIngredient, strengthKey);
                        return InputChipMedgo(
                          selectedChip: isSelected,
                          title: _getStrengthDisplay(strengthKey),
                          isInactive: !isAllowed,
                          onSelected: (selected) {
                            if (!isAllowed) return;
                            setState(() {
                              if (selected) {
                                selectedStrengthsByActiveIngredient[
                                    activeIngredient.dcbCode] = strengthKey;
                              } else {
                                selectedStrengthsByActiveIngredient
                                    .remove(activeIngredient.dcbCode);
                              }
                            });
                          },
                          onInactivePressed: () {
                            _selectStrengthAndClearIncompatible(
                                activeIngredient, strengthKey);
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    }

    return widgets;
  }

  String _getStrengthDisplay(String strengthKey) {
    // Por enquanto, retorna a key como está.
    // Futuramente pode ser melhorado para formatar melhor
    return strengthKey;
  }

  Widget _buildQuantityAdm() {
    if (!_canShowQuantityAdm) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Expanded(
              child: Divider(
                color: AppTheme.themeAccent,
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Quantidade por administração
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quantidade por administração:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.secondaryText,
                  ),
                ),
                const SizedBox(height: 4),
                CountInputMedgo(
                  controller: _quantityController,
                  label: _getBaseDisplay(selectedBase!),
                  minValue: 1,
                  onChanged: (value) {
                    // Callback quando a quantidade muda - força rebuild para atualizar dose
                    setState(() {});
                  },
                  onChangedByIcon: (value) {
                    // Callback quando os botões + ou - são pressionados
                    setState(() {});
                  },
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Card com dose por administração
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dose por administração:',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Wrap(
                          children: _buildDoseDisplay(),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  List<Widget> _buildDoseDisplay() {
    final List<Widget> widgets = [];
    final int quantity = _quantityController.value;

    // Filtrar apenas os ingredientes que têm forças selecionadas
    final activeIngredientsWithStrengths =
        _getActiveIngredientsForSelectedBase()
            .where((ingredient) => selectedStrengthsByActiveIngredient
                .containsKey(ingredient.dcbCode))
            .toList();

    for (int i = 0; i < activeIngredientsWithStrengths.length; i++) {
      final activeIngredient = activeIngredientsWithStrengths[i];
      final selectedStrength =
          selectedStrengthsByActiveIngredient[activeIngredient.dcbCode];
      final isLast = i == activeIngredientsWithStrengths.length - 1;

      if (selectedStrength != null) {
        // Extrair valor e unidade da força selecionada
        final strengthParts = selectedStrength.split(' ');
        if (strengthParts.length >= 2) {
          final double strengthValue = double.tryParse(strengthParts[0]) ?? 0;
          final String unit = strengthParts.sublist(1).join(' ');

          // Calcular dose total (força * quantidade)
          final double totalDose = strengthValue * quantity;

          // Formatar o valor total (mostrar inteiro se não tiver decimais)
          final String formattedDose = totalDose == totalDose.toInt()
              ? totalDose.toInt().toString()
              : totalDose.toString();

          final doseText = '${activeIngredient.name} $formattedDose $unit';

          widgets.add(
            Text(
              isLast ? doseText : '$doseText + ',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          );
        } else {
          final doseText = '${activeIngredient.name} $selectedStrength';
          widgets.add(
            Text(
              isLast ? doseText : '$doseText + ',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          );
        }
      }
    }

    return widgets;
  }

  Widget _buildPleasureForm() {
    if (!_canShowQuantityAdm) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Expanded(
              child: Divider(
                color: AppTheme.themeAccent,
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Forma de aprazamento
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Forma de aprazamento:',
                style: TextStyle(
                  color: Color(0xff57636C),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              CustomChipWrap(
                valueForm: ValueNotifier(selectedPleasureForm),
                items: itemsPleasureForm,
                onChange: (value) {
                  setState(() {
                    selectedPleasureForm = value;
                    // Reset campos quando muda o tipo
                    selectedIntervalForm = '';
                    showOtherIntervalField = false;
                  });
                },
              ),
            ],
          ),
        ),
        // Campos condicionais baseados no tipo de aprazamento
        if (selectedPleasureForm == 'interval') ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Intervalo entre as doses:',
                  style: TextStyle(
                    color: Color(0xff57636C),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                CustomChipWrap(
                  valueForm: ValueNotifier(selectedIntervalForm),
                  items: itemsIntervalos,
                  onChange: (value) {
                    setState(() {
                      selectedIntervalForm = value;
                      showOtherIntervalField = value == 'other';
                    });
                  },
                ),
              ],
            ),
          ),
        ],
        if (selectedPleasureForm == 'times_a_day') ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Número de vezes ao dia:',
                  style: TextStyle(
                    color: Color(0xff57636C),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                CountInputMedgo(
                  controller: _numVezesController,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ],
        if (selectedPleasureForm == 'turning') ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Turnos de uso:',
                  style: TextStyle(
                    color: Color(0xff57636C),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                CustomMultipleChipWrap(
                  valueForm: ValueNotifier(selectedTurnForm),
                  items: itemsTurno,
                  onChange: (value) {
                    setState(() {
                      selectedTurnForm = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
        if (selectedPleasureForm == 'meals') ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Referência:',
                  style: TextStyle(
                    color: Color(0xff57636C),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                CustomChipWrap(
                  valueForm: ValueNotifier(selectedReferenceForm),
                  items: itemsReference,
                  onChange: (value) {
                    setState(() {
                      selectedReferenceForm = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Refeições:',
                  style: TextStyle(
                    color: Color(0xff57636C),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                CustomMultipleChipWrap(
                  valueForm: ValueNotifier(selectedMealsForm),
                  items: itemsRefeicoes,
                  onChange: (value) {
                    setState(() {
                      selectedMealsForm = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
        if (selectedPleasureForm == 'schedules') ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Horários:',
                  style: TextStyle(
                    color: Color(0xff57636C),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                CustomMultipleChipWrap(
                  valueForm: ValueNotifier(selectedTimeForm),
                  items: itemsHorarios,
                  onChange: (value) {
                    setState(() {
                      selectedTimeForm = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
        // Campo de intervalo personalizado
        if (showOtherIntervalField) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShortTextInputMedgo(
                  controller: _otherIntervalController,
                  labelText: 'Intervalo personalizado',
                  hintText: 'Ex: 30 minutos',
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDurationSection() {
    if (!_canShowQuantityAdm) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Expanded(
              child: Divider(
                color: AppTheme.themeAccent,
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            children: [
              const Text(
                'Forma de duração do tratamento:',
                style: TextStyle(
                  color: Color(0xff57636C),
                  fontWeight: FontWeight.w700,
                ),
              ),
              CustomChipWrap(
                valueForm: ValueNotifier(selectedDurationForm),
                items: itemsDurationOfTreatment,
                onChange: (value) {
                  setState(() {
                    selectedDurationForm = value;
                  });
                },
              ),
            ],
          ),
        ),
        // Campos condicionais para duração
        if (selectedDurationForm == 'per' ||
            selectedDurationForm == 'for_until') ...[
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Duração:',
                          style: TextStyle(
                            color: Color(0xff57636C),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        CountInputMedgo(
                          controller: _duracaoController,
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Unidade:',
                          style: TextStyle(
                            color: Color(0xff57636C),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        CustomChipWrap(
                          valueForm: ValueNotifier(selectedUnidadeForm),
                          items: itemsUnidade,
                          onChange: (value) {
                            setState(() {
                              selectedUnidadeForm = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPresentationChips() {
    // Obter os IDs das forças selecionadas
    final selectedStrengthIds = <String>[];

    for (final activeIngredient in _getActiveIngredientsForSelectedBase()) {
      final selectedStrength =
          selectedStrengthsByActiveIngredient[activeIngredient.dcbCode];
      if (selectedStrength != null) {
        // Encontrar o ID da força selecionada
        final strengthModel = activeIngredient.strengths.firstWhere(
          (strength) =>
              '${strength.value} ${strength.unit}' == selectedStrength,
          orElse: () => filter.StrengthModel(value: 0, unit: ''),
        );

        if (strengthModel.id != null) {
          selectedStrengthIds.add(strengthModel.id!);
        }
      }
    }

    if (selectedStrengthIds.isEmpty) {
      return const SizedBox.shrink();
    }

    // Buscar apresentações para a combinação atual
    final presentationIds = _helper.getPresentationsForCombination(
      selectedCategory!,
      selectedRoute!,
      selectedBase!,
      selectedStrengthIds,
    );

    // Criar lista de chips com a base como opção padrão
    final List<Widget> chips = [];

    // Chip padrão da base (sempre primeira opção)
    final baseDisplayName = _getBaseDisplay(selectedBase!);
    final isBaseSelected =
        selectedPresentationId == null || selectedPresentationId == 'base';

    chips.add(
      InputChipMedgo(
        title: baseDisplayName,
        selectedChip: isBaseSelected,
        onSelected: (selected) {
          setState(() {
            selectedPresentationId = selected ? 'base' : null;
          });
        },
      ),
    );

    // Chips das apresentações específicas
    for (final presentationId in presentationIds) {
      final presentation = _helper.getPresentationDetails(presentationId);
      if (presentation != null) {
        final isSelected = selectedPresentationId == presentationId;

        chips.add(
          InputChipMedgo(
            title: _getPresentationChipLabel(presentation),
            selectedChip: isSelected,
            onSelected: (selected) {
              setState(() {
                selectedPresentationId = selected ? presentationId : null;
              });
            },
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Unidade de medida:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.secondaryText,
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: chips,
        ),
      ],
    );
  }

  String _getPresentationChipLabel(PresentationModel presentation) {
    final primary = presentation.package.primary;
    final secondary = presentation.package.secondary;

    // Traduzir a unidade de dispensação
    final translatedUnit = MedicalEnums.translateDispensationUnit(
        secondary.dispensationUnit, selectedBase);

    // Traduzir a unidade primária (comprimidos, cápsulas, etc.)
    final primaryTranslatedUnit = MedicalEnums.translateDispensationUnit(
        primary.dispensationUnit, selectedBase);

    // Formato: "caixa com 10 comprimidos" ou "frasco com 100ml"
    String label;

    if (secondary.quantity == 1) {
      // Para quantidade 1, mostrar: "1 caixa com 10 comprimidos"
      label =
          '${secondary.quantity} $translatedUnit com ${primary.quantity} $primaryTranslatedUnit';

      if (primary.concentration != null) {
        final concentrationValue = primary.concentration!.value;
        final concentrationUnit = primary.concentration!.unit.toLowerCase();

        // Formatar concentração adequadamente
        final formattedValue = concentrationValue == concentrationValue.toInt()
            ? concentrationValue.toInt().toString()
            : concentrationValue.toString();

        label += ' ${formattedValue}${concentrationUnit}';
      }
    } else {
      // Para quantidade > 1, mostrar: "2 caixas com 10 comprimidos cada"
      final pluralUnit =
          secondary.quantity > 1 ? _pluralize(translatedUnit) : translatedUnit;

      final pluralPrimaryUnit = primary.quantity > 1
          ? _pluralize(primaryTranslatedUnit)
          : primaryTranslatedUnit;

      label =
          '${secondary.quantity} $pluralUnit com ${primary.quantity} $pluralPrimaryUnit';

      if (primary.concentration != null) {
        final concentrationValue = primary.concentration!.value;
        final concentrationUnit = primary.concentration!.unit.toLowerCase();

        final formattedValue = concentrationValue == concentrationValue.toInt()
            ? concentrationValue.toInt().toString()
            : concentrationValue.toString();

        label += ' ${formattedValue}${concentrationUnit}';
      }
    }

    return label;
  }

  String _pluralize(String word) {
    // Regras básicas de pluralização em português
    if (word.endsWith('ão')) {
      return word.replaceAll('ão', 'ões');
    } else if (word.endsWith('l')) {
      return word.replaceAll('l', 'is');
    } else if (word.endsWith('m')) {
      return word.replaceAll('m', 'ns');
    } else if (word.endsWith('r') || word.endsWith('s') || word.endsWith('z')) {
      return '${word}es';
    } else {
      return '${word}s';
    }
  }

  String _getPresentationDisplayLabel() {
    if (selectedPresentationId == null || selectedPresentationId == 'base') {
      return _getBaseDisplay(selectedBase!);
    }

    final presentation =
        _helper.getPresentationDetails(selectedPresentationId!);
    if (presentation == null) {
      return _getBaseDisplay(selectedBase!);
    }

    // Traduzir a unidade de dispensação
    final translatedUnit = MedicalEnums.translateDispensationUnit(
        presentation.package.secondary.dispensationUnit, selectedBase);

    return translatedUnit;
  }

  Widget _buildQuantityToDispenseSection() {
    if (!_canShowQuantityAdm) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Expanded(
              child: Divider(
                color: AppTheme.themeAccent,
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quantidade a ser dispensada:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CountInputMedgo(
                    controller: _quantityToDispenseController,
                    label: _getPresentationDisplayLabel(),
                    minValue: 1,
                    onChanged: (value) {
                      // Callback quando a quantidade muda - força rebuild para atualizar card flutuante
                      setState(() {});
                    },
                    onChangedByIcon: (value) {
                      // Callback quando os botões + ou - são pressionados
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
              const SizedBox(
                width: 16,
              ),
              _buildPresentationChips(),
            ],
          ),
        ),
      ],
    );
  }

  bool get shouldShowRoutes {
    return _helper.hasFilters &&
        selectedCategory != null &&
        _helper.getRouteOptions(selectedCategory!).isNotEmpty;
  }

  bool get shouldShowBases {
    return shouldShowRoutes &&
        selectedRoute != null &&
        _helper.getBaseOptions(selectedCategory!, selectedRoute!).isNotEmpty;
  }

  bool get _canShowStrengths {
    return selectedCategory != null &&
        selectedRoute != null &&
        selectedBase != null &&
        shouldShowBases;
  }

  bool get _canShowQuantityAdm {
    if (!_canShowStrengths) return false;

    // Verifica se todos os ingredientes ativos disponíveis têm uma força selecionada
    final strengthsByActiveIngredient = _helper.getStrengthsByActiveIngredient(
      selectedCategory!,
      selectedRoute!,
      selectedBase!,
    );

    for (final activeIngredient in _getActiveIngredientsForSelectedBase()) {
      if (strengthsByActiveIngredient.containsKey(activeIngredient.dcbCode)) {
        // Se este ingrediente tem forças disponíveis mas nenhuma selecionada, não pode mostrar
        if (!selectedStrengthsByActiveIngredient
            .containsKey(activeIngredient.dcbCode)) {
          return false;
        }
      }
    }

    // Se chegou aqui, todos os ingredientes disponíveis têm forças selecionadas
    return selectedStrengthsByActiveIngredient.isNotEmpty;
  }

  // Método para gerar os dados da prescrição no formato esperado pela API
  Map<String, dynamic> generatePrescriptionData() {
    if (!_canShowQuantityAdm) {
      throw Exception('Configuração incompleta para gerar prescrição');
    }

    // Gerar activeIngredients
    final List<Map<String, dynamic>> activeIngredients = [];
    for (final entry in selectedStrengthsByActiveIngredient.entries) {
      final dcbCode = entry.key;
      final strengthKey = entry.value;

      // Encontrar o ingrediente ativo correspondente
      final activeIngredient = _getActiveIngredientsForSelectedBase()
          .firstWhere((ingredient) => ingredient.dcbCode == dcbCode);

      // Extrair valor e unidade da força
      final strengthParts = strengthKey.split(' ');
      final strengthValue = double.tryParse(strengthParts[0]) ?? 0;
      final strengthUnit = strengthParts.sublist(1).join(' ');

      activeIngredients.add({
        'dcbCode': dcbCode,
        'name': activeIngredient.name,
        'strengthValue': strengthValue,
        'strengthUnit': strengthUnit,
      });
    }

    // Gerar selectedActiveIngredients
    final List<Map<String, dynamic>> selectedActiveIngredients = [];
    for (final entry in selectedStrengthsByActiveIngredient.entries) {
      final dcbCode = entry.key;
      final strengthKey = entry.value;

      // Encontrar o ID da força selecionada
      final activeIngredient = _getActiveIngredientsForSelectedBase()
          .firstWhere((ingredient) => ingredient.dcbCode == dcbCode);

      final strengthModel = activeIngredient.strengths.firstWhere(
        (strength) => '${strength.value} ${strength.unit}' == strengthKey,
        orElse: () => filter.StrengthModel(value: 0, unit: ''),
      );

      if (strengthModel.id != null) {
        selectedActiveIngredients.add({
          'code': strengthModel.id!,
          'value': strengthModel.value,
          'unit': strengthModel.unit,
        });
      }
    }

    // Gerar selectedStrengthCombination
    final List<String> strengthCombinations = [];
    for (final entry in selectedStrengthsByActiveIngredient.entries) {
      final dcbCode = entry.key;
      final strengthKey = entry.value;

      final activeIngredient = _getActiveIngredientsForSelectedBase()
          .firstWhere((ingredient) => ingredient.dcbCode == dcbCode);

      final strengthModel = activeIngredient.strengths.firstWhere(
        (strength) => '${strength.value} ${strength.unit}' == strengthKey,
        orElse: () => filter.StrengthModel(value: 0, unit: ''),
      );

      if (strengthModel.id != null) {
        strengthCombinations.add(
            '${strengthModel.id}_${strengthModel.value}_${strengthModel.unit.toUpperCase()}');
      }
    }

    // Gerar dosage
    final dosage = _generateDosageText();

    // Gerar durationTreatmentData
    Map<String, dynamic> durationTreatmentData = {};
    switch (selectedDurationForm) {
      case 'continuous_use':
        durationTreatmentData = {
          'form': 'continuous_use',
        };
        break;
      case 'immediate_use':
        durationTreatmentData = {
          'form': 'immediate_use',
        };
        break;
      case 'per':
        durationTreatmentData = {
          'form': 'per',
          'unit': selectedUnidadeForm,
          'duration': _duracaoController.value,
        };
        break;
      case 'for_until':
        durationTreatmentData = {
          'form': 'for_until',
          'unit': selectedUnidadeForm,
          'duration': _duracaoController.value,
        };
        break;
      case 'symptoms':
        durationTreatmentData = {
          'form': 'symptoms',
        };
        break;
      default:
        durationTreatmentData = {
          'form': 'continuous_use', // Fallback
        };
        break;
    }

    // Gerar dispensationData
    final quantity = _quantityToDispenseController.value;
    String unit = 'box'; // Default
    if (selectedPresentationId != null && selectedPresentationId != 'base') {
      final presentation =
          _helper.getPresentationDetails(selectedPresentationId!);
      if (presentation != null) {
        unit = presentation.package.secondary.dispensationUnit;
      }
    } else {
      unit = selectedBase ?? 'box';
    }

    final dispensationData = {
      'quantity': quantity,
      'unit': unit,
      'remainingQuantity': 0, // Default value
    };

    // Gerar additionalInstructions
    final additionalInstructions = _generateAdditionalInstructions();

    return {
      'entitiesIds': widget.medication.medications.isNotEmpty
          ? [widget.medication.medications.first.id] // ID da primeira medicação
          : [], // Fallback se não houver medicações
      'instructions': {
        'type': 'simple',
        'data': {
          'basis': selectedBase,
          'administration': {
            'route': selectedRoute,
            'category': selectedCategory,
            'quantity': _quantityController.value,
          },
          'activeIngredients': activeIngredients,
          'pleasureForm': selectedPleasureForm,
          'durationTreatmentData': durationTreatmentData,
          'dispensationData': dispensationData,
          'additionalInstructions': additionalInstructions,
          'dosage': dosage,
          'selectedPresentation': selectedPresentationId ?? 'base',
          'selectedStrengthCombination': strengthCombinations.join('+'),
          'selectedActiveIngredients': selectedActiveIngredients,
          'selectedFormFilters': {
            'category': selectedCategory,
            'route': selectedRoute,
            'basis': selectedBase,
          },
        },
        'manualMedicalAdvice': [],
      },
    };
  }

  String _generateDosageText() {
    final quantity = _quantityController.value;
    final baseName = selectedBase != null ? _getBaseDisplay(selectedBase!) : '';
    final pluralBaseName = MedicalEnums.pluralizeUnit(baseName, quantity);
    final aprazamento = _getAprazamentoInfo();
    final duration = _getDurationInfo();

    return '$quantity $pluralBaseName $aprazamento${duration.isNotEmpty ? ', $duration' : ''}';
  }

  Widget _buildAdditionalInstructionsSection() {
    if (!_canShowQuantityAdm) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Expanded(
              child: Divider(
                color: AppTheme.themeAccent,
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
          child: ShortTextInputMedgo(
            controller: _additionalInstructionsController,
            labelText: 'Adicional',
            hintText: 'Ex: Tomar com água, evitar álcool...',
            onChanged: (value) {
              // Callback quando o texto muda - força rebuild para atualizar card flutuante
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  String _generateAdditionalInstructions() {
    return _additionalInstructionsController.text.trim();
  }
}
