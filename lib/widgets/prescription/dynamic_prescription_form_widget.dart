import 'package:flutter/material.dart';
import 'package:medgo/data/models/medication_model.dart';
import 'package:medgo/data/models/dynamic_prescription_filter_model.dart';
import 'package:medgo/data/models/dynamic_prescription_filter_helper.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/buttons/primary_icon_button.dart';

/// Widget para formulário de prescrição dinâmica baseado nos novos filtros
/// Suporta keys dinâmicas e múltiplos princípios ativos
class DynamicPrescriptionFormWidget extends StatefulWidget {
  final MedicationModel medication;
  final Function(Map<String, dynamic>) onPrescriptionData;

  const DynamicPrescriptionFormWidget({
    super.key,
    required this.medication,
    required this.onPrescriptionData,
  });

  @override
  State<DynamicPrescriptionFormWidget> createState() =>
      _DynamicPrescriptionFormWidgetState();
}

class _DynamicPrescriptionFormWidgetState
    extends State<DynamicPrescriptionFormWidget> {
  late final DynamicPrescriptionFilterHelper helper;

  String? selectedCategory;
  String? selectedRoute;
  String? selectedBase;
  Map<String, StrengthModel> selectedStrengths = {};
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    helper = DynamicPrescriptionFilterHelper(widget.medication);
  }

  void _resetDependentSelections() {
    setState(() {
      selectedRoute = null;
      selectedBase = null;
      selectedStrengths.clear();
    });
  }

  void _resetBaseAndStrengths() {
    setState(() {
      selectedBase = null;
      selectedStrengths.clear();
    });
  }

  void _resetStrengths() {
    setState(() {
      selectedStrengths.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!helper.hasFilters) {
      return const Center(
        child: Text('Medicação sem filtros dinâmicos configurados'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título da medicação
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.theme.primaryColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          width: double.infinity,
          child: Row(
            children: [
              const Icon(Icons.medication, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.medication.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(12)),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Seção de Categorias (ex: oral, intravenosa)
              _buildSectionTitle('Categoria de administração:'),
              _buildCategorySelection(),

              if (selectedCategory != null) ...[
                const SizedBox(height: 16),
                _buildSectionTitle('Via de administração:'),
                _buildRouteSelection(),
              ],

              if (selectedRoute != null) ...[
                const SizedBox(height: 16),
                _buildSectionTitle('Base:'),
                _buildBaseSelection(),
              ],

              if (selectedBase != null) ...[
                const SizedBox(height: 16),
                _buildActiveIngredientsSection(),
              ],

              if (selectedStrengths.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildQuantitySection(),
                const SizedBox(height: 16),
                _buildSummarySection(),
                const SizedBox(height: 16),
                _buildActionButtons(),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xff57636C),
      ),
    );
  }

  Widget _buildCategorySelection() {
    final categories = helper.getCategoryOptions();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories
          .map((category) => _buildSelectionChip(
                label: category.toUpperCase(),
                isSelected: selectedCategory == category,
                onTap: () {
                  setState(() {
                    selectedCategory = category;
                  });
                  _resetDependentSelections();
                },
              ))
          .toList(),
    );
  }

  Widget _buildRouteSelection() {
    final routes = helper.getRouteOptions(selectedCategory!);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: routes
          .map((route) => _buildSelectionChip(
                label: route.toUpperCase(),
                isSelected: selectedRoute == route,
                onTap: () {
                  setState(() {
                    selectedRoute = route;
                  });
                  _resetBaseAndStrengths();
                },
              ))
          .toList(),
    );
  }

  Widget _buildBaseSelection() {
    final bases = helper.getBaseOptions(selectedCategory!, selectedRoute!);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: bases
          .map((base) => _buildSelectionChip(
                label: base.toUpperCase(),
                isSelected: selectedBase == base,
                onTap: () {
                  setState(() {
                    selectedBase = base;
                  });
                  _resetStrengths();
                },
              ))
          .toList(),
    );
  }

  Widget _buildActiveIngredientsSection() {
    final activeIngredientIds = helper.getActiveIngredientIds(
      selectedCategory!,
      selectedRoute!,
      selectedBase!,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Princípios ativos:'),
        const SizedBox(height: 8),
        ...activeIngredientIds
            .map((id) => _buildActiveIngredientStrengthSelection(id)),
      ],
    );
  }

  Widget _buildActiveIngredientStrengthSelection(String activeIngredientId) {
    final strengths = helper.getStrengthsForActiveIngredient(
      selectedCategory!,
      selectedRoute!,
      selectedBase!,
      activeIngredientId,
    );

    final ingredientName =
        helper.getActiveIngredientNameById(activeIngredientId) ??
            'Desconhecido';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Princípio ativo: $ingredientName',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff004155),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Força:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: strengths
                .map((strength) => _buildSelectionChip(
                      label: '${strength.value}${strength.unit}',
                      isSelected:
                          selectedStrengths[activeIngredientId] == strength,
                      onTap: () {
                        setState(() {
                          selectedStrengths[activeIngredientId] = strength;
                        });
                      },
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySection() {
    return Row(
      children: [
        _buildSectionTitle('Quantidade por administração:'),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed:
                    quantity > 1 ? () => setState(() => quantity--) : null,
                icon: const Icon(Icons.remove),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  quantity.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => setState(() => quantity++),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummarySection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff004155),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _buildDoseDescription(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  String _buildDoseDescription() {
    if (selectedStrengths.isEmpty) return 'Selecione as dosagens';

    final doses = selectedStrengths.entries.map((entry) {
      final ingredientName =
          helper.getActiveIngredientNameById(entry.key) ?? 'Desconhecido';
      final strength = entry.value;
      return '$ingredientName ${strength.value}${strength.unit}';
    }).join(' + ');

    return doses;
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: PrimaryIconButtonMedGo(
            onTap: _canSubmit() ? _handleSubmit : () {},
            leftIcon: const Icon(Icons.add, color: Colors.white),
            title: 'Adicionar à receita',
          ),
        ),
      ],
    );
  }

  bool _canSubmit() {
    return selectedCategory != null &&
        selectedRoute != null &&
        selectedBase != null &&
        selectedStrengths.isNotEmpty &&
        quantity > 0;
  }

  void _handleSubmit() {
    if (!_canSubmit()) return;

    final prescriptionData = helper.buildPrescriptionData(
      categoryKey: selectedCategory!,
      routeKey: selectedRoute!,
      baseKey: selectedBase!,
      selectedStrengths: selectedStrengths,
      quantity: quantity,
    );

    widget.onPrescriptionData(prescriptionData);
  }

  Widget _buildSelectionChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff004155) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xff004155) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xff004155),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
