import 'package:flutter/material.dart';
import 'package:medgo/data/models/medication_model.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/prescription/prescription_forms/types_prescription_medgo/controllers/simple_prescription_controller.dart';
import 'package:medgo/widgets/prescription/prescription_forms/types_prescription_medgo/models/simple_prescription_state.dart';
import 'package:medgo/widgets/prescription/prescription_forms/types_prescription_medgo/widgets/category_selection_widget.dart';
import 'package:medgo/widgets/prescription/prescription_forms/types_prescription_medgo/widgets/medication_header_widget.dart';
import 'package:medgo/widgets/prescription/prescription_forms/types_prescription_medgo/widgets/prescription_summary_card.dart';
import 'package:medgo/widgets/prescription/prescription_forms/types_prescription_medgo/widgets/quantity_widget.dart';
import 'package:medgo/widgets/prescription/prescription_forms/types_prescription_medgo/widgets/scheduling_duration_widget.dart';
import 'package:medgo/widgets/prescription/prescription_forms/types_prescription_medgo/widgets/strength_selection_widget.dart';
import 'package:medgo/widgets/scrollbar/custom_scroll_bar.dart';

/// Widget refatorado da prescrição simples usando componentes modulares
class SimplePrescriptionMedgoRefactored extends StatefulWidget {
  final MedicationModel medication;

  const SimplePrescriptionMedgoRefactored({
    super.key,
    required this.medication,
  });

  @override
  State<SimplePrescriptionMedgoRefactored> createState() =>
      _SimplePrescriptionMedgoRefactoredState();
}

class _SimplePrescriptionMedgoRefactoredState
    extends State<SimplePrescriptionMedgoRefactored> {
  late final ScrollController _scrollController;
  late final SimplePrescriptionState _state;
  late final SimplePrescriptionController _controller;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _state = SimplePrescriptionState();
    _controller = SimplePrescriptionController(
      medication: widget.medication,
      state: _state,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.hasFilters) {
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
          PrescriptionSummaryCard(
            medication: widget.medication,
            controller: _controller,
            state: _state,
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicPrescriptionForm() {
    return CustomScrollbar(
      controller: _scrollController,
      trackMargin: const EdgeInsets.only(bottom: 80),
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
                MedicationHeaderWidget(medication: widget.medication),
                const SizedBox(height: 6),
                CategorySelectionWidget(
                  controller: _controller,
                  state: _state,
                ),
                const SizedBox(height: 6),
                StrengthSelectionWidget(
                  controller: _controller,
                  state: _state,
                ),
                const SizedBox(height: 6),
                QuantityWidget(
                  controller: _controller,
                  state: _state,
                ),
                const SizedBox(height: 6),
                SchedulingAndDurationWidget(
                  controller: _controller,
                  state: _state,
                ),
                const SizedBox(height: 120), // Espaço para o card flutuante
              ],
            ),
          ),
        ),
      ),
    );
  }
}
