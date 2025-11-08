import 'package:flutter/material.dart';
import 'package:medgo/data/models/medication_model.dart';
import 'package:medgo/data/models/new_prescription_model.dart';
import 'package:medgo/widgets/news_widgets/count_input/count_input_controller.dart';

class NewSimpleFormController {
  final CountInputController controllerQtdGotas = CountInputController(0);
  final CountInputController controllerDuracao = CountInputController(0);
  final TextEditingController controllerAdicional = TextEditingController();
  final CountInputController controllerNumVezes = CountInputController(0);

  final ValueNotifier<String> pleasureForm = ValueNotifier<String>('interval');
  final ValueNotifier<String> intervalForm = ValueNotifier<String>('');
  final ValueNotifier<List<String>> mealsForm = ValueNotifier<List<String>>([]);
  final ValueNotifier<List<String>> timeForm = ValueNotifier<List<String>>([]);
  final ValueNotifier<List<String>> turnForm = ValueNotifier<List<String>>([]);
  final ValueNotifier<String> referenceForm = ValueNotifier<String>('');
  final ValueNotifier<String> durationForm =
      ValueNotifier<String>('continuous_use');
  final ValueNotifier<String> unidadeForm = ValueNotifier<String>('');
  final TextEditingController otherIntervalController = TextEditingController();
  final ValueNotifier<bool> showOtherIntervalField = ValueNotifier<bool>(false);

  final ValueNotifier<bool> favourite = ValueNotifier<bool>(false);

  void configurarForm(ItemModel medication) {
    DosageDataModel dosage = medication.instructions.data;

    favourite.value = medication.isFavorite;

    controllerQtdGotas.value = dosage.quantity ?? 0;
    controllerAdicional.text = dosage.additionalInstructions == null
        ? ''
        : dosage.additionalInstructions.toString();
    controllerDuracao.value = dosage.durationTreatmentData?.duration ?? 0;
    durationForm.value = dosage.durationTreatmentData?.form ?? 'continuous_use';
    unidadeForm.value = dosage.durationTreatmentData?.unit ?? 'hours';

    switch (dosage.pleasureForm) {
      case 'interval':
        pleasureForm.value = 'interval';
        intervalForm.value = dosage.intervalBetweenDoses ?? '';
        break;
      case 'timesADay':
        pleasureForm.value = 'times_a_day';
        controllerNumVezes.value = dosage.timesADay ?? 0;
        break;
      case 'turning':
        pleasureForm.value = 'turning';
        turnForm.value = dosage.useTurns == null ? [] : dosage.useTurns!;
        break;
      case 'meals':
        pleasureForm.value = 'meals';
        referenceForm.value = dosage.reference ?? '';
        mealsForm.value = dosage.meals == null ? [] : dosage.meals!;
        break;
      case 'time':
        pleasureForm.value = 'time';
        timeForm.value = dosage.schedules == null ? [] : dosage.schedules!;
        break;
      default:
    }
  }

  void configurarFormMedication(MedicationModel medication) {
    // Configurar valores padrão para nova prescrição com MedicationModel
    favourite.value = false; // MedicationModel não tem propriedade isFavorite

    // Resetar todos os valores para um novo formulário
    controllerQtdGotas.value = 0;
    controllerAdicional.text = '';
    controllerDuracao.value = 0;
    controllerNumVezes.value = 0;

    // Configurar valores padrão
    pleasureForm.value = 'interval';
    intervalForm.value = '';
    mealsForm.value = [];
    timeForm.value = [];
    turnForm.value = [];
    referenceForm.value = '';
    durationForm.value = 'continuous_use';
    unidadeForm.value = 'hours';

    otherIntervalController.text = '';
    showOtherIntervalField.value = false;
  }

  Map<String, dynamic> buildDosageData() {
    switch (pleasureForm.value) {
      case 'interval':
        return {
          "pleasureForm": pleasureForm.value,
          "quantity": controllerQtdGotas.value,
          "intervalBetweenDoses": intervalForm.value,
          "additionalInstructions": controllerAdicional.text,
          "medicationPresentation": "oral_solution_drops"
        };
      case 'times_a_day':
        return {
          "pleasureForm": pleasureForm.value,
          "quantity": controllerQtdGotas.value,
          "timesADay": controllerNumVezes.value,
          "additionalInstructions": controllerAdicional.text,
          "medicationPresentation": "oral_solution_drops"
        };
      case 'turning':
        return {
          "pleasureForm": pleasureForm.value,
          "quantity": controllerQtdGotas.value,
          "useTurns": turnForm.value,
          "additionalInstructions": controllerAdicional.text,
          "medicationPresentation": "oral_solution_drops"
        };
      case 'meals':
        return {
          "pleasureForm": pleasureForm.value,
          "quantity": controllerQtdGotas.value,
          "reference": referenceForm.value,
          "meals": mealsForm.value,
          "additionalInstructions": controllerAdicional.text,
          "medicationPresentation": "oral_solution_drops"
        };
      case 'time':
        return {
          "pleasureForm": pleasureForm.value,
          "quantity": controllerQtdGotas.value,
          "schedules": timeForm.value,
          "additionalInstructions": controllerAdicional.text,
          "medicationPresentation": "oral_solution_drops"
        };
      default:
        return {};
    }
  }

  Map<String, dynamic> buildDurationTreatmentData() {
    switch (durationForm.value) {
      case 'continuous_use':
      case 'immediate_use':
      case 'symptoms':
        return {
          "form": durationForm.value,
        };
      case 'per':
      case 'for_until':
        return {
          "form": durationForm.value,
          "duration": controllerDuracao.value,
          "unit": unidadeForm.value,
        };
      default:
        return {};
    }
  }

  void gravarDosagem(Function(dynamic data) adicionarReceita) {
    final dataDosage = buildDosageData();
    final durationTreatmentData = buildDurationTreatmentData();

    if (durationTreatmentData.isNotEmpty) {
      dataDosage['durationTreatmentData'] = durationTreatmentData;
    }

    adicionarReceita(dataDosage);
  }
}
