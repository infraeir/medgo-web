import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:medgo/data/models/new_prescription_model.dart';
import 'package:medgo/strings/strings.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/button/outline_button.dart';
import 'package:medgo/widgets/dynamic_form/widgets/input_text_field.dart';
import 'package:medgo/widgets/prescription/widget/custom_chip_wrap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NewComplexForm extends StatefulWidget {
  final ItemModel medication;
  const NewComplexForm({super.key, required this.medication});

  @override
  State<NewComplexForm> createState() => _NewComplexFormState();
}

class _NewComplexFormState extends State<NewComplexForm> {
  TextEditingController controllerQtdGotas = TextEditingController();
  TextEditingController controllerDuracao = TextEditingController();
  TextEditingController controllerAdicional = TextEditingController();
  ValueNotifier<String> pleasureForm = ValueNotifier<String>(Strings.time);
  ValueNotifier<String> mealsForm = ValueNotifier<String>('');
  ValueNotifier<String> timeForm = ValueNotifier<String>('');
  ValueNotifier<String> turnForm = ValueNotifier<String>('');
  ValueNotifier<String> referenceForm = ValueNotifier<String>('');
  ValueNotifier<String> durationForm = ValueNotifier<String>('');
  ValueNotifier<String> unidadeForm = ValueNotifier<String>('');

  final List<Map<String, String>> itemsPleasureForm = [
    {'title': 'Horário', 'value': 'time'},
    {'title': 'Turno', 'value': 'turn'},
    {'title': 'Refeições', 'value': 'meals'},
  ];

  final List<Map<String, String>> itemsRefeicoes = [
    {'title': 'Café da manhã', 'value': 'cafe'},
    {'title': 'Almoço', 'value': 'almoco'},
    {'title': 'Jantar', 'value': 'jantar'},
  ];

  final List<Map<String, String>> itemsHorarios = [
    {'title': '7:00', 'value': '7:00'},
    {'title': '8:00', 'value': '8:00'},
    {'title': '9:00', 'value': '9:00'},
    {'title': '10:00', 'value': '10:00'},
    {'title': '11:00', 'value': '11:00'},
    {'title': '12:00', 'value': '12:00'},
    {'title': '13:00', 'value': '13:00'},
    {'title': '14:00', 'value': '14:00'},
    {'title': '15:00', 'value': '15:00'},
    {'title': '16:00', 'value': '16:00'},
    {'title': '17:00', 'value': '17:00'},
    {'title': '18:00', 'value': '18:00'},
    {'title': '19:00', 'value': '19:00'},
    {'title': '20:00', 'value': '20:00'},
    {'title': '21:00', 'value': '21:00'},
    {'title': '22:00', 'value': '22:00'},
    {'title': '23:00', 'value': '23:00'},
    {'title': '24:00', 'value': '24:00'},
    {'title': '00:00', 'value': '00:00'},
    {'title': '01:00', 'value': '01:00'},
    {'title': '02:00', 'value': '02:00'},
    {'title': '03:00', 'value': '03:00'},
    {'title': '04:00', 'value': '04:00'},
    {'title': '05:00', 'value': '05:00'},
    {'title': '06:00', 'value': '06:00'},
  ];

  final List<Map<String, String>> itemsTurno = [
    {'title': 'Manhã', 'value': 'morning'},
    {'title': 'Tarde', 'value': 'afternoon'},
    {'title': 'Noite', 'value': 'night'},
  ];

  final List<Map<String, String>> itemsReference = [
    {'title': 'Antes', 'value': 'before'},
    {'title': 'Depois', 'value': 'after'},
  ];

  final List<Map<String, String>> itemsDurationOfTreatment = [
    {'title': 'Uso contínuo', 'value': 'usoContinuo'},
    {'title': 'Uso imediato', 'value': 'usoImediato'},
    {'title': 'Por', 'value': 'por'},
    {'title': 'Por até', 'value': 'porAte'},
    {'title': 'Enquanto durarem os sintomas', 'value': 'sintomas'},
  ];

  final List<Map<String, String>> itemsUnidade = [
    {'title': 'Horas', 'value': 'time'},
    {'title': 'Dias', 'value': 'day'},
    {'title': 'Semanas', 'value': 'week'},
    {'title': 'Meses', 'value': 'month'},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prescrição complexa',
          style: AppTheme.h4(
            color: const Color(0xff004155),
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Divider(
          height: 5,
          color: const Color(0xff004155).withOpacity(0.3),
        ),
        const SizedBox(
          height: 15,
        ),
        ValueListenableBuilder<String>(
          valueListenable: pleasureForm,
          builder: (context, value, child) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Quantidade (em gotas):',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color(0xff57636C),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                InputTextField(
                                  width: double.infinity,
                                  controller: controllerQtdGotas,
                                  keyboardType: TextInputType.number,
                                  hintText: '',
                                  labelText: '',
                                  isError: false,
                                  onChanged: (value) {},
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Forma de aprazamento:',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color(0xff57636C),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                CustomChipWrap(
                                  valueForm: pleasureForm,
                                  items: itemsPleasureForm,
                                  onChange: (value) {
                                    pleasureForm.value = value;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        pleasureForm.value == Strings.turn
                            ? Expanded(
                                child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Turnos de uso:',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Color(0xff57636C),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    CustomChipWrap(
                                      valueForm: turnForm,
                                      items: itemsTurno,
                                      onChange: (value) {
                                        turnForm.value = value;
                                      },
                                    ),
                                  ],
                                ),
                              ))
                            : const SizedBox.shrink(),
                        pleasureForm.value == Strings.meals
                            ? Expanded(
                                child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Referência:',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Color(0xff57636C),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    CustomChipWrap(
                                      valueForm: referenceForm,
                                      items: itemsReference,
                                      onChange: (value) {
                                        referenceForm.value = value;
                                      },
                                    ),
                                  ],
                                ),
                              ))
                            : const SizedBox.shrink(),
                        pleasureForm.value == Strings.time
                            ? const Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 4.0),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 4.0),
                          ),
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 4.0),
                          ),
                        ),
                        Expanded(
                          child: pleasureForm.value == Strings.meals
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 4.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Refeições:',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Color(0xff57636C),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      CustomChipWrap(
                                        valueForm: mealsForm,
                                        items: itemsRefeicoes,
                                        onChange: (value) {
                                          mealsForm.value = value;
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: pleasureForm.value == Strings.time
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 4.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Horário(s) de uso:',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Color(0xff57636C),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      CustomChipWrap(
                                        valueForm: timeForm,
                                        items: itemsHorarios,
                                        onChange: (value) {
                                          timeForm.value = value;
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Divider(
                      height: 5,
                      color: const Color(0xff004155).withOpacity(0.3),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 4.0),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Text(
                                  'Forma de duração do tratamento:',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color(0xff57636C),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                CustomChipWrap(
                                  valueForm: durationForm,
                                  items: itemsDurationOfTreatment,
                                  onChange: (value) {
                                    durationForm.value = value;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Duração:',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color(0xff57636C),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                InputTextField(
                                  width: double.infinity,
                                  controller: controllerDuracao,
                                  keyboardType: TextInputType.number,
                                  hintText: '',
                                  labelText: '',
                                  isError: false,
                                  onChanged: (value) {},
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 4.0),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Text(
                                  'Unidade de medida:',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color(0xff57636C),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                CustomChipWrap(
                                  valueForm: unidadeForm,
                                  items: itemsUnidade,
                                  onChange: (value) {
                                    unidadeForm.value = value;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Divider(
                      height: 5,
                      color: const Color(0xff004155).withOpacity(0.3),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Instruções adicionais de uso:',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color(0xff57636C),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                InputTextField(
                                  width: double.infinity,
                                  controller: controllerAdicional,
                                  keyboardType: TextInputType.number,
                                  hintText: '',
                                  labelText: '',
                                  isError: false,
                                  onChanged: (value) {},
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Divider(
                      height: 5,
                      color: const Color(0xff004155).withOpacity(0.3),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        Wrap(
                          direction: Axis.horizontal,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: [
                            SizedBox(
                              width: 320,
                              child: OutlinePrimaryButton(
                                onTap: () {},
                                title: 'Adicionar mudança gradual na dose',
                                iconeLeft: PhosphorIcons.chartLine(),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 260,
                              child: OutlinePrimaryButton(
                                onTap: () {},
                                title: 'Adicionar administração',
                                iconeLeft: PhosphorIcons.eyedropperSample(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xff004155),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
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
                                    String posologia = widget
                                        .medication.instructions.prescription;
                                    Clipboard.setData(
                                        ClipboardData(text: posologia));

                                    showToast(
                                      'Posologia copiada para a área de transferência!',
                                      context: context,
                                      axis: Axis.horizontal,
                                      alignment: Alignment.center,
                                      position: StyledToastPosition.top,
                                      animation:
                                          StyledToastAnimation.slideFromTopFade,
                                      reverseAnimation:
                                          StyledToastAnimation.fade,
                                      backgroundColor: AppTheme.secondary,
                                      textStyle:
                                          const TextStyle(color: Colors.white),
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
                          Row(
                            children: [
                              const SizedBox(
                                width: 24,
                              ),
                              Text(
                                widget.medication.instructions.prescription,
                                style: AppTheme.h6(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 24,
                              ),
                              Text(
                                'Dose diária de THC: ',
                                style: AppTheme.h6(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '3,2mg',
                                style: AppTheme.h6(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 24,
                              ),
                              Text(
                                'Dose diária de CBD: ',
                                style: AppTheme.h6(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '66mg',
                                style: AppTheme.h6(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 24,
                              ),
                              Text(
                                'Duração estimada do frasco: ',
                                style: AppTheme.h6(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '100 dias(3 meses*)',
                                style: AppTheme.h6(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 24,
                              ),
                              Text(
                                'Custo mensal aproximado: ',
                                style: AppTheme.h6(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'R\$ 300,00',
                                style: AppTheme.h6(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '*1 mês = 30,436875 dias.',
                                style: AppTheme.h6(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        Row(
          children: [
            const Spacer(),
            Wrap(
              direction: Axis.horizontal,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                SizedBox(
                  width: 220,
                  child: OutlinePrimaryButton(
                    onTap: () {},
                    title: 'Favoritar prescrição',
                    iconColor: AppTheme.error,
                    iconeLeft: PhosphorIcons.heart(),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 200,
                  child: OutlinePrimaryButton(
                    onTap: () {},
                    title: 'Salvar modelo',
                    iconColor: AppTheme.accent2,
                    iconeLeft: PhosphorIcons.floppyDisk(),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 200,
                  child: OutlinePrimaryButton(
                    onTap: () {},
                    title: 'Adicionar à receita',
                    iconColor: AppTheme.error,
                    iconeLeft: PhosphorIcons.prescription(),
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
