// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:medgo/data/blocs/prescription/prescription_bloc.dart';
import 'package:medgo/data/blocs/prescription/prescription_event.dart';
import 'package:medgo/data/blocs/prescription/prescription_state.dart';
import 'package:medgo/data/models/medication_model.dart';
import 'package:medgo/strings/strings.dart';
import 'package:medgo/widgets/news_widgets/buttons/primary_icon_button.dart';
import 'package:medgo/widgets/news_widgets/buttons/tertiary_icon_button.dart';
import 'package:medgo/widgets/news_widgets/icon_button.dart';
import 'package:medgo/widgets/news_widgets/input_chip.dart';
import 'package:medgo/widgets/prescription/prescription_forms/types_prescription_medgo/simple_prescription_medgo.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../themes/app_theme.dart';

class FormPrescriptionMedgoModal extends StatefulWidget {
  final MedicationModel medication;
  final String prescriptionId;
  final PrescriptionBloc prescriptionBloc;
  const FormPrescriptionMedgoModal({
    super.key,
    required this.prescriptionId,
    required this.medication,
    required this.prescriptionBloc,
  });

  @override
  State<FormPrescriptionMedgoModal> createState() =>
      _FormPrescriptionModalState();
}

class _FormPrescriptionModalState extends State<FormPrescriptionMedgoModal> {
  String formPrescription = Strings.simple;

  // Dados da prescrição simples
  String? selectedAdministrationCategory;
  String? selectedAdministrationRoute;
  String? selectedBase;
  int quantity = 0;

  // Key para acessar o SimplePrescriptionMedgo
  final GlobalKey<State<SimplePrescriptionMedgo>> _simplePrescriptionKey =
      GlobalKey<State<SimplePrescriptionMedgo>>();

  @override
  void initState() {
    super.initState();
    _listenEvents();
  }

  void _listenEvents() {
    widget.prescriptionBloc.stream.listen((state) {
      if (state is NewDosageInstructionsPatched) {
        Navigator.of(context).pop(true);
      } else if (state is PrescriptionCreated) {
        Navigator.of(context).pop(true);
      } else if (state is PrescriptionError) {
        // Mostrar erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao criar prescrição: ${state.e}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  updateDosageForm({
    required dynamic data,
    required bool isVacination,
  }) {}

  favoriteDosageForm(bool? isFavorite) {}

  // Método para criar prescrição
  void _createPrescription() {
    try {
      if (formPrescription == Strings.simple) {
        // Obter dados do SimplePrescriptionMedgo
        final prescriptionData =
            (_simplePrescriptionKey.currentState as dynamic)
                ?.generatePrescriptionData();

        if (prescriptionData != null) {
          // Disparar evento para criar prescrição
          widget.prescriptionBloc.add(CreatePrescription(
            entitiesIds: prescriptionData['entitiesIds'] as List<String>,
            instructions:
                prescriptionData['instructions'] as Map<String, dynamic>,
            prescriptionId:
                widget.prescriptionId.isNotEmpty ? widget.prescriptionId : null,
          ));
        }
      } else {
        // Implementar para outras formas de prescrição (automática, manual)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Forma de prescrição não implementada ainda'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao gerar dados da prescrição: $e'),
          backgroundColor: Colors.red,
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
                      decoration: BoxDecoration(
                        color: AppTheme.info,
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
                          if (formPrescription == Strings.simple)
                            SimplePrescriptionMedgo(
                              key: _simplePrescriptionKey,
                              medication: widget.medication,
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        spacing: 6.0,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          PrimaryIconButtonMedGo(
                            onTap: () {},
                            leftIcon: Icon(
                              color: AppTheme.warning,
                              size: 20,
                              PhosphorIcons.caretLeft(
                                PhosphorIconsStyle.bold,
                              ),
                            ),
                          ),
                          PrimaryIconButtonMedGo(
                            onTap: () {},
                            leftIcon: Icon(
                              color: AppTheme.error,
                              size: 20,
                              PhosphorIcons.trash(
                                PhosphorIconsStyle.bold,
                              ),
                            ),
                          ),
                          TertiaryIconButtonMedGo(
                            leftIcon: Icon(
                              color: AppTheme.salmon,
                              size: 20,
                              PhosphorIcons.prescription(
                                PhosphorIconsStyle.bold,
                              ),
                            ),
                            onTap: _createPrescription,
                            title: 'Adicionar à receita',
                          ),
                        ],
                      ),
                    )
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
