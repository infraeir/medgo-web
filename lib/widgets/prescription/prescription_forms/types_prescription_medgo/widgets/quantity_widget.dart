import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/count_input/count_input.dart';
import 'package:medgo/widgets/prescription/prescription_forms/types_prescription_medgo/controllers/simple_prescription_controller.dart';
import 'package:medgo/widgets/prescription/prescription_forms/types_prescription_medgo/models/simple_prescription_state.dart';

/// Widget responsável pela configuração da quantidade por administração
class QuantityWidget extends StatelessWidget {
  final SimplePrescriptionController controller;
  final SimplePrescriptionState state;

  const QuantityWidget({
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
                      controller: state.quantityController,
                      label: state.selectedBase != null
                          ? controller.getBaseDisplay(state.selectedBase!)
                          : '',
                      minValue: 1,
                      onChanged: (value) {
                        // Callback quando a quantidade muda - força rebuild para atualizar dose
                        // A notificação já é feita pelo state
                      },
                      onChangedByIcon: (value) {
                        // Callback quando os botões + ou - são pressionados
                        // A notificação já é feita pelo state
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
                            Row(
                              children: [
                                ..._buildDoseDisplay(),
                              ],
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
      },
    );
  }

  List<Widget> _buildDoseDisplay() {
    final List<Widget> widgets = [];
    final int quantity = state.quantity;

    // Filtrar apenas os ingredientes que têm forças selecionadas
    final activeIngredientsWithStrengths = controller
        .getActiveIngredientsForSelectedBase()
        .where((ingredient) => state.selectedStrengthsByActiveIngredient
            .containsKey(ingredient.dcbCode))
        .toList();

    for (int i = 0; i < activeIngredientsWithStrengths.length; i++) {
      final activeIngredient = activeIngredientsWithStrengths[i];
      final selectedStrength =
          state.selectedStrengthsByActiveIngredient[activeIngredient.dcbCode];
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
}
