// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medgo/data/blocs/prescription/prescription_bloc.dart';
import 'package:medgo/data/models/system_prescription_model.dart';
import 'package:medgo/data/models/prescription_item_model.dart';
import 'package:medgo/data/models/medical_enums.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/buttons/primary_icon_button.dart';
import 'package:medgo/widgets/news_widgets/icon_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NewRecommendedPrescription extends StatelessWidget {
  final SystemPrescriptionModel prescription;
  final PrescriptionBloc prescriptionBloc;
  final String? consultationId;
  final String? calculatorId;
  final VoidCallback reload;
  final Function({required String prescriptionItemId, required bool isChosen})?
      onUpdatePrescription;

  const NewRecommendedPrescription({
    super.key,
    required this.prescriptionBloc,
    required this.prescription,
    this.consultationId,
    this.calculatorId,
    required this.reload,
    this.onUpdatePrescription,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          itemCount: prescription.items.where((item) => item.isChosen).length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var chosenItems =
                prescription.items.where((item) => item.isChosen).toList();
            var item = chosenItems[index];

            return _RecommendedItemCard(
              index: index,
              item: item,
              onUpdatePrescription: onUpdatePrescription,
            );
          },
        ),
      ],
    );
  }
}

class _RecommendedItemCard extends StatelessWidget {
  final int index;
  final PrescriptionItemModel item;
  final Function({required String prescriptionItemId, required bool isChosen})?
      onUpdatePrescription;

  const _RecommendedItemCard({
    required this.index,
    required this.item,
    this.onUpdatePrescription,
  });

  String _translateType(String type) {
    switch (type) {
      case 'automatic':
        return 'Prescrição automática';
      case 'manual':
        return 'Prescrição manual';
      case 'simple':
        return 'Prescrição simples';
      default:
        return 'Prescrição';
    }
  }

  @override
  Widget build(BuildContext context) {
    final entity = item.entities.first;
    final presentation = entity.presentations.first;
    final primary = presentation.package.primary;
    final secondary = presentation.package.secondary;

    // Nome comercial ou nome
    final medicationName =
        entity.tradeName.isNotEmpty ? entity.tradeName : entity.name;

    // Concentração formatada
    final cVal = primary.concentration.value;
    final cValStr =
        cVal == cVal.toInt() ? cVal.toInt().toString() : cVal.toString();
    final cUnit =
        MedicalEnums.translateConcentrationUnit(primary.concentration.unit);
    final concentrationText = ' $cValStr $cUnit';

    // Forma/apresentação primária
    final primaryForm =
        MedicalEnums.translateDispensationUnitNew(primary.dispensationUnit);

    // Princípio ativo principal (primeiro)
    final activeIngredient = entity.activeIngredients.isNotEmpty
        ? entity.activeIngredients.first.name
        : '';

    // Quantidade do pacote (ex.: 03 caixas (28 comprimidos / caixa))
    final secQty = secondary.quantity;
    final secUnit =
        MedicalEnums.translateDispensationUnitNew(secondary.dispensationUnit);
    final priQty = primary.quantity;
    final priUnit =
        MedicalEnums.translateDispensationUnitNew(primary.dispensationUnit);
    final qtyRight =
        '${secQty.toString().padLeft(2, '0')} $secUnit (${priQty.toString()} $priUnit / ${secUnit.split(' ').first})';

    final header = _translateType(item.instructions.type);

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: const Color(0xff004155),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.history_edu,
                color: AppTheme.lightTheme,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                header,
                style: AppTheme.h5(
                  color: AppTheme.lightTheme,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 0,
                child: Row(
                  children: [
                    Text(
                      '${index + 1}. $medicationName$concentrationText - $primaryForm ($activeIngredient)',
                      style: AppTheme.h5(
                        color: AppTheme.lightTheme,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    CustomIconButtonMedGo(
                      size: 32,
                      icon: Icon(
                        PhosphorIcons.copySimple(),
                        color: AppTheme.lightTheme.withOpacity(.9),
                        size: 16,
                      ),
                      onPressed: () => Clipboard.setData(
                        ClipboardData(
                          text:
                              '$medicationName$concentrationText - $primaryForm ($activeIngredient)',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: Divider(
                  color: AppTheme.lightTheme,
                  height: 3,
                ),
              ),
              Row(
                children: [
                  const SizedBox(width: 8),
                  Text(
                    qtyRight,
                    style: AppTheme.h5(
                      color: AppTheme.lightTheme,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  CustomIconButtonMedGo(
                    size: 32,
                    icon: Icon(
                      PhosphorIcons.copySimple(),
                      color: AppTheme.lightTheme.withOpacity(.9),
                      size: 16,
                    ),
                    onPressed: () => Clipboard.setData(
                      ClipboardData(
                        text: qtyRight,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      item.instructions.prescription,
                      style: AppTheme.h5(
                        color: AppTheme.lightTheme,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    CustomIconButtonMedGo(
                      size: 30,
                      icon: Icon(
                        PhosphorIcons.copySimple(),
                        color: AppTheme.lightTheme.withOpacity(.9),
                        size: 16,
                      ),
                      onPressed: () => Clipboard.setData(
                        ClipboardData(text: item.instructions.prescription),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    PrimaryIconButtonMedGo(
                      size: 16,
                      onTap: () {
                        if (onUpdatePrescription != null) {
                          onUpdatePrescription!(
                            prescriptionItemId: item.id,
                            isChosen: false,
                          );
                        }
                      },
                      leftIcon: Icon(
                        PhosphorIcons.trash(
                          PhosphorIconsStyle.bold,
                        ),
                        color: AppTheme.error,
                        size: 20,
                      ),
                    ),
                    PrimaryIconButtonMedGo(
                      size: 16,
                      onTap: () {},
                      leftIcon: Icon(
                        PhosphorIcons.pencilSimpleLine(
                          PhosphorIconsStyle.bold,
                        ),
                        color: AppTheme.primary,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
