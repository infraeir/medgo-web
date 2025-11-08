// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:medgo/data/blocs/prescription/prescription_bloc.dart';
import 'package:medgo/data/models/new_prescription_model.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/buttons/primary_icon_button.dart';
import 'package:medgo/widgets/news_widgets/icon_button.dart';
import 'package:medgo/widgets/prescription/prescription_forms/new_form_prescription_modal.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class RecommendedPrescription extends StatelessWidget {
  final NewPrescriptionModel prescription;
  final PrescriptionBloc prescriptionBloc;
  final String? consultationId;
  final String? calculatorId;
  final String prescriptionId;
  final VoidCallback reload;
  const RecommendedPrescription({
    super.key,
    required this.prescriptionBloc,
    required this.prescription,
    this.consultationId,
    this.calculatorId,
    required this.prescriptionId,
    required this.reload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xff004155),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.history_edu,
                    color: AppTheme.lightTheme,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    'Prescrição recomendada: ',
                    style: AppTheme.h4(
                      color: AppTheme.lightTheme,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          ListView.builder(
            itemCount: prescription.items.where((item) => item.isChosen).length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var chosenItems =
                  prescription.items.where((item) => item.isChosen).toList();

              ItemModel medication = chosenItems[index];

              return medication.type == 'medication'
                  ? _getMedicationDescription(
                      context: context,
                      medication: medication,
                      index: index,
                      editarPrescricao: () async {
                        var result = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return NewFormPrescriptionModal(
                              consultationId: consultationId,
                              calculatorId: calculatorId,
                              prescriptionId: prescriptionId,
                              medication: medication,
                              prescriptionBloc: prescriptionBloc,
                              prescription: prescription,
                            );
                          },
                        );

                        if (result == true) {
                          reload();
                        }
                      },
                    )
                  : _getVacinationDescription(
                      context: context,
                      medication: medication,
                      index: index,
                      editarPrescricao: () async {
                        var result = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return NewFormPrescriptionModal(
                              consultationId: consultationId,
                              prescriptionId: prescriptionId,
                              calculatorId: calculatorId,
                              medication: medication,
                              prescriptionBloc: prescriptionBloc,
                              prescription: prescription,
                            );
                          },
                        );

                        if (result) {
                          reload();
                        }
                      },
                    );
            },
          ),
        ],
      ),
    );
  }

  _getMedicationDescription({
    required BuildContext context,
    required ItemModel medication,
    required int index,
    required Function() editarPrescricao,
  }) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(
              width: 16,
            ),
            Text(
              '${index + 1}. ',
              style: AppTheme.h6(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              '${medication.entity.tradeName} (${medication.entity.presentation}, ${medication.entity.activeIngredient} - ${medication.entity.activeIngredientConcentration} mg/ml)',
              style: AppTheme.h6(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            CustomIconButtonMedGo(
              onPressed: () {
                Clipboard.setData(ClipboardData(
                  text:
                      '${medication.entity.tradeName} (${medication.entity.presentation}, ${medication.entity.activeIngredient} - ${medication.entity.activeIngredientConcentration} mg/ml)',
                ));
                showToast(
                  'Posologia copiada para a área de transferência!',
                  context: context,
                  axis: Axis.horizontal,
                  alignment: Alignment.center,
                  position: StyledToastPosition.top,
                  animation: StyledToastAnimation.slideFromTopFade,
                  reverseAnimation: StyledToastAnimation.fade,
                  backgroundColor: AppTheme.secondary,
                  textStyle: const TextStyle(color: Colors.white),
                  duration: const Duration(seconds: 2),
                  borderRadius: BorderRadius.circular(8),
                );
              },
              size: 32.0,
              icon: Icon(
                PhosphorIcons.copy(),
                size: 16.0,
                color: Colors.white,
              ),
            ),
            const Expanded(
                child: Divider(
              color: Colors.white,
              height: 1,
            )),
            const SizedBox(
              width: 16,
            ),
            Text(
              medication.instructions.duration,
              style: AppTheme.h6(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            CustomIconButtonMedGo(
              onPressed: () {
                Clipboard.setData(ClipboardData(
                  text: medication.instructions.duration,
                ));
                showToast(
                  'Posologia copiada para a área de transferência!',
                  context: context,
                  axis: Axis.horizontal,
                  alignment: Alignment.center,
                  position: StyledToastPosition.top,
                  animation: StyledToastAnimation.slideFromTopFade,
                  reverseAnimation: StyledToastAnimation.fade,
                  backgroundColor: AppTheme.secondary,
                  textStyle: const TextStyle(color: Colors.white),
                  duration: const Duration(seconds: 2),
                  borderRadius: BorderRadius.circular(8),
                );
              },
              size: 32.0,
              icon: Icon(
                PhosphorIcons.copy(),
                size: 16.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Row(
                children: [
                  Text(
                    medication.instructions.prescription,
                    style: AppTheme.h6(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  CustomIconButtonMedGo(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                        text: medication.instructions.prescription,
                      ));
                      showToast(
                        'Posologia copiada para a área de transferência!',
                        context: context,
                        axis: Axis.horizontal,
                        alignment: Alignment.center,
                        position: StyledToastPosition.top,
                        animation: StyledToastAnimation.slideFromTopFade,
                        reverseAnimation: StyledToastAnimation.fade,
                        backgroundColor: AppTheme.secondary,
                        textStyle: const TextStyle(color: Colors.white),
                        duration: const Duration(seconds: 2),
                        borderRadius: BorderRadius.circular(8),
                      );
                    },
                    size: 32.0,
                    icon: Icon(
                      PhosphorIcons.copy(),
                      size: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            PrimaryIconButtonMedGo(
              onTap: editarPrescricao,
              size: 12.0,
              title: 'Editar prescrição',
              rightIcon: Icon(
                size: 14.0,
                PhosphorIcons.pencilSimpleLine(
                  PhosphorIconsStyle.bold,
                ),
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(0, 3),
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  _getVacinationDescription({
    required BuildContext context,
    required ItemModel medication,
    required int index,
    required Function() editarPrescricao,
  }) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(
              width: 16,
            ),
            Text(
              '${index + 1}. ',
              style: AppTheme.h6(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              medication.entity.vaccineName,
              style: AppTheme.h6(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            CustomIconButtonMedGo(
              onPressed: () {
                Clipboard.setData(ClipboardData(
                  text: medication.entity.vaccineName,
                ));
                showToast(
                  'Instrução de vacinação copiada para a área de transferência!',
                  context: context,
                  axis: Axis.horizontal,
                  alignment: Alignment.center,
                  position: StyledToastPosition.top,
                  animation: StyledToastAnimation.slideFromTopFade,
                  reverseAnimation: StyledToastAnimation.fade,
                  backgroundColor: AppTheme.secondary,
                  textStyle: const TextStyle(color: Colors.white),
                  duration: const Duration(seconds: 2),
                  borderRadius: BorderRadius.circular(8),
                );
              },
              size: 32.0,
              icon: Icon(
                PhosphorIcons.copy(),
                size: 16.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            const Expanded(
                child: Divider(
              color: Colors.white,
              height: 1,
            )),
            const SizedBox(
              width: 16,
            ),
            Text(
              '${medication.entity.doseNumber} dose',
              style: AppTheme.h6(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            CustomIconButtonMedGo(
              onPressed: () {
                Clipboard.setData(ClipboardData(
                  text: '${medication.entity.doseNumber} dose',
                ));
                showToast(
                  'Instrução de vacinação copiada para a área de transferência!',
                  context: context,
                  axis: Axis.horizontal,
                  alignment: Alignment.center,
                  position: StyledToastPosition.top,
                  animation: StyledToastAnimation.slideFromTopFade,
                  reverseAnimation: StyledToastAnimation.fade,
                  backgroundColor: AppTheme.secondary,
                  textStyle: const TextStyle(color: Colors.white),
                  duration: const Duration(seconds: 2),
                  borderRadius: BorderRadius.circular(8),
                );
              },
              size: 32.0,
              icon: Icon(
                PhosphorIcons.copy(),
                size: 16.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: Row(
                children: [
                  medication.instructions.type == 'automatic'
                      ? Text(
                          'Aplicar ${medication.entity.doseNumber} dose',
                          style: AppTheme.h6(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : Text(
                          medication.instructions.manualMedicalAdvice[0],
                          style: AppTheme.h6(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  CustomIconButtonMedGo(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                        text: medication.instructions.type == 'automatic'
                            ? 'Aplicar ${medication.entity.doseNumber} dose'
                            : medication.instructions.manualMedicalAdvice[0],
                      ));
                      showToast(
                        'Instrução de vacinação copiada para a área de transferência!',
                        context: context,
                        axis: Axis.horizontal,
                        alignment: Alignment.center,
                        position: StyledToastPosition.top,
                        animation: StyledToastAnimation.slideFromTopFade,
                        reverseAnimation: StyledToastAnimation.fade,
                        backgroundColor: AppTheme.secondary,
                        textStyle: const TextStyle(color: Colors.white),
                        duration: const Duration(seconds: 2),
                        borderRadius: BorderRadius.circular(8),
                      );
                    },
                    size: 32.0,
                    icon: Icon(
                      PhosphorIcons.copy(),
                      size: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            PrimaryIconButtonMedGo(
              onTap: editarPrescricao,
              size: 12.0,
              title: 'Editar prescrição',
              rightIcon: Icon(
                size: 14.0,
                PhosphorIcons.pencilSimpleLine(
                  PhosphorIconsStyle.bold,
                ),
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(0, 3),
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
