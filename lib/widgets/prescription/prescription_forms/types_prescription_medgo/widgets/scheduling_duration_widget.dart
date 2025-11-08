import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/count_input/count_input.dart';
import 'package:medgo/widgets/news_widgets/short_text_input.dart';
import 'package:medgo/widgets/prescription/widget/custom_chip_multiple_wrap.dart';
import 'package:medgo/widgets/prescription/widget/custom_chip_wrap.dart';
import 'package:medgo/widgets/prescription/prescription_forms/simple_form_variables.dart';
import 'package:medgo/widgets/prescription/prescription_forms/types_prescription_medgo/controllers/simple_prescription_controller.dart';
import 'package:medgo/widgets/prescription/prescription_forms/types_prescription_medgo/models/simple_prescription_state.dart';

/// Widget responsável pela configuração do aprazamento e duração do tratamento
class SchedulingAndDurationWidget extends StatelessWidget {
  final SimplePrescriptionController controller;
  final SimplePrescriptionState state;

  const SchedulingAndDurationWidget({
    super.key,
    required this.controller,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (!controller.canShowQuantityAdm) return const SizedBox.shrink();

    return ListenableBuilder(
      listenable: state,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPleasureFormSection(),
            const SizedBox(height: 16),
            _buildDurationSection(),
          ],
        );
      },
    );
  }

  Widget _buildPleasureFormSection() {
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
                valueForm: ValueNotifier(state.selectedPleasureForm),
                items: itemsPleasureForm,
                onChange: (value) {
                  controller.selectPleasureForm(value);
                },
              ),
            ],
          ),
        ),
        // Campos condicionais baseados no tipo de aprazamento
        if (state.selectedPleasureForm == 'interval') ...[
          _buildIntervalSection(),
        ],
        if (state.selectedPleasureForm == 'times_a_day') ...[
          _buildTimesADaySection(),
        ],
        if (state.selectedPleasureForm == 'turning') ...[
          _buildTurningSection(),
        ],
        if (state.selectedPleasureForm == 'meals') ...[
          _buildMealsSection(),
        ],
        if (state.selectedPleasureForm == 'schedules') ...[
          _buildSchedulesSection(),
        ],
        // Campo de intervalo personalizado
        if (state.showOtherIntervalField) ...[
          _buildOtherIntervalSection(),
        ],
      ],
    );
  }

  Widget _buildIntervalSection() {
    return Padding(
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
            valueForm: ValueNotifier(state.selectedIntervalForm),
            items: itemsIntervalos,
            onChange: (value) {
              controller.selectIntervalForm(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimesADaySection() {
    return Padding(
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
            controller: state.numVezesController,
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }

  Widget _buildTurningSection() {
    return Padding(
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
            valueForm: ValueNotifier(state.selectedTurnForm),
            items: itemsTurno,
            onChange: (value) {
              controller.selectTurnForm(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMealsSection() {
    return Column(
      children: [
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
                valueForm: ValueNotifier(state.selectedReferenceForm),
                items: itemsReference,
                onChange: (value) {
                  controller.selectReferenceForm(value);
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
                valueForm: ValueNotifier(state.selectedMealsForm),
                items: itemsRefeicoes,
                onChange: (value) {
                  controller.selectMealsForm(value);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSchedulesSection() {
    return Padding(
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
            valueForm: ValueNotifier(state.selectedTimeForm),
            items: itemsHorarios,
            onChange: (value) {
              controller.selectTimeForm(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOtherIntervalSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShortTextInputMedgo(
            controller: state.otherIntervalController,
            labelText: 'Intervalo personalizado',
            hintText: 'Ex: 30 minutos',
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }

  Widget _buildDurationSection() {
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
                valueForm: ValueNotifier(state.selectedDurationForm),
                items: itemsDurationOfTreatment,
                onChange: (value) {
                  controller.selectDurationForm(value);
                },
              ),
            ],
          ),
        ),
        // Campos condicionais para duração
        if (state.selectedDurationForm == 'per' ||
            state.selectedDurationForm == 'for_until') ...[
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
                          controller: state.duracaoController,
                          onChanged: (value) {},
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
                          valueForm: ValueNotifier(state.selectedUnidadeForm),
                          items: itemsUnidade,
                          onChange: (value) {
                            controller.selectUnidadeForm(value);
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
}
