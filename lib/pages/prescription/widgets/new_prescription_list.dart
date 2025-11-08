import 'package:flutter/material.dart';
import 'package:medgo/data/blocs/prescription/prescription_bloc.dart';
import 'package:medgo/data/models/system_prescription_model.dart';
import 'new_prescription_section.dart';

/// Nova versão da PrescriptionList que trabalha com SystemPrescriptionModel
/// ao invés de NewPrescriptionModel para compatibilidade com a nova API
/// Mantém exatamente a mesma UI da PrescriptionList original
class NewPrescriptionList extends StatelessWidget {
  final List<SystemPrescriptionModel> prescriptions;
  final Function(String, bool) onPrescriptionUpdated;
  final VoidCallback? onReload;
  final String title;
  final String? consultationId;
  final String? calculatorId;
  final PrescriptionBloc prescriptionBloc;

  const NewPrescriptionList({
    super.key,
    required this.prescriptions,
    required this.onPrescriptionUpdated,
    required this.title,
    required this.consultationId,
    required this.calculatorId,
    required this.prescriptionBloc,
    this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    if (prescriptions.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      itemCount: prescriptions.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final prescription = prescriptions[index];
        final controllerKey = '${title.toLowerCase()}-$index';

        return NewPrescriptionSection(
          key: ValueKey(
              '${prescription.conduct.id}-$index'), // Key para otimização
          prescription: prescription,
          controllerKey: controllerKey,
          onUpdatePrescription: (
              {required String prescriptionItemId, required bool isChosen}) {
            onPrescriptionUpdated(prescriptionItemId, isChosen);
          },
          onReload: onReload ?? () {},
          consultationId: consultationId,
          calculatorId: calculatorId,
          prescriptionBloc: prescriptionBloc,
        );
      },
    );
  }
}
