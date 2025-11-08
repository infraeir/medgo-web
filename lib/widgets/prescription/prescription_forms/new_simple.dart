import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:medgo/data/models/new_prescription_model.dart';
import 'package:medgo/strings/strings.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/button/outline_button.dart';
import 'package:medgo/widgets/dynamic_form/widgets/input_text_field.dart';
import 'package:medgo/widgets/news_widgets/count_input/count_input.dart';
import 'package:medgo/widgets/prescription/prescription_forms/new_simple_form_controller.dart';
import 'package:medgo/widgets/prescription/widget/custom_chip_multiple_wrap.dart';
import 'package:medgo/widgets/prescription/widget/custom_chip_wrap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'simple_form_variables.dart';

class NewSimpleForm extends StatefulWidget {
  final ItemModel medication;
  final Function(dynamic data) adicionarReceita;
  final Function(bool isFavorite) favoritarReceita;
  const NewSimpleForm({
    super.key,
    required this.medication,
    required this.adicionarReceita,
    required this.favoritarReceita,
  });

  @override
  State<NewSimpleForm> createState() => _NewSimpleFormState();
}

class _NewSimpleFormState extends State<NewSimpleForm> {
  final NewSimpleFormController controller = NewSimpleFormController();

  @override
  void initState() {
    super.initState();
    controller.configurarForm(widget.medication);
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 768;
    final isMediumScreen = MediaQuery.of(context).size.width > 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prescrição simples',
          style: AppTheme.h4(
            color: const Color(0xff004155),
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 15),
        Divider(
          height: 5,
          color: const Color(0xff004155).withOpacity(0.3),
        ),
        const SizedBox(height: 15),
        ValueListenableBuilder<String>(
          valueListenable: controller.pleasureForm,
          builder: (context, value, child) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isLargeScreen) ...[
                    _buildDesktopLayout(),
                  ] else ...[
                    _buildMobileLayout(),
                  ],

                  if (controller.pleasureForm.value == Strings.time) ...[
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Horário(s) de uso:',
                            style: TextStyle(
                              color: Color(0xff57636C),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          CustomMultipleChipWrap(
                            valueForm: controller.timeForm,
                            items: itemsHorarios,
                            onChange: (value) {
                              controller.timeForm.value = value;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Campo de intervalo personalizado
                  ValueListenableBuilder<bool>(
                    valueListenable: controller.showOtherIntervalField,
                    builder: (context, showField, child) {
                      return Visibility(
                        visible: showField,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Informe o intervalo:',
                                style: TextStyle(
                                  color: Color(0xff57636C),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              InputTextField(
                                width: double.infinity,
                                controller: controller.otherIntervalController,
                                keyboardType: TextInputType.text,
                                hintText: 'Ex: 1 hora e meia',
                                labelText: '',
                                isError: false,
                                onChanged: (value) {},
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Seção de duração do tratamento
                  const SizedBox(height: 15),
                  Divider(
                    height: 5,
                    color: const Color(0xff004155).withOpacity(0.3),
                  ),
                  const SizedBox(height: 15),
                  _buildDurationSection(),

                  // Instruções adicionais
                  const SizedBox(height: 15),
                  Divider(
                    height: 5,
                    color: const Color(0xff004155).withOpacity(0.3),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Instruções adicionais de uso:',
                          style: TextStyle(
                            color: Color(0xff57636C),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        InputTextField(
                          width: double.infinity,
                          controller: controller.controllerAdicional,
                          keyboardType: TextInputType.text,
                          hintText: '',
                          labelText: '',
                          isError: false,
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                  ),

                  // Visualização da posologia
                  const SizedBox(height: 15),
                  _buildPosologyPreview(),

                  // Botões de ação
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _buildActionButtons(isMediumScreen),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quantidade de gotas
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Alinha à esquerda
                  children: [
                    const Text(
                      'Quantidade (em gotas):',
                      style: TextStyle(
                        color: Color(0xff57636C),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    CountInputMedgo(
                      controller: controller.controllerQtdGotas,
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),
            ),

            // Forma de aprazamento
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Forma de aprazamento:',
                      style: TextStyle(
                        color: Color(0xff57636C),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    CustomChipWrap(
                      valueForm: controller.pleasureForm,
                      items: itemsPleasureForm,
                      onChange: (value) {
                        controller.pleasureForm.value = value;
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Campos condicionais baseados no tipo de aprazamento
            if (controller.pleasureForm.value == Strings.interval) ...[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5.0, vertical: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Intervalo entre as doses:',
                        style: TextStyle(
                          color: Color(0xff57636C),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      CustomChipWrap(
                        valueForm: controller.intervalForm,
                        items: itemsIntervalos,
                        onChange: (value) {
                          controller.intervalForm.value = value;
                          controller.showOtherIntervalField.value =
                              value == 'other';
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],

            if (controller.pleasureForm.value == 'times_a_day') ...[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5.0, vertical: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Número de vezes ao dia:',
                        style: TextStyle(
                          color: Color(0xff57636C),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      CountInputMedgo(
                        controller: controller.controllerNumVezes,
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ),
              ),
            ],

            if (controller.pleasureForm.value == Strings.turn) ...[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5.0, vertical: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Turnos de uso:',
                        style: TextStyle(
                          color: Color(0xff57636C),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      CustomMultipleChipWrap(
                        valueForm: controller.turnForm,
                        items: itemsTurno,
                        onChange: (value) {
                          controller.turnForm.value = value;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],

            if (controller.pleasureForm.value == Strings.meals) ...[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5.0, vertical: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Referência:',
                        style: TextStyle(
                          color: Color(0xff57636C),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      CustomChipWrap(
                        valueForm: controller.referenceForm,
                        items: itemsReference,
                        onChange: (value) {
                          controller.referenceForm.value = value;
                        },
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
                        'Refeições:',
                        style: TextStyle(
                          color: Color(0xff57636C),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      CustomMultipleChipWrap(
                        valueForm: controller.mealsForm,
                        items: itemsRefeicoes,
                        onChange: (value) {
                          controller.mealsForm.value = value;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Alinha à esquerda
      children: [
        // Quantidade de gotas
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Alinha à esquerda
            children: [
              const Text(
                'Quantidade (em gotas):',
                style: TextStyle(
                  color: Color(0xff57636C),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              CountInputMedgo(
                controller: controller.controllerQtdGotas,
                onChanged: (value) {},
              ),
            ],
          ),
        ),

        // Forma de aprazamento
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Forma de aprazamento:',
                style: TextStyle(
                  color: Color(0xff57636C),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              CustomChipWrap(
                valueForm: controller.pleasureForm,
                items: itemsPleasureForm,
                onChange: (value) {
                  controller.pleasureForm.value = value;
                },
              ),
            ],
          ),
        ),

        // Campos condicionais baseados no tipo de aprazamento
        if (controller.pleasureForm.value == Strings.interval) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Intervalo entre as doses:',
                  style: TextStyle(
                    color: Color(0xff57636C),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                CustomChipWrap(
                  valueForm: controller.intervalForm,
                  items: itemsIntervalos,
                  onChange: (value) {
                    controller.intervalForm.value = value;
                    controller.showOtherIntervalField.value = value == 'other';
                  },
                ),
              ],
            ),
          ),
        ],

        if (controller.pleasureForm.value == 'times_a_day') ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Número de vezes ao dia:',
                  style: TextStyle(
                    color: Color(0xff57636C),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                CountInputMedgo(
                  controller: controller.controllerNumVezes,
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
        ],

        if (controller.pleasureForm.value == Strings.turn) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Turnos de uso:',
                  style: TextStyle(
                    color: Color(0xff57636C),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                CustomMultipleChipWrap(
                  valueForm: controller.turnForm,
                  items: itemsTurno,
                  onChange: (value) {
                    controller.turnForm.value = value;
                  },
                ),
              ],
            ),
          ),
        ],

        if (controller.pleasureForm.value == Strings.meals) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Referência:',
                  style: TextStyle(
                    color: Color(0xff57636C),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                CustomChipWrap(
                  valueForm: controller.referenceForm,
                  items: itemsReference,
                  onChange: (value) {
                    controller.referenceForm.value = value;
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Refeições:',
                  style: TextStyle(
                    color: Color(0xff57636C),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                CustomMultipleChipWrap(
                  valueForm: controller.mealsForm,
                  items: itemsRefeicoes,
                  onChange: (value) {
                    controller.mealsForm.value = value;
                  },
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDurationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            children: [
              const Text(
                'Forma de duração do tratamento:',
                style: TextStyle(
                  color: Color(0xff57636C),
                  fontWeight: FontWeight.w700,
                ),
              ),
              CustomChipWrap(
                valueForm: controller.durationForm,
                items: itemsDurationOfTreatment,
                onChange: (value) {
                  controller.durationForm.value = value;
                },
              ),
            ],
          ),
        ),

        // Campos condicionais para duração
        AnimatedBuilder(
          animation: controller.durationForm,
          builder: (context, child) {
            return (controller.durationForm.value == Strings.forUntil ||
                    controller.durationForm.value == Strings.per)
                ? Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Duração:',
                                  style: TextStyle(
                                    color: Color(0xff57636C),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                CountInputMedgo(
                                  controller: controller.controllerDuracao,
                                  onChanged: (value) {},
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              children: [
                                const Text(
                                  'Unidade de medida:',
                                  style: TextStyle(
                                    color: Color(0xff57636C),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                CustomChipWrap(
                                  valueForm: controller.unidadeForm,
                                  items: itemsUnidade,
                                  onChange: (value) {
                                    controller.unidadeForm.value = value;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildPosologyPreview() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xff004155),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    String posologia = getDarQuantidade();
                    Clipboard.setData(
                      ClipboardData(
                        text: posologia,
                      ),
                    );
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: AnimatedBuilder(
              animation: Listenable.merge([
                controller.controllerQtdGotas,
                controller.pleasureForm,
                controller.controllerNumVezes,
                controller.intervalForm,
                controller.turnForm,
                controller.referenceForm,
                controller.mealsForm,
                controller.timeForm,
                controller.controllerDuracao,
                controller.unidadeForm,
                controller.durationForm,
                controller.otherIntervalController,
              ]),
              builder: (context, snapshot) {
                return Text(
                  getDarQuantidade(),
                  style: AppTheme.h6(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: AnimatedBuilder(
              animation: controller.controllerAdicional,
              builder: (context, _) {
                return controller.controllerAdicional.text.isNotEmpty
                    ? Text(
                        controller.controllerAdicional.text,
                        style: AppTheme.h6(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isMediumScreen) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerRight, // Alinha os botões à direita
      child: Wrap(
        alignment:
            WrapAlignment.end, // Alinha os botões à direita dentro do Wrap
        spacing: 10,
        runSpacing: 10,
        children: [
          AnimatedBuilder(
            animation: controller.favourite,
            builder: (context, snapshot) {
              return SizedBox(
                width: isMediumScreen ? 220 : double.infinity,
                child: OutlinePrimaryButton(
                  onTap: () {
                    controller.favourite.value = !controller.favourite.value;
                    widget.favoritarReceita(controller.favourite.value);
                  },
                  title: controller.favourite.value
                      ? 'Remover favorito'
                      : 'Favoritar prescrição',
                  iconeLeft: controller.favourite.value
                      ? PhosphorIcons.heart()
                      : PhosphorIcons.heart(),
                  iconColor: AppTheme.error,
                ),
              );
            },
          ),
          SizedBox(
            width: isMediumScreen ? 200 : double.infinity,
            child: OutlinePrimaryButton(
              onTap: () {},
              isDisabled: true,
              title: 'Salvar modelo',
              iconeLeft: PhosphorIcons.floppyDisk(),
              iconColor: AppTheme.accent2,
            ),
          ),
          SizedBox(
            width: isMediumScreen ? 200 : double.infinity,
            child: OutlinePrimaryButton(
              onTap: () {
                widget.adicionarReceita({
                  'type': 'simple',
                  'data': {
                    "quantity": controller.controllerQtdGotas.value,
                    "dosage": getDarQuantidade(),
                    "pleasureForm": controller.pleasureForm.value,
                    "intervalBetweenDoses": controller.intervalForm.value == ''
                        ? null
                        : controller.intervalForm.value,
                    "medicationPresentation": widget
                        .medication.instructions.data.medicationPresentation,
                    "timesADay": controller.controllerNumVezes.value,
                    "useTurns": controller.turnForm.value,
                    "reference": controller.referenceForm.value == ''
                        ? null
                        : controller.referenceForm.value,
                    "meals": controller.mealsForm.value,
                    "schedules": controller.timeForm.value,
                    "durationTreatmentData": {
                      "form": controller.durationForm.value,
                      "duration": controller.controllerDuracao.value,
                      "unit": controller.unidadeForm.value,
                    },
                    "additionalInstructions":
                        controller.controllerAdicional.text
                  },
                });
              },
              title: 'Adicionar à receita',
              iconeLeft: PhosphorIcons.prescription(),
              iconColor: AppTheme.error,
            ),
          ),
        ],
      ),
    );
  }

  getDuracao() {
    switch (controller.durationForm.value) {
      case 'continuous_use':
        return 'uso contínuo';
      case 'immediate_use':
        return '01 Frasco';
      case 'per':
        return '01 Frasco';
      case 'for_until':
        return '01 Frasco';
      case 'symptoms':
        return '01 Frasco';
      default:
        return 'uso contínuo';
    }
  }

  getUnidadeDuracao() {
    switch (controller.unidadeForm.value) {
      case 'hours':
        return controller.controllerDuracao.value.toString() == '1'
            ? 'Hora'
            : 'Horas';
      case 'days':
        return controller.controllerDuracao.value.toString() == '1'
            ? 'Dia'
            : 'Dias';
      case 'weeks':
        return controller.controllerDuracao.value.toString() == '1'
            ? 'Semana'
            : 'Semanas';
      case 'months':
        return controller.controllerDuracao.value.toString() == '1'
            ? 'Mês'
            : 'Meses';
      default:
        return '';
    }
  }

  getDarQuantidade() {
    var darGotas =
        'Dar ${controller.controllerQtdGotas.value.toString()} ${controller.controllerQtdGotas.value <= 1 ? 'gota' : 'gotas'}, via oral,';

    switch (controller.pleasureForm.value) {
      case 'interval':
        darGotas = '$darGotas de ${getHoras()}';
        break;
      case 'times_a_day':
        darGotas =
            '$darGotas ${controller.controllerNumVezes.value.toString()} ${controller.controllerNumVezes.value <= 1 ? 'vez' : 'vezes'} ao dia';
        break;
      case 'turning':
        darGotas = '$darGotas ${getTurnoDeUso()}';
        break;
      case 'meals':
        darGotas = '$darGotas ${getReference()}';
        break;
      case 'schedules':
        darGotas = '$darGotas ${getHour()}';
        break;
      default:
        break;
    }

    darGotas = darGotas + getDescricaoDuracao();

    return darGotas;
  }

  getDescricaoDuracao() {
    switch (controller.durationForm.value) {
      case 'continuous_use':
        return '.';
      case 'immediate_use':
        return ', imediatamente.';
      case 'per':
        return ', por ${controller.controllerDuracao.value.toString()} ${getTitleByValue(controller.unidadeForm.value)}.';
      case 'for_until':
        return ', por até ${controller.controllerDuracao.value.toString()} ${getTitleByValue(controller.unidadeForm.value)}.';
      case 'symptoms':
        return ' enquanto durarem os sintomas.';
      default:
        return '';
    }
  }

  String getTitleByValue(String value) {
    for (var item in itemsUnidade) {
      if (item['value'] == value) {
        return item['title'] ?? 'Não encontrado';
      }
    }
    return 'Não encontrado';
  }

  getHoras() {
    switch (controller.intervalForm.value) {
      case '24h':
        return '24 em 24 horas';
      case '12h':
        return '12 em 12 horas';
      case '8h':
        return '8 em 8 horas';
      case '6h':
        return '6 em 6 horas';
      case '4h':
        return '4 em 4 horas';
      case '2h':
        return '2 em 2 horas';
      case 'other':
        return controller.otherIntervalController.text;
      default:
        return '';
    }
  }

  getTurnoDeUso() {
    var listaDeTurnos = [];

    for (var turn in controller.turnForm.value) {
      var turnoEncontrado = itemsTurno.firstWhere(
          (item) => item['value'] == turn,
          orElse: () => {'title': ''});
      listaDeTurnos.add(turnoEncontrado['title']);
    }

    // Reordena para que 'Manhã' seja o primeiro, se estiver presente
    if (listaDeTurnos.contains('Manhã')) {
      listaDeTurnos
        ..remove('Manhã') // Remove 'Manhã' da posição atual
        ..insert(0, 'Manhã'); // Insere 'Manhã' no início da lista
    }

    if (listaDeTurnos.isEmpty) {
      return ''; // Retorna vazio se não houver turnos
    } else if (listaDeTurnos.length == 1) {
      if ((listaDeTurnos.first).toLowerCase() == 'manhã') {
        return 'pela ${(listaDeTurnos.first).toLowerCase()}'; // Retorna o único turno sem 'e'
      }
      return 'à ${(listaDeTurnos.first).toLowerCase()}'; // Retorna o único turno sem 'e'
    } else {
      // Separa por vírgula e adiciona " e " antes do último turno
      if (listaDeTurnos.contains('Manhã')) {
        return 'pela ${listaDeTurnos.sublist(0, listaDeTurnos.length - 1).join(', à ').toLowerCase()} e à ${(listaDeTurnos.last).toLowerCase()}';
      } else {
        return 'à ${listaDeTurnos.sublist(0, listaDeTurnos.length - 1).join(', à ').toLowerCase()} e à ${(listaDeTurnos.last).toLowerCase()}';
      }
    }
  }

  getReference() {
    var reference = controller.referenceForm.value;
    var meals = controller.mealsForm.value;

    String referenciaEncontrada;

    // Definir o texto com base no valor de referência
    if (reference == 'after') {
      referenciaEncontrada = 'após o';
    } else {
      referenciaEncontrada = 'antes do';
    }

    // Buscar os títulos das refeições com base nos valores selecionados
    var refeicoesEncontradas = meals.map((meal) {
      return itemsRefeicoes.firstWhere((item) => item['value'] == meal,
          orElse: () => {'title': ''})['title'];
    }).toList();

    // Remover refeições com títulos vazios
    refeicoesEncontradas =
        refeicoesEncontradas.where((element) => element!.isNotEmpty).toList();

    // Verificar o número de refeições encontradas para ajustar os divisores
    if (refeicoesEncontradas.isEmpty) {
      return ''; // Retorna vazio se não houver refeições
    } else {
      // Formatar as refeições com "antes do" ou "após o" antes de cada uma
      var refeicoesFormatadas = refeicoesEncontradas.map((refeicao) {
        return "${referenciaEncontrada.toLowerCase()} ${refeicao!.toLowerCase()}";
      }).join(', ');

      // Adicionar "e" antes da última refeição, se houver mais de uma
      if (refeicoesEncontradas.length > 1) {
        int lastIndex = refeicoesFormatadas.lastIndexOf(', ');
        if (lastIndex != -1) {
          refeicoesFormatadas =
              '${refeicoesFormatadas.substring(0, lastIndex)} e ${refeicoesFormatadas.substring(lastIndex + 2)}';
        }
      }

      return refeicoesFormatadas;
    }
  }

  getHour() {
    var listaDeHorarios = [];

    // Adiciona os horários encontrados à lista
    for (var horario in controller.timeForm.value) {
      var horarioEncontrado = itemsHorarios.firstWhere(
          (item) => item['value'] == horario,
          orElse: () => {'title': ''});
      listaDeHorarios.add(horarioEncontrado['title']);
    }

    // Converte os horários para um formato numérico para ordenar
    listaDeHorarios.sort((a, b) {
      var horaA = int.parse(a.split(':')[0]); // Pega a hora antes do ':'
      var horaB = int.parse(b.split(':')[0]);
      return horaA.compareTo(horaB); // Ordena de forma crescente
    });

    if (listaDeHorarios.isEmpty) {
      return ''; // Retorna vazio se não houver horários
    } else {
      // Formata os horários com "às" antes de cada um
      var horariosFormatados =
          listaDeHorarios.map((horario) => 'às $horario').toList();

      // Junta os horários formatados com vírgula e adiciona "e" antes do último
      String resultado;
      if (horariosFormatados.length == 1) {
        resultado =
            '${horariosFormatados.first} horas'; // Adiciona 'horas' se houver apenas um horário
      } else {
        String todosMenosUltimo = horariosFormatados
            .sublist(0, horariosFormatados.length - 1)
            .join(', ');
        resultado =
            '$todosMenosUltimo e ${horariosFormatados.last} horas'; // Adiciona 'e' antes do último horário
      }

      return resultado;
    }
  }
}
