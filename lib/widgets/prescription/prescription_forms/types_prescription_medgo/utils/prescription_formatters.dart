import 'package:medgo/data/models/dynamic_prescription_filter_model.dart'
    as filter;
import 'package:medgo/widgets/prescription/prescription_forms/types_prescription_medgo/models/simple_prescription_state.dart';

/// Classe utilitária para formatação e cálculos relacionados à prescrição
class PrescriptionFormatters {
  /// Calcula e formata informações da dose
  static String getDoseInfo(
    SimplePrescriptionState state,
    List<filter.ActiveIngredientModel> activeIngredients,
  ) {
    if (!_canShowQuantityAdm(state, activeIngredients)) return '';

    final List<String> doseComponents = [];
    final int quantity = state.quantity;

    // Filtrar apenas os ingredientes que têm forças selecionadas
    final activeIngredientsWithStrengths = activeIngredients
        .where((ingredient) => state.selectedStrengthsByActiveIngredient
            .containsKey(ingredient.dcbCode))
        .toList();

    for (final activeIngredient in activeIngredientsWithStrengths) {
      final selectedStrength =
          state.selectedStrengthsByActiveIngredient[activeIngredient.dcbCode];

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

          doseComponents.add('$formattedDose $unit');
        } else {
          doseComponents.add(selectedStrength);
        }
      }
    }

    return doseComponents.join(' + ');
  }

  /// Formata informações do aprazamento
  static String getAprazamentoInfo(SimplePrescriptionState state) {
    switch (state.selectedPleasureForm) {
      case 'interval':
        if (state.selectedIntervalForm.isNotEmpty) {
          if (state.selectedIntervalForm == 'other' &&
              state.otherInterval.isNotEmpty) {
            return 'A cada ${state.otherInterval}';
          } else {
            // Mapear os valores para textos mais legíveis
            final intervalMap = {
              '6_hours': '6 em 6 horas',
              '8_hours': '8 em 8 horas',
              '12_hours': '12 em 12 horas',
              '24_hours': '24 em 24 horas',
              'if_necessary': 'Se necessário',
            };
            return intervalMap[state.selectedIntervalForm] ??
                state.selectedIntervalForm;
          }
        }
        break;
      case 'times_a_day':
        final numVezes = state.numVezes;
        return '$numVezes ${numVezes == 1 ? 'vez' : 'vezes'} ao dia';
      case 'turning':
        if (state.selectedTurnForm.isNotEmpty) {
          return state.selectedTurnForm.map((turn) {
            final turnMap = {
              'morning': 'Manhã',
              'afternoon': 'Tarde',
              'night': 'Noite',
            };
            return turnMap[turn] ?? turn;
          }).join(', ');
        }
        break;
      case 'meals':
        if (state.selectedReferenceForm.isNotEmpty &&
            state.selectedMealsForm.isNotEmpty) {
          final referenceMap = {
            'before': 'Antes',
            'during': 'Durante',
            'after': 'Após',
          };
          final mealsMap = {
            'breakfast': 'café da manhã',
            'lunch': 'almoço',
            'dinner': 'jantar',
          };
          final reference = referenceMap[state.selectedReferenceForm] ??
              state.selectedReferenceForm;
          final meals = state.selectedMealsForm
              .map((meal) => mealsMap[meal] ?? meal)
              .join(', ');
          return '$reference $meals';
        }
        break;
      case 'schedules':
        if (state.selectedTimeForm.isNotEmpty) {
          return 'Às ${state.selectedTimeForm.join(', ')}';
        }
        break;
    }
    return '';
  }

  /// Formata informações da duração
  static String getDurationInfo(SimplePrescriptionState state) {
    switch (state.selectedDurationForm) {
      case 'continuous_use':
        return 'Uso contínuo';
      case 'per':
        final duracao = state.duracao;
        final unidadeMap = {
          'days': duracao == 1 ? 'dia' : 'dias',
          'weeks': duracao == 1 ? 'semana' : 'semanas',
          'months': duracao == 1 ? 'mês' : 'meses',
        };
        final unidade =
            unidadeMap[state.selectedUnidadeForm] ?? state.selectedUnidadeForm;
        return 'Por $duracao $unidade';
      case 'for_until':
        final duracao = state.duracao;
        final unidadeMap = {
          'days': duracao == 1 ? 'dia' : 'dias',
          'weeks': duracao == 1 ? 'semana' : 'semanas',
          'months': duracao == 1 ? 'mês' : 'meses',
        };
        final unidade =
            unidadeMap[state.selectedUnidadeForm] ?? state.selectedUnidadeForm;
        return 'Até $duracao $unidade';
      default:
        return '';
    }
  }

  /// Verifica se pode mostrar quantidade de administração
  static bool _canShowQuantityAdm(
    SimplePrescriptionState state,
    List<filter.ActiveIngredientModel> activeIngredients,
  ) {
    if (state.selectedCategory == null ||
        state.selectedRoute == null ||
        state.selectedBase == null) {
      return false;
    }

    // Verifica se todos os ingredientes ativos disponíveis têm uma força selecionada
    for (final activeIngredient in activeIngredients) {
      if (!state.selectedStrengthsByActiveIngredient
          .containsKey(activeIngredient.dcbCode)) {
        return false;
      }
    }

    return state.selectedStrengthsByActiveIngredient.isNotEmpty;
  }
}
