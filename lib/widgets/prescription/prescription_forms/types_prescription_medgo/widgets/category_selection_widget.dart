import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/input_chip.dart';
import 'package:medgo/widgets/prescription/prescription_forms/types_prescription_medgo/controllers/simple_prescription_controller.dart';
import 'package:medgo/widgets/prescription/prescription_forms/types_prescription_medgo/models/simple_prescription_state.dart';

/// Widget responsável pela seleção de Categoria, Via de Administração e Base
class CategorySelectionWidget extends StatelessWidget {
  final SimplePrescriptionController controller;
  final SimplePrescriptionState state;

  const CategorySelectionWidget({
    super.key,
    required this.controller,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (!controller.hasFilters) return const SizedBox.shrink();

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
      },
    );
  }

  Widget _buildLeftColumn() {
    // Posição 1: Base -> Via -> Categoria
    if (state.selectedCategory != null &&
        state.selectedRoute != null &&
        controller.shouldShowBases) {
      // Mostra Base
      return _buildSelectionColumn(
        title: 'Base',
        options: controller.getBaseOptions(
          state.selectedCategory!,
          state.selectedRoute!,
        ),
        selectedValue: state.selectedBase,
        displayMapper: controller.getBaseDisplay,
        onSelected: (value) => controller.selectBase(value),
        onSelectionChange: () => state.clearIncompatibleStrengths([]),
      );
    } else if (state.selectedCategory != null && controller.shouldShowRoutes) {
      // Mostra Via de Administração
      return _buildSelectionColumn(
        title: 'Via de Administração',
        options: controller.getRouteOptions(state.selectedCategory!),
        selectedValue: state.selectedRoute,
        displayMapper: controller.getRouteDisplay,
        onSelected: (value) => controller.selectRoute(value),
      );
    } else {
      // Mostra Categoria (estado inicial)
      return _buildSelectionColumn(
        title: 'Categoria',
        options: controller.getCategoryOptions(),
        selectedValue: state.selectedCategory,
        displayMapper: controller.getCategoryDisplay,
        onSelected: (value) => controller.selectCategory(value),
      );
    }
  }

  Widget _buildMiddleColumn() {
    // Posição 2: Via -> Categoria -> Nenhum
    if (state.selectedCategory != null &&
        state.selectedRoute != null &&
        controller.shouldShowBases) {
      // Mostra Via de Administração
      return _buildSelectionColumn(
        title: 'Via de Administração',
        options: controller.getRouteOptions(state.selectedCategory!),
        selectedValue: state.selectedRoute,
        displayMapper: controller.getRouteDisplay,
        onSelected: (value) => controller.selectRoute(value),
      );
    } else if (state.selectedCategory != null && controller.shouldShowRoutes) {
      // Mostra Categoria
      return _buildSelectionColumn(
        title: 'Categoria',
        options: controller.getCategoryOptions(),
        selectedValue: state.selectedCategory,
        displayMapper: controller.getCategoryDisplay,
        onSelected: (value) => controller.selectCategory(value),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildRightColumn() {
    // Posição 3: Categoria -> Nenhum -> Nenhum
    if (state.selectedCategory != null &&
        state.selectedRoute != null &&
        controller.shouldShowBases) {
      // Mostra Categoria
      return _buildSelectionColumn(
        title: 'Categoria',
        options: controller.getCategoryOptions(),
        selectedValue: state.selectedCategory,
        displayMapper: controller.getCategoryDisplay,
        onSelected: (value) => controller.selectCategory(value),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildSelectionColumn({
    required String title,
    required List<String> options,
    required String? selectedValue,
    required String Function(String) displayMapper,
    required void Function(String?) onSelected,
    VoidCallback? onSelectionChange,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.secondaryText,
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: options
              .map((optionKey) => InputChipMedgo(
                    selectedChip: selectedValue == optionKey,
                    title: displayMapper(optionKey),
                    onSelected: (selected) {
                      onSelected(selected ? optionKey : null);
                      onSelectionChange?.call();
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }
}
