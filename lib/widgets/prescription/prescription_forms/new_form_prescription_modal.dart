import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:medgo/data/blocs/prescription/prescription_bloc.dart';
import 'package:medgo/data/blocs/prescription/prescription_event.dart';
import 'package:medgo/data/blocs/prescription/prescription_state.dart';
import 'package:medgo/data/models/new_prescription_model.dart';
import 'package:medgo/strings/strings.dart';
import 'package:medgo/widgets/news_widgets/icon_button.dart';
import 'package:medgo/widgets/news_widgets/input_chip.dart';
import 'package:medgo/widgets/prescription/prescription_forms/new_automatic.dart';
import 'package:medgo/widgets/prescription/prescription_forms/new_manual.dart';
import 'package:medgo/widgets/prescription/prescription_forms/new_simple.dart';

import '../../../themes/app_theme.dart';

class NewFormPrescriptionModal extends StatefulWidget {
  final ItemModel medication;
  final NewPrescriptionModel prescription;
  final String? consultationId;
  final String? calculatorId;
  final String prescriptionId;
  final PrescriptionBloc prescriptionBloc;
  const NewFormPrescriptionModal({
    super.key,
    required this.prescriptionId,
    required this.consultationId,
    required this.calculatorId,
    required this.medication,
    required this.prescription,
    required this.prescriptionBloc,
  });

  @override
  State<NewFormPrescriptionModal> createState() =>
      _NewFormPrescriptionModalState();
}

class _NewFormPrescriptionModalState extends State<NewFormPrescriptionModal> {
  String formPrescription = 'automatic';

  @override
  void initState() {
    super.initState();
    _listenEvents();
    setState(() {
      formPrescription = widget.medication.instructions.type;
    });
  }

  void _listenEvents() {
    widget.prescriptionBloc.stream.listen((state) {
      if (state is NewDosageInstructionsPatched) {
        Navigator.of(context).pop(true);
      }
    });
  }

  updateDosageForm({
    required dynamic data,
    required bool isVacination,
  }) {
    widget.prescriptionBloc.add(
      NewPatchDosageInstructions(
        data: data,
        prescriptionItemId: widget.medication.id,
        consultationId: widget.consultationId,
        calculatorId: widget.calculatorId,
        isVacination: isVacination,
      ),
    );
  }

  favoriteDosageForm(bool? isFavorite) {
    if (isFavorite != null) {
      widget.prescriptionBloc.add(
        NewPatchPrescriptionLike(
          prescriptionItemId: widget.medication.id,
          consultationId: widget.consultationId,
          calculatorId: widget.calculatorId,
          isFavorite: isFavorite,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Center(
        child: Dialog(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isLargeScreen
                  ? MediaQuery.of(context).size.width * 0.65
                  : MediaQuery.of(context).size.width * 0.95,
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.info,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                      spreadRadius: 5,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // Sombra mais suave
                      blurRadius: 30,
                      offset: const Offset(0, 5),
                      spreadRadius: 10,
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: isLargeScreen ? 32.0 : 16.0,
                  vertical: 16.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Forma de prescrição:',
                            style: AppTheme.h5(
                              color: const Color(0xff57636C),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        CustomIconButtonMedGo(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: Colors.red),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        InputChipMedgo(
                          selectedChip: formPrescription == Strings.automatic,
                          title: Strings.automatico,
                          onSelected: (selected) {
                            setState(() {
                              formPrescription = Strings.automatic;
                            });
                          },
                        ),
                        if (widget.medication.type == 'medication')
                          InputChipMedgo(
                            selectedChip: formPrescription == Strings.simple,
                            title: Strings.simples,
                            onSelected: (selected) {
                              setState(() {
                                formPrescription = Strings.simple;
                              });
                            },
                          ),
                        InputChipMedgo(
                          selectedChip: formPrescription == Strings.manual,
                          title: Strings.manualText,
                          onSelected: (selected) {
                            setState(() {
                              formPrescription = Strings.manual;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        border: Border.all(
                          width: 1.0,
                          color: const Color(0xff004155),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (formPrescription == Strings.automatic)
                            NewAutomaticForm(
                              medication: widget.medication,
                              favoritarReceita: favoriteDosageForm,
                            ),
                          if (widget.medication.type == 'medication' &&
                              formPrescription == Strings.simple)
                            NewSimpleForm(
                              favoritarReceita: favoriteDosageForm,
                              medication: widget.medication,
                              adicionarReceita: (data) {
                                updateDosageForm(
                                  data: data,
                                  isVacination:
                                      widget.medication.type == 'vaccine_dose',
                                );
                              },
                            ),
                          if (formPrescription == Strings.manual)
                            NewManualForm(
                              medication: widget.medication,
                              favoritarReceita: favoriteDosageForm,
                              adicionarReceita: (data) {
                                updateDosageForm(
                                  data: data,
                                  isVacination:
                                      widget.medication.type == 'vaccine_dose',
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
