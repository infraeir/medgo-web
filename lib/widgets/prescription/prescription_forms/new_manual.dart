import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:medgo/data/models/new_prescription_model.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/button/outline_button.dart';
import 'package:medgo/widgets/dynamic_form/widgets/input_text_field.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NewManualForm extends StatefulWidget {
  final ItemModel medication;
  final Function(bool? isFavorite) favoritarReceita;
  final Function(dynamic data) adicionarReceita;
  const NewManualForm({
    super.key,
    required this.medication,
    required this.favoritarReceita,
    required this.adicionarReceita,
  });

  @override
  State<NewManualForm> createState() => _NewManualFormState();
}

class _NewManualFormState extends State<NewManualForm> {
  TextEditingController controllerPrescricao = TextEditingController();
  final ValueNotifier<bool> favourite = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    controllerPrescricao.text = widget.medication.instructions.prescription;
    favourite.value = widget.medication.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prescrição Manual',
          style: AppTheme.h4(
            color: const Color(0xff004155),
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Posologia:',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0xff57636C),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    InputTextField(
                      width: double.infinity,
                      controller: controllerPrescricao,
                      keyboardType: TextInputType.text,
                      hintText: '',
                      labelText: '',
                      isError: false,
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: const Color(0xff004155),
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              widget.medication.type == 'medication'
                  ? _getPrescriptionMedication()
                  : _getPrescriptionVacination(),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AnimatedBuilder(
              animation: favourite,
              builder: (context, snapshot) {
                return SizedBox(
                  width: 220,
                  child: OutlinePrimaryButton(
                    onTap: () {
                      favourite.value = !favourite.value;
                      widget.favoritarReceita(
                        favourite.value,
                      );
                    },
                    title: favourite.value
                        ? 'Remover favorito'
                        : 'Favoritar prescrição',
                    iconeLeft: favourite.value
                        ? PhosphorIcons.heart()
                        : PhosphorIcons.heart(),
                    iconColor: AppTheme.error,
                  ),
                );
              },
            ),
            const SizedBox(
              width: 10,
            ),
            OutlinePrimaryButton(
              onTap: () {
                widget.adicionarReceita(
                  {
                    'type': 'manual',
                    'manualMedicalAdvice': [
                      controllerPrescricao.text,
                    ]
                  },
                );
              },
              title: 'Adicionar à receita',
              iconeLeft: PhosphorIcons.prescription(),
              iconColor: AppTheme.error,
            ),
          ],
        )
      ],
    );
  }

  _getPrescriptionMedication() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 10,
            ),
            Text(
              '${widget.medication.entity.tradeName} (${widget.medication.entity.presentation}, ${widget.medication.entity.activeIngredient} - ${widget.medication.entity.activeIngredientConcentration} mg/ml)',
              style: AppTheme.h6(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              width: 16,
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
              widget.medication.instructions.duration,
              style: AppTheme.h6(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  // Copiar posologia para a área de transferência
                  Clipboard.setData(ClipboardData(
                      text: widget.medication.instructions.prescription));
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
                child: Icon(
                  PhosphorIcons.copySimple(),
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              'Copiar posologia',
              style: AppTheme.h6(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        AnimatedBuilder(
            animation: controllerPrescricao,
            builder: (context, _) {
              return Row(
                children: [
                  const SizedBox(
                    width: 24,
                  ),
                  Text(
                    controllerPrescricao.text,
                    style: AppTheme.h6(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              );
            }),
      ],
    );
  }

  _getPrescriptionVacination() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.medication.entity.vaccineName,
              style: AppTheme.h6(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              width: 16,
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
              '${widget.medication.entity.doseNumber} dose',
              style: AppTheme.h6(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(
                      text:
                          'Aplicar ${widget.medication.entity.doseNumber} dose'));

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
                child: Icon(
                  PhosphorIcons.copySimple(),
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 32,
            ),
          ],
        ),
        AnimatedBuilder(
            animation: controllerPrescricao,
            builder: (context, _) {
              return Row(
                children: [
                  const SizedBox(
                    width: 24,
                  ),
                  Text(
                    controllerPrescricao.text,
                    style: AppTheme.h6(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              );
            }),
      ],
    );
  }
}
