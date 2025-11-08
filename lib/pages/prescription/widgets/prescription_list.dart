import 'package:flutter/material.dart';
import 'package:medgo/data/blocs/prescription/prescription_bloc.dart';
import 'package:medgo/data/models/new_prescription_model.dart';
import 'prescription_section.dart';

class PrescriptionList extends StatelessWidget {
  final List<NewPrescriptionModel> prescriptions;
  final int listIndex;
  final Function({required String prescriptionItemId, required bool isChosen})
      onUpdatePrescription;
  final VoidCallback onReload;
  final String? consultationId;
  final String? calculatorId;
  final PrescriptionBloc prescriptionBloc;

  const PrescriptionList({
    Key? key,
    required this.prescriptions,
    required this.listIndex,
    required this.onUpdatePrescription,
    required this.onReload,
    required this.consultationId,
    required this.calculatorId,
    required this.prescriptionBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: prescriptions.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final prescription = prescriptions[index];
        final controllerKey = '$listIndex-$index';

        return PrescriptionSection(
          prescription: prescription,
          controllerKey: controllerKey,
          onUpdatePrescription: onUpdatePrescription,
          onReload: onReload,
          consultationId: consultationId,
          calculatorId: calculatorId,
          prescriptionBloc: prescriptionBloc,
        );
      },
    );
  }
}
