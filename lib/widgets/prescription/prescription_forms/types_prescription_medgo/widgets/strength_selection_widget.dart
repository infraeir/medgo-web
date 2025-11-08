import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/input_chip.dart';
import 'package:medgo/widgets/prescription/prescription_forms/types_prescription_medgo/controllers/simple_prescription_controller.dart';
import 'package:medgo/widgets/prescription/prescription_forms/types_prescription_medgo/models/simple_prescription_state.dart';

/// Widget responsável pela seleção das forças dos ingredientes ativos
class StrengthSelectionWidget extends StatelessWidget {
  final SimplePrescriptionController controller;
  final SimplePrescriptionState state;

  const StrengthSelectionWidget({
    super.key,
    required this.controller,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (!controller.canShowStrengths) return const SizedBox.shrink();

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
            ..._buildActiveIngredientsWithStrengths(),
          ],
        );
      },
    );
  }

  List<Widget> _buildActiveIngredientsWithStrengths() {
    final List<Widget> widgets = [];

    // Obter as forças disponíveis para a combinação atual
    final strengthsByActiveIngredient =
        controller.getStrengthsByActiveIngredient(
      state.selectedCategory!,
      state.selectedRoute!,
      state.selectedBase!,
    );

    // Obter os ingredientes ativos da base selecionada
    final activeIngredientsFromBase =
        controller.getActiveIngredientsForSelectedBase();

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
                        'Princípio Ativo',
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
                        final isSelected =
                            state.selectedStrengthsByActiveIngredient[
                                    activeIngredient.dcbCode] ==
                                strengthKey;
                        final isAllowed = controller.isStrengthAllowed(
                            activeIngredient, strengthKey);

                        return InputChipMedgo(
                          selectedChip: isSelected,
                          title: _getStrengthDisplay(strengthKey),
                          isInactive: !isAllowed,
                          onSelected: (selected) {
                            if (!isAllowed) return;
                            if (selected) {
                              controller.selectStrength(
                                activeIngredient.dcbCode,
                                strengthKey,
                              );
                            } else {
                              controller.selectStrength(
                                activeIngredient.dcbCode,
                                null,
                              );
                            }
                          },
                          onInactivePressed: () {
                            controller.selectStrengthAndClearIncompatible(
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
}
