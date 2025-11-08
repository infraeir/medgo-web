import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medgo/data/models/prescription_item_model.dart';
import 'package:medgo/data/models/medical_enums.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NewSystemRemedyCard extends StatefulWidget {
  final PrescriptionItemModel medication;
  final Function(PrescriptionItemModel mdc) click;
  const NewSystemRemedyCard({
    super.key,
    required this.medication,
    required this.click,
  });

  @override
  State<NewSystemRemedyCard> createState() => _NewSystemRemedyCardState();
}

class _NewSystemRemedyCardState extends State<NewSystemRemedyCard> {
  bool isHovered = false;
  bool isPressed = false;
  bool isSelected = false;

  late Color border;
  late Color background;
  late Color fontPrimary;
  late Color fontSecondary;
  late Color divider;

  @override
  void initState() {
    super.initState();
    isSelected = widget.medication.isChosen;
  }

  @override
  void didUpdateWidget(NewSystemRemedyCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.medication.isChosen != widget.medication.isChosen) {
      setState(() {
        isSelected = widget.medication.isChosen;
      });
    }
  }

  void _updateColors() {
    if (isPressed) {
      border = const Color(0xffE67F75);
      background = const Color(0xff326789);
      fontPrimary = const Color(0xff78A6C8);
      fontSecondary = const Color(0xffFFFFFF);
      divider = const Color(0xff004155).withOpacity(.3);
    } else if (isSelected) {
      border = const Color(0xff78A6C8);
      background = const Color(0xff004155);
      fontPrimary = const Color(0xff78A6C8);
      fontSecondary = const Color(0xffFFFFFF);
      divider = const Color(0xff78A6C8);
    } else if (isHovered) {
      border = const Color(0xffE67F75);
      background = const Color(0xff78A6C8);
      fontPrimary = const Color(0xff004155);
      fontSecondary = const Color(0xff14181B);
      divider = const Color(0xff004155).withOpacity(.3);
    } else {
      border = AppTheme.theme.primaryColor;
      background = const Color(0xffF1F4F8);
      fontPrimary = AppTheme.theme.primaryColor;
      fontSecondary = Colors.black;
      divider = const Color(0xff004155).withOpacity(.3);
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateColors();

    return IntrinsicWidth(
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 250,
          maxWidth: 450,
        ),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: background,
          border: Border.all(
            color: border,
            width: isPressed ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: InkWell(
          onTap: () {
            setState(() {
              isSelected = !isSelected;
            });
            widget.click(widget.medication);
          },
          onHover: (value) {
            setState(() {
              isHovered = value;
            });
          },
          onTapDown: (details) {
            setState(() {
              isPressed = true;
            });
          },
          onTapUp: (details) {
            setState(() {
              isPressed = false;
            });
          },
          onTapCancel: () {
            setState(() {
              isPressed = false;
            });
          },
          onFocusChange: (value) {
            setState(() {
              isHovered = value;
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.medication.type == 'medication')
                _buildMedicationContent()
              else if (widget.medication.type == 'vaccination')
                _buildVaccinationContent(),
              const SizedBox(height: 4),
              Container(
                height: 5,
                width: double.infinity,
                color: divider,
              ),
              const SizedBox(height: 4),
              _buildAvailabilityInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicationContent() {
    final entity = widget.medication.entities.first;
    final presentation = entity.presentations.first;
    final concentration = presentation.package.primary.concentration;

    // Nome: tradeName se houver, senão name
    final medicationName =
        entity.tradeName.isNotEmpty ? entity.tradeName : entity.name;

    // Valor e unidade da concentração
    final concentrationValue = concentration.value;
    final formattedValue = concentrationValue == concentrationValue.toInt()
        ? concentrationValue.toInt().toString()
        : concentrationValue.toString();
    final translatedUnit =
        MedicalEnums.translateConcentrationUnit(concentration.unit);
    final concentrationText = ' $formattedValue $translatedUnit';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset('assets/icons/${entity.type}.svg'),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                medicationName + concentrationText,
                style: AppTheme.h4(
                  color: fontPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Apresentação: ",
              style: AppTheme.h5(
                color: fontPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                MedicalEnums.translateDispensationUnitNew(
                  presentation.package.primary.dispensationUnit,
                ),
                style: AppTheme.h5(
                  color: fontSecondary,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Princípio ativo: ",
              style: AppTheme.h5(
                color: fontPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                widget.medication.entities.first.activeIngredients.first.name,
                style: AppTheme.h5(
                  color: fontSecondary,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Viscosidade: ",
              style: AppTheme.h5(
                color: fontPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                widget.medication.entities.first.presentations.first
                        .packageUnitViscosityPerUnit
                        .toString() +
                    ' gotas/mL',
                style: AppTheme.h5(
                  color: fontSecondary,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVaccinationContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.medication.entities.first.tradeName,
          style: AppTheme.h4(
            color: fontPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Instruções: ",
              style: AppTheme.h5(
                color: fontPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                widget.medication.instructions.prescription,
                style: AppTheme.h5(
                  color: fontSecondary,
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAvailabilityInfo() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.medication.entities.first.availableInSUS
                  ? "Disponível no SUS"
                  : "Indisponível no SUS",
              style: AppTheme.h5(
                color: fontPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 5),
              child: widget.medication.entities.first.availableInSUS
                  ? Icon(
                      PhosphorIcons.checkCircle(),
                      color: AppTheme.success,
                      size: 18,
                    )
                  : Icon(
                      PhosphorIcons.xCircle(),
                      color: AppTheme.error,
                      size: 18,
                    ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.medication.entities.first.availableInPopularPharmacy
                  ? "Preço do frasco: R\$ ${widget.medication.entities.first.presentations.first.packagePriceValue.toString()}"
                  : "Não Disponível Comercialmente",
              style: AppTheme.h5(
                color: fontPrimary,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Container(
              margin: const EdgeInsets.only(left: 5),
              child: widget.medication.entities.first.availableInPopularPharmacy
                  ? Icon(
                      PhosphorIcons.coins(),
                      color: AppTheme.warning,
                      size: 18,
                    )
                  : Icon(
                      PhosphorIcons.xCircle(),
                      color: AppTheme.error,
                      size: 18,
                    ),
            ),
          ],
        ),
      ],
    );
  }
}
