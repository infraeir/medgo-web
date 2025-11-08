import 'package:flutter/material.dart';
import 'package:medgo/data/models/medication_model.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/prescription/prescription_forms/types_prescription_medgo/controllers/simple_prescription_controller.dart';
import 'package:medgo/widgets/prescription/prescription_forms/types_prescription_medgo/models/simple_prescription_state.dart';
import 'package:medgo/widgets/prescription/prescription_forms/types_prescription_medgo/utils/prescription_formatters.dart';

/// Widget do cartão flutuante que mostra o resumo da prescrição
class PrescriptionSummaryCard extends StatelessWidget {
  final MedicationModel medication;
  final SimplePrescriptionController controller;
  final SimplePrescriptionState state;

  const PrescriptionSummaryCard({
    super.key,
    required this.medication,
    required this.controller,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, child) {
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
                    Expanded(
                      child: _buildMedicationDoseInfo(),
                    ),
                    const SizedBox(width: 8),
                    _buildQuantityToDispense(),
                  ],
                ),
                if (controller.canShowQuantityAdm &&
                    _getAprazamentoInfo().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 8),
                  // Segunda linha: Forma de aprazamento e duração
                  _buildAprazamentoAndDuration(),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMedicationDoseInfo() {
    if (!controller.canShowQuantityAdm) {
      return Text(
        'Complete a configuração',
        style: TextStyle(
          fontSize: 12,
          color: Colors.white.withOpacity(0.8),
        ),
      );
    }

    final medicationName = medication.displayName;
    final baseName = state.selectedBase != null
        ? controller.getBaseDisplay(state.selectedBase!)
        : '';
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

  Widget _buildQuantityToDispense() {
    if (!controller.canShowQuantityAdm) {
      return const SizedBox.shrink();
    }

    // Por enquanto, não temos campo para quantidade a ser dispensada
    // Pode ser adicionado futuramente
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        'Qtd: ---',
        style: TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAprazamentoAndDuration() {
    final aprazamentoInfo = _getAprazamentoInfo();
    final durationInfo = _getDurationInfo();

    return Text(
      '$aprazamentoInfo${durationInfo.isNotEmpty ? ' • $durationInfo' : ''}',
      style: TextStyle(
        fontSize: 11,
        color: Colors.white.withOpacity(0.9),
        fontWeight: FontWeight.w400,
      ),
    );
  }

  String _getDoseInfo() {
    if (!controller.canShowQuantityAdm) return '';

    final activeIngredients = controller.getActiveIngredientsForSelectedBase();
    return PrescriptionFormatters.getDoseInfo(state, activeIngredients);
  }

  String _getAprazamentoInfo() {
    return PrescriptionFormatters.getAprazamentoInfo(state);
  }

  String _getDurationInfo() {
    return PrescriptionFormatters.getDurationInfo(state);
  }
}
