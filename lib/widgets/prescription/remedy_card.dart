import 'package:flutter/material.dart';
import 'package:medgo/data/models/new_prescription_model.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NewRemedyCard extends StatefulWidget {
  final ItemModel medication;
  final Function(ItemModel mdc) click;
  const NewRemedyCard({
    super.key,
    required this.medication,
    required this.click,
  });

  @override
  State<NewRemedyCard> createState() => _NewRemedyCardState();
}

class _NewRemedyCardState extends State<NewRemedyCard> {
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
  void didUpdateWidget(NewRemedyCard oldWidget) {
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
      fontSecondary = AppTheme.theme.primaryColor;
      divider = const Color(0xff004155).withOpacity(.3);
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateColors();

    return IntrinsicWidth(
      child: Container(
        constraints: const BoxConstraints(
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
              isPressed = true; // Sempre true no tap down
            });
          },
          onTapUp: (details) {
            setState(() {
              isPressed = false; // Sempre false no tap up
            });
          },
          onTapCancel: () {
            setState(() {
              isPressed =
                  false; // Garante que volta ao normal se o tap for cancelado
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.medication.entity.tradeName,
                      style: AppTheme.h4(
                        color: fontPrimary,
                        fontWeight: FontWeight.bold,
                      ),
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
                        Text(
                          widget.medication.entity.presentation,
                          style: AppTheme.h5(
                            color: fontSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Forma: ",
                          style: AppTheme.h5(
                            color: fontPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.medication.entity.form,
                          style: AppTheme.h5(
                            color: fontSecondary,
                            fontWeight: FontWeight.w400,
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
                        Text(
                          '${widget.medication.entity.activeIngredient} - ${widget.medication.entity.activeIngredientConcentration}mg/mL',
                          style: AppTheme.h5(
                            color: fontSecondary,
                            fontWeight: FontWeight.w400,
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
                        Text(
                          "${widget.medication.entity.viscosityDropsPerML}gts/mL",
                          style: AppTheme.h5(
                            color: fontSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              if (widget.medication.type == 'vaccine_dose')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.medication.entity.vaccineName,
                      style: AppTheme.h4(
                        color: fontPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Dose: ",
                          style: AppTheme.h5(
                            color: fontPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${widget.medication.entity.doseNumber}a dose',
                          style: AppTheme.h5(
                            color: fontSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              const SizedBox(
                height: 4,
              ),
              Container(
                height: 5,
                width: double.infinity,
                color: divider,
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.medication.entity.susAvailability
                        ? "Disponível no SUS"
                        : "Indisponível no SUS",
                    style: AppTheme.h5(
                      color: fontPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5),
                    child: widget.medication.entity.susAvailability
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
                    widget.medication.entity.commercialAvailability
                        ? "Preço no frasco: R\$ ${widget.medication.entity.bottlePrice}"
                        : "Não Disponível Comercialmente",
                    style: AppTheme.h5(
                      color: fontPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5),
                    child: widget.medication.entity.commercialAvailability
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
          ),
        ),
      ),
    );
  }
}
