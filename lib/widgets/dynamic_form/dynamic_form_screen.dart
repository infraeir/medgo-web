import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:medgo/helper/formatter/decimal_input_formatter.dart';
import 'package:medgo/helper/helper.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/icon_button.dart';
import 'package:medgo/widgets/dynamic_form/validation_mixin.dart';
import 'package:medgo/widgets/dynamic_form/widgets/custom_toolchip.dart';
import 'package:medgo/widgets/news_widgets/count_input/count_input.dart';
import 'package:medgo/widgets/news_widgets/count_input/count_input_controller.dart';
import 'package:medgo/widgets/news_widgets/long_text_input.dart';
import 'package:medgo/widgets/news_widgets/short_text_input.dart';
import 'package:medgo/widgets/scrollbar/custom_scroll_bar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'form_model.dart';
import '../news_widgets/input_chip.dart';

class DynamicForm extends StatefulWidget {
  final List<ResponseForm> formResponse;
  final Function(dynamic value, String? backendAttribute) onChange;
  final Function(dynamic value) minimizedChange;
  final Function(Map<String, Map<String, String?>> validationErrors)
      onValidationStatusChanged;
  final EdgeInsets trackMarginScroll;
  const DynamicForm({
    Key? key,
    required this.formResponse,
    required this.onChange,
    required this.minimizedChange,
    required this.onValidationStatusChanged,
    this.trackMarginScroll = const EdgeInsets.only(top: 10.0),
  }) : super(key: key);

  @override
  State<DynamicForm> createState() => DynamicFormState();
}

class DynamicFormState extends State<DynamicForm> with ValidationMixin {
  bool isLoading = true;
  Map<String, FocusNode> focusNodes = {};
  var selectedOptions = <String, dynamic>{};
  var dateController = TextEditingController();
  bool switchValue = false;
  Map<String, TextEditingController> textControllers = {};
  Map<String, CountInputController> countInputControllers = {};
  Map<String, Map<String, String?>> validationErrors = {};

  late ScrollController scrollController;

  String textoJson = '';

  MaskTextInputFormatter birthdateMasked = MaskTextInputFormatter(
      mask: '##/##/####', filter: {'#': RegExp(r'[0-9]')});
  MaskTextInputFormatter birthhourMasked =
      MaskTextInputFormatter(mask: '##:##', filter: {'#': RegExp(r'[0-9]')});

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    getFromJson();
  }

  @override
  void didUpdateWidget(DynamicForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Verifica se o formResponse foi alterado
    if (oldWidget.formResponse != widget.formResponse) {
      // Reseta o estado e reinicializa
      setState(() {
        isLoading = true;
        textControllers.clear();
        countInputControllers.clear();
        selectedOptions.clear();
      });

      // Chama getFromJson para reconstruir o formulário
      getFromJson();
    }
  }

  Future<void> getFromJson() async {
    setState(() {
      isLoading = false;

      // Initialize text controllers
      initializeControllersWrapper();

      for (var element in widget.formResponse) {
        initializeSelectedOptions(element, element.backendAttribute!);
      }
    });
    widget.onChange(
      generateJson(),
      null,
    );
  }

  void resetForm() {
    // 1. Limpar os controladores e opções selecionadas recursivamente
    _clearFormFieldsRecursively(widget.formResponse);

    // 2. Limpar erros de validação
    validationErrors.clear();
    widget.onValidationStatusChanged(validationErrors);

    // 3. Gerar o JSON com todos os campos nulos e notificar o widget pai
    // Isso garantirá que `objectForm` na `CalculatorPage` seja atualizado com os valores nulos
    widget.onChange(generateJsonWithNulls(), null);

    // 4. Reconstruir a UI para refletir as mudanças
    setState(() {
      // Opcional: Se 'onChange' não causa um rebuild do formulário inteiro,
      // um setState() vazio aqui garante que os widgets sejam re-renderizados
      // com os valores de seus controladores limpos.
    });
  }

// NOVO MÉTODO RECURSIVO PARA LIMPAR CONTROLADORES E SELEÇÕES
  void _clearFormFieldsRecursively(List<ResponseForm> formsToClear) {
    for (var responseForm in formsToClear) {
      if (responseForm.children != null) {
        for (var field in responseForm.children!) {
          String fieldPath =
              '${responseForm.backendAttribute!}.${field.backendAttribute!}'; // Caminho completo

          if (field.componentType == "short_text_field" ||
              field.componentType == "long_text_field") {
            // Limpar TextEditingController
            if (textControllers.containsKey(fieldPath)) {
              textControllers[fieldPath]!.clear();
            }
            // Limpar CountInputController para 'int' short_text_fields
            if (field.inputType == 'int' &&
                countInputControllers.containsKey(fieldPath)) {
              countInputControllers[fieldPath]!
                  .reset(); // Assume que reset() já foi adicionado ao CountInputController
            }
          } else if (field.componentType == "selection_chips") {
            // Remover a opção selecionada
            selectedOptions.remove(fieldPath);
          } else if (field.componentType == "object" ||
              field.componentType == "sub_section") {
            // Chamar recursivamente para objetos aninhados e subseções
            // A função precisa ser flexível para aceitar uma lista de ResponseForm para recursão
            // Para isso, precisamos de um helper para simular a estrutura de lista
            _clearFormFieldsRecursively([
              field
            ]); // Passa o campo como uma lista de um único item para recursão
          }
        }
      }
    }
  }

  void initializeControllers(ResponseForm response, String path) {
    if (response.children == null) return;

    for (var field in response.children!) {
      String fieldPath = '$path.${field.backendAttribute!}';

      // Inicialize o FocusNode e adicione listener para unfocus
      if (!focusNodes.containsKey(fieldPath)) {
        focusNodes[fieldPath] = FocusNode();
        focusNodes[fieldPath]!.addListener(() {
          if (!focusNodes[fieldPath]!.hasFocus) {
            // O campo perdeu o foco
            if (field.flagged == true) {
              widget.onChange(
                generateJson(),
                fieldPath,
              );
            }
          }
        });
      }

      if (field.componentType == "short_text_field") {
        String prefilledValue = field.prefilledValue.toString();

        if (field.inputType == 'int') {
          // Inicializa o controlador para campos do tipo 'int'
          countInputControllers[fieldPath] =
              CountInputController(int.tryParse(prefilledValue) ?? 0);
        } else if (field.inputType == 'double') {
          // Substitui pontos por vírgulas para exibição
          prefilledValue = prefilledValue.replaceAll('.', ',');
          textControllers[fieldPath] =
              TextEditingController(text: prefilledValue);
        } else {
          textControllers[fieldPath] =
              TextEditingController(text: prefilledValue);
        }
      }

      if (field.componentType == "long_text_field") {
        String prefilledValue = field.prefilledValue.toString();

        textControllers[fieldPath] =
            TextEditingController(text: prefilledValue);
      }

      if (field.children != null) {
        initializeControllers(field, fieldPath);
      }
    }
  }

  void initializeControllersWrapper() {
    for (var response in widget.formResponse) {
      initializeControllers(response, response.backendAttribute!);
    }
  }

  void initializeSelectedOptions(ResponseForm element, String path) {
    if (element.children == null) return;

    for (var field in element.children!) {
      String fieldPath = '$path.${field.backendAttribute!}';
      for (var indexSelected in field.prefilledIndexes ?? []) {
        selectedOptions[fieldPath] = field.options![indexSelected].value;
      }
      if (field.children != null) {
        initializeSelectedOptions(field, fieldPath);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryBackground,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: CustomScrollbar(
                    controller: scrollController,
                    trackMargin: widget.trackMarginScroll,
                    child: Builder(builder: (context) {
                      return RepaintBoundary(
                          child: ScrollConfiguration(
                        behavior: _WebOptimizedScrollBehavior(),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(right: 20.0, left: 8.0),
                          child: ListView.builder(
                            controller: scrollController,
                            padding: widget.trackMarginScroll,
                            // Otimizar physics para web
                            physics: kIsWeb
                                ? const ClampingScrollPhysics()
                                : const AlwaysScrollableScrollPhysics(),
                            itemCount: widget.formResponse.length,
                            itemBuilder: (context, index) {
                              bool isMinimized =
                                  widget.formResponse[index].isMinimized!;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Material(
                                          elevation: 0.0,
                                          color: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          child: Container(
                                            height: 40,
                                            padding: const EdgeInsets.only(
                                              right: 10,
                                              left: 10,
                                              bottom: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  width: 1,
                                                  color: const Color(0xff004155)
                                                      .withOpacity(0.3),
                                                ),
                                              ),
                                              color: const Color(0xffDFEEFF),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                  index == 0 ? 20 : 0,
                                                ),
                                                topRight:
                                                    const Radius.circular(20),
                                                // bottomRight: isMinimized
                                                //     ? const Radius.circular(10)
                                                //     : const Radius.circular(0),
                                                // bottomLeft: isMinimized
                                                //     ? const Radius.circular(10)
                                                //     : const Radius.circular(0),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  widget.formResponse[index]
                                                          .title ??
                                                      '',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff004155),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                CustomIconButtonMedGo(
                                                  icon: Icon(
                                                    isMinimized
                                                        ? Icons.expand_more
                                                        : Icons.expand_less,
                                                    color: AppTheme.primary,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      // Inverte o estado de minimização
                                                      isMinimized =
                                                          !isMinimized;
                                                      widget.formResponse[index]
                                                              .isMinimized =
                                                          isMinimized;

                                                      // Atualiza o estado no mapa
                                                      widget.minimizedChange({
                                                        "minimizedSections": {
                                                          widget
                                                                  .formResponse[
                                                                      index]
                                                                  .backendAttribute:
                                                              widget
                                                                  .formResponse[
                                                                      index]
                                                                  .isMinimized,
                                                        },
                                                        "minimizedSubSections":
                                                            {},
                                                        "minimizedObjects": {},
                                                      });
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (!isMinimized) // Exibe o conteúdo da seção se não estiver minimizada
                                    Material(
                                      elevation: 0.0,
                                      color: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppTheme.secondaryBackground,
                                          border: Border.all(
                                            color: const Color(0xff004155)
                                                .withOpacity(0.3),
                                            width: 1,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            bottomRight: Radius.circular(20),
                                          ),
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: myFormType(
                                            widget.formResponse[index],
                                            widget.formResponse[index]
                                                .backendAttribute!,
                                          ),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 12),
                                ],
                              );
                            },
                          ),
                        ),
                      ));
                    }),
                  ),
                ),
              ],
            ),
    );
  }

// Função para renderizar os tipos de formulário
  Widget myFormType(ResponseForm formulario, String path) {
    return ListView.separated(
      itemCount: formulario.children?.length ?? 0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, innerIndex) {
        final field = formulario.children![innerIndex];
        String fieldPath = '$path.${field.backendAttribute!}';
        bool isMinimized = field.isMinimized ?? false;
        bool isMinimizedPanel = field.infoPainel?.isMinimized ?? true;

        // Atualiza o estado de minimização da subseção no mapa

        // Verifica todas as condições de visibilidade antes de renderizar o campo
        if (field.visibilityConditions != null) {
          bool conditionsMet = false;

          if (field.visibilityConditionOperator == 'AND') {
            conditionsMet = field.visibilityConditions!.every((condition) =>
                evaluateVisibilityCondition(condition, fieldPath));
          } else if (field.visibilityConditionOperator == 'OR') {
            conditionsMet = field.visibilityConditions!.any((condition) =>
                evaluateVisibilityCondition(condition, fieldPath));
          }

          // Se as condições não forem atendidas, retorna vazio
          if (!conditionsMet) {
            return Container();
          }
        }

        // Inicializa o campo de minimização se ainda não estiver definido
        field.isMinimized = field.isMinimized ?? false;
        field.infoPainel?.isMinimized = field.infoPainel?.isMinimized ?? false;

        switch (field.componentType) {
          case "short_text_field":
            return buildShortTextField(field, fieldPath);
          case "long_text_field":
            return buildLongTextField(field, fieldPath);
          case "selection_chips":
            return dropDownWidget(field, fieldPath);
          case "object":
            return Container(
              margin: const EdgeInsets.only(
                right: 16,
                left: 16,
                bottom: 2,
                top: 2,
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            field.title ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xff004155),
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: true,
                            maxLines: null,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (field.availabilityLabel != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: field.availabilityLabel?.value == true
                                      ? const Color(0xffDAEAEF)
                                      : const Color(0xffFFCFC9),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  field.availabilityLabel?.label ?? '',
                                  style: TextStyle(
                                    color:
                                        field.availabilityLabel?.value == true
                                            ? const Color(0xff16539D)
                                            : const Color(0xff690005),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (field.label != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                margin: const EdgeInsets.only(left: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xffF1F4F8),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  field.label ?? '',
                                  style: const TextStyle(
                                    color: Color(0xff57636C),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (field.tooltip != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: CustomTooltip(
                                  message: field.tooltip ?? '',
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () {},
                                    icon: Icon(
                                      PhosphorIcons.info(
                                        PhosphorIconsStyle.fill,
                                      ),
                                      color: Color(0xff57636C),
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            CustomIconButtonMedGo(
                              icon: Icon(
                                field.isMinimized!
                                    ? Icons.expand_more
                                    : Icons.expand_less,
                                color: AppTheme.primary,
                              ),
                              onPressed: () {
                                setState(() {
                                  // Inverte o estado de minimização
                                  field.isMinimized = !isMinimized;

                                  if (path.contains('.')) {
                                    // Atualizar apenas a subseção atual com path contendo pontos
                                    List<String> keys = path.split(
                                        '.'); // Dividir a string do caminho pelos pontos
                                    Map<String, dynamic> nestedMap = {};

                                    // Função para criar o mapa aninhado
                                    Map<String, dynamic> createNestedMap(
                                        List<String> keys, dynamic value) {
                                      if (keys.length == 1) {
                                        return {keys[0]: value};
                                      } else {
                                        return {
                                          keys[0]: createNestedMap(
                                              keys.sublist(1), value)
                                        };
                                      }
                                    }

                                    // Criar o mapa aninhado a partir do 'path'
                                    nestedMap = createNestedMap(keys, {
                                      field.backendAttribute!:
                                          field.isMinimized!
                                    });

                                    if (field.componentType == 'object') {
                                      // Enviar a mudança minimizada apenas para a subseção atual
                                      widget.minimizedChange({
                                        "minimizedSubSections": {},
                                        "minimizedSections": {},
                                        "minimizedObjects": nestedMap,
                                      });
                                    } else {
                                      // Enviar a mudança minimizada apenas para a subseção atual
                                      widget.minimizedChange({
                                        "minimizedSubSections": nestedMap,
                                        "minimizedSections": {},
                                        "minimizedObjects": {},
                                      });
                                    }
                                  } else {
                                    if (field.componentType == 'object') {
                                      widget.minimizedChange(
                                        {
                                          "minimizedSubSections": {},
                                          "minimizedSections": {},
                                          "minimizedObjects": {
                                            path: {
                                              field.backendAttribute!:
                                                  field.isMinimized!,
                                            }
                                          },
                                        },
                                      );
                                    } else {
                                      widget.minimizedChange(
                                        {
                                          "minimizedSubSections": {
                                            path: {
                                              field.backendAttribute!:
                                                  field.isMinimized!,
                                            }
                                          },
                                          "minimizedSections": {},
                                          "minimizedObjects": {},
                                        },
                                      );
                                    }
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  field.underline == true
                      ? Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 2,
                                color: const Color(0xFF326789),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                  if (!field.isMinimized!)
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 6.0),
                          child: myFormType(field, fieldPath),
                        ),
                        if (field.infoPainel != null)
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SizeTransition(
                                  sizeFactor: animation,
                                  axisAlignment: 0.0,
                                  child: child,
                                ),
                              );
                            },
                            child: isMinimizedPanel
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        key: const ValueKey('minimized'),
                                        height: 48,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 8.0),
                                        decoration: BoxDecoration(
                                          color: const Color(0xffe7f2f8),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize
                                              .min, // 👈 só usa o espaço necessário
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              field.infoPainel!.references!
                                                          .length ==
                                                      1
                                                  ? 'Referência:'
                                                  : 'Referências:',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff004155),
                                              ),
                                            ),
                                            if (field.infoPainel!.references!
                                                .isNotEmpty)
                                              ...field.infoPainel!.references!
                                                  .map(
                                                (reference) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: SvgPicture.asset(
                                                    'assets/icons/$reference.svg',
                                                    height: 24,
                                                    width: 24,
                                                  ),
                                                ),
                                              ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: CustomIconButtonMedGo(
                                                onPressed: () {
                                                  setState(() {
                                                    field.infoPainel
                                                        ?.isMinimized = false;
                                                    isMinimizedPanel = false;
                                                  });
                                                },
                                                icon: Icon(
                                                  PhosphorIcons.eyeSlash(),
                                                  color: AppTheme.primary,
                                                  size: 30,
                                                  shadows: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.25),
                                                      blurRadius: 2,
                                                      offset:
                                                          const Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(
                                    key: const ValueKey('expanded'),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 8.0),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffe7f2f8),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              field.infoPainel!.title ?? '',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff081E27),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: CustomIconButtonMedGo(
                                                onPressed: () {
                                                  setState(() {
                                                    isMinimizedPanel = true;
                                                    field.infoPainel
                                                        ?.isMinimized = true;
                                                  });
                                                },
                                                icon: Icon(
                                                  PhosphorIcons.eye(),
                                                  color: AppTheme.primary,
                                                  size: 30,
                                                  shadows: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.25),
                                                      blurRadius: 2,
                                                      offset:
                                                          const Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              field.infoPainel!.blocks!.length,
                                          itemBuilder: (context, index) {
                                            final block = field
                                                .infoPainel!.blocks![index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6.0),
                                              child: RichText(
                                                text: TextSpan(
                                                  style: const TextStyle(
                                                    color: Color(0xff004155),
                                                    fontSize: 14,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: (block.title ??
                                                              '') +
                                                          (block.content !=
                                                                      null &&
                                                                  block.content!
                                                                      .isNotEmpty
                                                              ? ' '
                                                              : ''),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    TextSpan(
                                                      text: block.content ?? '',
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              field.infoPainel!.references!
                                                          .length ==
                                                      1
                                                  ? 'Referência:'
                                                  : 'Referências:',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff004155),
                                              ),
                                            ),
                                            if (field.infoPainel!.references!
                                                .isNotEmpty)
                                              ...field.infoPainel!.references!
                                                  .map(
                                                (reference) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: SvgPicture.asset(
                                                    'assets/icons/$reference.svg',
                                                    height: 24,
                                                    width: 24,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                      ],
                    )
                ],
              ),
            );
          case "sub_section":
            return field.children != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Material(
                              elevation: 2.0,
                              child: Container(
                                height: 40,
                                padding: const EdgeInsets.only(
                                  right: 10,
                                  left: 10,
                                  bottom: 2,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      width: 1,
                                      color: const Color(0xff004155)
                                          .withOpacity(0.3),
                                    ),
                                    bottom: BorderSide(
                                      width: 1,
                                      color: const Color(0xff004155)
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                  color: const Color(0xffDFEEFF),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      field.title ?? '',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff004155),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    CustomIconButtonMedGo(
                                      icon: Icon(
                                        field.isMinimized!
                                            ? Icons.expand_more
                                            : Icons.expand_less,
                                        color: AppTheme.primary,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          // Inverte o estado de minimização
                                          field.isMinimized = !isMinimized;

                                          if (path.contains('.')) {
                                            // Atualizar apenas a subseção atual com path contendo pontos
                                            List<String> keys = path.split(
                                                '.'); // Dividir a string do caminho pelos pontos
                                            Map<String, dynamic> nestedMap = {};

                                            // Função para criar o mapa aninhado
                                            Map<String, dynamic>
                                                createNestedMap(
                                                    List<String> keys,
                                                    dynamic value) {
                                              if (keys.length == 1) {
                                                return {keys[0]: value};
                                              } else {
                                                return {
                                                  keys[0]: createNestedMap(
                                                      keys.sublist(1), value)
                                                };
                                              }
                                            }

                                            // Criar o mapa aninhado a partir do 'path'
                                            nestedMap = createNestedMap(keys, {
                                              field.backendAttribute!:
                                                  field.isMinimized!
                                            });

                                            if (field.componentType ==
                                                'object') {
                                              // Enviar a mudança minimizada apenas para a subseção atual
                                              widget.minimizedChange({
                                                "minimizedSubSections": {},
                                                "minimizedSections": {},
                                                "minimizedObjects": nestedMap,
                                              });
                                            } else {
                                              // Enviar a mudança minimizada apenas para a subseção atual
                                              widget.minimizedChange({
                                                "minimizedSubSections":
                                                    nestedMap,
                                                "minimizedSections": {},
                                                "minimizedObjects": {},
                                              });
                                            }
                                          } else {
                                            if (field.componentType ==
                                                'object') {
                                              widget.minimizedChange(
                                                {
                                                  "minimizedSubSections": {},
                                                  "minimizedSections": {},
                                                  "minimizedObjects": {
                                                    path: {
                                                      field.backendAttribute!:
                                                          field.isMinimized!,
                                                    }
                                                  },
                                                },
                                              );
                                            } else {
                                              widget.minimizedChange(
                                                {
                                                  "minimizedSubSections": {
                                                    path: {
                                                      field.backendAttribute!:
                                                          field.isMinimized!,
                                                    }
                                                  },
                                                  "minimizedSections": {},
                                                  "minimizedObjects": {},
                                                },
                                              );
                                            }
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (!field.isMinimized!)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: myFormType(field, fieldPath),
                        ),
                    ],
                  )
                : Container();
          default:
            return const SizedBox.shrink();
        }
      },
      separatorBuilder: (BuildContext context, int index) {
        final field = formulario.children![index];
        String fieldPath = '$path.${field.backendAttribute!}';

        // Função para verificar se um campo é visível
        bool isFieldVisible(field, String fieldPath) {
          if (field.visibilityConditions != null) {
            bool conditionsMet = false;
            if (field.visibilityConditionOperator == 'AND') {
              conditionsMet = field.visibilityConditions!.every((condition) =>
                  evaluateVisibilityCondition(condition, fieldPath));
            } else if (field.visibilityConditionOperator == 'OR') {
              conditionsMet = field.visibilityConditions!.any((condition) =>
                  evaluateVisibilityCondition(condition, fieldPath));
            }
            return conditionsMet;
          }
          return true;
        }

        // Procura se existe algum campo visível após o atual
        bool hasNextVisible = false;
        bool nextIsObjectOrSubSection = false;
        for (int i = index + 1; i < formulario.children!.length; i++) {
          final nextField = formulario.children![i];
          final nextFieldPath = '$path.${nextField.backendAttribute!}';
          if (isFieldVisible(nextField, nextFieldPath)) {
            // Se o próximo visível for object ou sub_section, não mostra divider
            if (nextField.componentType == 'object' ||
                nextField.componentType == 'sub_section') {
              nextIsObjectOrSubSection = true;
            }
            hasNextVisible = true;
            break;
          }
        }

        if (!hasNextVisible || nextIsObjectOrSubSection) {
          return const SizedBox.shrink();
        }

        // Se o campo atual não for visível, não mostra separador
        if (!isFieldVisible(field, fieldPath)) {
          return const SizedBox.shrink();
        }

        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Divider(),
        );
      },
    );
  }

  Widget buildShortTextField(ResponseForm field, String fieldPath) {
    TextInputType keyboardType;
    List<TextInputFormatter>? inputFormatters;

    switch (field.inputType) {
      case 'int':
        keyboardType = TextInputType.number;
        inputFormatters = [FilteringTextInputFormatter.digitsOnly];
        break;
      case 'double':
        keyboardType = const TextInputType.numberWithOptions(decimal: true);
        inputFormatters = [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\,?\d*')),
          DecimalCommaInputFormatter(),
        ];
        break;
      case 'date':
        keyboardType = TextInputType.datetime;
        inputFormatters = [birthdateMasked];
        break;
      case 'hour':
        keyboardType = TextInputType.datetime;
        inputFormatters = [birthhourMasked];
        break;
      case 'long_text_field':
        keyboardType = TextInputType.multiline;
        inputFormatters = null;
        break;
      case 'string':
      default:
        keyboardType = TextInputType.text;
        inputFormatters = null;
    }

    String? errorText = validationErrors[fieldPath]?['error'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        field.title ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Color(0xff57636C),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (field.tooltip != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: CustomTooltip(
                          message: field.tooltip ?? '',
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {},
                            icon: Icon(
                              PhosphorIcons.info(
                                PhosphorIconsStyle.fill,
                              ),
                              color: Color(0xff57636C),
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          field.inputType == 'int'
              ? CountInputMedgo(
                  controller: countInputControllers[fieldPath]!,
                  focusNode: focusNodes[fieldPath],
                  onChanged: (value) {
                    validateAndUpdateField(
                        field, fieldPath, value.toString(), null);
                  },
                  onChangedByIcon: (value) {
                    validateAndUpdateField(
                        field, fieldPath, value.toString(), true);
                  },
                  disabled: field.isDisabled ?? false,
                  errorText: errorText,
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ShortTextInputMedgo(
                        controller: textControllers[fieldPath]!,
                        focusNode: focusNodes[fieldPath],
                        keyboardType: keyboardType,
                        onChanged: (value) {
                          validateAndUpdateField(field, fieldPath, value, null);
                        },
                        errorText: errorText,
                        inputFormatters: inputFormatters,
                        enabled: field.isDisabled != null
                            ? !field.isDisabled!
                            : true,
                      ),
                    ),
                    const Spacer(flex: 1),
                  ],
                ),
        ],
      ),
    );
  }

  Widget buildLongTextField(ResponseForm field, String fieldPath) {
    TextInputType keyboardType;
    List<TextInputFormatter>? inputFormatters;

    switch (field.inputType) {
      case 'string':
      default:
        keyboardType = TextInputType.text;
        inputFormatters = null;
    }

    String? errorText = validationErrors[fieldPath]?['error'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        field.title ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Color(0xff57636C),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (field.tooltip != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: CustomTooltip(
                          message: field.tooltip ?? '',
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {},
                            icon: Icon(
                              PhosphorIcons.info(
                                PhosphorIconsStyle.fill,
                              ),
                              color: Color(0xff57636C),
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          LongTextInputMedgo(
            controller: textControllers[fieldPath]!,
            keyboardType: keyboardType,
            hintText: '',
            onChanged: (value) {
              validateAndUpdateField(field, fieldPath, value, null);
            },
            focusNode: focusNodes[fieldPath],
            errorText: errorText,
            inputFormatters: inputFormatters,
            enabled: field.isDisabled != null ? !field.isDisabled! : true,
            maxLines: null,
          ),
        ],
      ),
    );
  }

  void validateAndUpdateField(
      ResponseForm field, String fieldPath, String value, bool? toUpdate) {
    setState(() {
      String? error;
      bool shouldUpdate = true;

      if (field.inputType == 'date' && field.flagged == true) {
        // Verifica se o campo de data está completo
        if (value.length != 10) {
          shouldUpdate = false;
          error = 'Data incompleta';
        } else {
          toUpdate = true;
          validationErrors.remove(fieldPath);
        }
      }

      if (shouldUpdate) {
        error = validateField(value, field.validations ?? {});
        if (error != null) {
          validationErrors[fieldPath] = {
            'error': error,
            'title': field.title ?? 'Campo sem título'
          };
        } else {
          validationErrors.remove(fieldPath);
        }

        widget.onValidationStatusChanged(validationErrors);

        if (toUpdate == true) {
          widget.onChange(
            generateJson(),
            field.flagged == true ? fieldPath : null,
          );
        }
      } else {
        validationErrors[fieldPath] = {
          'error': error!,
          'title': field.title ?? 'Campo sem título'
        };
        widget.onValidationStatusChanged(validationErrors);
      }
    });
  }

  Widget dropDownWidget(ResponseForm field, String fieldPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        field.title ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Color(0xff57636C),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (field.tooltip != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: CustomTooltip(
                          message: field.tooltip ?? '',
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {},
                            icon: Icon(
                              PhosphorIcons.info(
                                PhosphorIconsStyle.fill,
                              ),
                              color: Color(0xff57636C),
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 2,
          ),
          Wrap(
            spacing: 8.0,
            children: field.options!.map((option) {
              bool selected = selectedOptions[fieldPath] == option.value;

              return InputChipMedgo(
                selectedChip: selected,
                title: option.label ?? '',
                onSelected: (selected) {
                  setState(() {
                    selectedOptions[fieldPath] = option.value;
                    widget.onChange(
                      generateJson(),
                      field.flagged == true ? fieldPath : null,
                    );
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> generateJsonWithNulls() {
    Map<String, dynamic> resultMap = {};

    for (var response in widget.formResponse) {
      resultMap[response.backendAttribute!] =
          _generateFieldJsonWithNulls(response);
    }
    return resultMap;
  }

  Map<String, dynamic> _generateFieldJsonWithNulls(ResponseForm response) {
    Map<String, dynamic> objectJson = {};

    if (response.children != null) {
      for (var field in response.children!) {
        if (field.componentType == "short_text_field" ||
            field.componentType == "long_text_field" ||
            field.componentType == "selection_chips") {
          // Para campos de entrada ou seleção, defina o valor como null
          objectJson[field.backendAttribute!] = null;
        } else if (field.componentType == "object" ||
            field.componentType == "sub_section") {
          // Para objetos aninhados ou sub-seções, chame recursivamente
          objectJson[field.backendAttribute!] =
              _generateFieldJsonWithNulls(field);
        }
      }
    }
    return objectJson;
  }

  Map<String, dynamic> generateJson() {
    Map<String, dynamic> resultMap = {};

    for (var response in widget.formResponse) {
      resultMap[response.backendAttribute!] =
          generateFieldJson(response, response.backendAttribute!);
    }

    return resultMap;
  }

  Map<String, dynamic> generateFieldJson(ResponseForm response, String path) {
    Map<String, dynamic> objectJson = {};

    for (var field in response.children!) {
      String fieldPath = '$path.${field.backendAttribute!}';
      var fieldValue;

      if (field.componentType == "short_text_field") {
        if (field.inputType == 'int') {
          // Use CountInputController para campos de tipo 'int'
          var controller = countInputControllers[fieldPath];
          if (controller != null) {
            fieldValue = controller.value.toString();
          }
        } else {
          // Use TextEditingController para outros tipos
          var controller = textControllers[fieldPath];
          if (controller != null) {
            fieldValue = controller.text;
          }
        }

        if (fieldValue != null) {
          switch (field.inputType) {
            case 'int':
              objectJson[field.backendAttribute!] = int.tryParse(fieldValue);
              break;
            case 'double':
              // Substitua vírgulas por pontos antes de converter para double
              fieldValue = fieldValue.replaceAll(',', '.');
              objectJson[field.backendAttribute!] = double.tryParse(fieldValue);
              break;
            case 'date':
              objectJson[field.backendAttribute!] =
                  Helper.convertToDateString(fieldValue);
              break;
            case 'hour':
              objectJson[field.backendAttribute!] =
                  fieldValue.isEmpty ? null : fieldValue;
              break;
            case 'string':
            default:
              objectJson[field.backendAttribute!] =
                  fieldValue.isEmpty ? null : fieldValue;
          }
        }
      } else if (field.componentType == "long_text_field") {
        var controller = textControllers[fieldPath];
        if (controller != null) {
          fieldValue = controller.text;
        }

        if (fieldValue != null) {
          objectJson[field.backendAttribute!] =
              fieldValue.isEmpty ? null : fieldValue;
        }
      } else if (field.componentType == "selection_chips") {
        if (selectedOptions.containsKey(fieldPath)) {
          objectJson[field.backendAttribute!] = selectedOptions[fieldPath];
        }
      } else if (field.componentType == "object" ||
          field.componentType == "sub_section") {
        if (field.children != null) {
          objectJson[field.backendAttribute!] =
              generateFieldJson(field, fieldPath);
        }
      }
    }

    return objectJson;
  }

  bool evaluateVisibilityCondition(String? condition, String fieldPath) {
    if (condition == null || condition.isEmpty) {
      return true; // No condition means field is always visible
    }

    try {
      // Parse and evaluate visibility condition
      List<String> parts =
          condition.split(RegExp(r'\s+(?=(?:[^"]*"[^"]*")*[^"]*$)'));
      String left = parts[0].replaceAll(RegExp(r'^"|"$'), '');
      String right = parts[2].replaceAll(RegExp(r'^"|"$'), '');

      String? fieldData = getCurrentFormData()[left].toString();
      return fieldData == right;
    } catch (e) {
      print("Error evaluating condition: $e");
      return false;
    }
  }

  Map<String, dynamic> getCurrentFormData() {
    Map<String, dynamic> formData = {};

    // Adiciona valores de TextEditingController
    textControllers.forEach((key, controller) {
      formData[key] = controller.text;
    });

    // Adiciona valores de CountInputController
    countInputControllers.forEach((key, controller) {
      formData[key] = controller.value;
    });

    // Adiciona opções selecionadas
    selectedOptions.forEach((key, value) {
      formData[key] = value;
    });

    return formData;
  }

  @override
  void dispose() {
    scrollController.dispose();
    focusNodes.forEach((key, focusNode) {
      focusNode.dispose();
    });
    super.dispose();
  }
}

/// ScrollBehavior otimizado para web com suporte a eventos passivos
class _WebOptimizedScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // Desabilitar scrollbar padrão já que usamos CustomScrollbar
    return child;
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // Desabilitar overscroll glow na web para melhor performance
    if (kIsWeb) {
      return child;
    }
    return super.buildOverscrollIndicator(context, child, details);
  }
}
