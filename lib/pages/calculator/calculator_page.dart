// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:medgo/data/blocs/calculator/caclulator_bloc.dart';
import 'package:medgo/data/blocs/calculator/calculator_event.dart';
import 'package:medgo/data/blocs/calculator/calculator_state.dart';
import 'package:medgo/data/models/doctor_model.dart';
import 'package:medgo/pages/calculator/calculator_list/calculator_list_binding.dart';
import 'package:medgo/data/models/patients_model.dart';
import 'package:medgo/pages/prescription/modals/with_patient_calculator_modal.dart';
import 'package:medgo/strings/strings.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/dialogs/dialog.dart';
import 'package:medgo/widgets/dynamic_form/dynamic_form_screen.dart';
import 'package:medgo/widgets/dynamic_form/form_model.dart';

import 'package:go_router/go_router.dart';
import 'package:medgo/widgets/header_calculator/header_calculator.dart';
import 'package:medgo/widgets/news_widgets/buttons/primary_icon_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CalculatorPage extends StatefulWidget {
  final String calculatorType;
  const CalculatorPage({
    super.key,
    required this.calculatorType,
  });

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage>
    with SingleTickerProviderStateMixin {
  late final CalculatorBloc _calculatorBloc;
  String? calculatorId;
  List<String> allowedDiagnosesTypes = [];
  bool hasPrescription = false;
  DoctorModel? doctor;
  PatientsModel? patientData;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<ResponseForm>> forms =
      ValueNotifier<List<ResponseForm>>([]);
  late Map<String, dynamic> objectForm;
  final FocusNode _focusNode = FocusNode();
  Map<String, Map<String, String?>> validationErrors = {};

  final GlobalKey<DynamicFormState> _dynamicFormKey =
      GlobalKey<DynamicFormState>();

  // Adicione estas variáveis
  late AnimationController _menuController;
  late Animation<double> _menuAnimation;
  bool _isMenuExpanded = false;

  @override
  void initState() {
    super.initState();
    setUpCalculators();
    _calculatorBloc = GetIt.I<CalculatorBloc>();

    // Inicialize o controller de animação
    _menuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _menuAnimation = CurvedAnimation(
      parent: _menuController,
      curve: Curves.easeInOut,
    );

    _getForms();
    _listenEvents();
    _focusNode.requestFocus();
  }

  _getForms() {
    _calculatorBloc.add(
      InitConsultation(
        xCalculatorType: widget.calculatorType,
      ),
    );
  }

  _listenEvents() {
    _calculatorBloc.stream.listen((state) {
      if (state is CalculatorsLoading) {
        isLoading.value = true;
        setState(() {});
      } else if (state is CalculatorInitied) {
        isLoading.value = false;
        setState(() {
          forms.value = state.listForm.responseForm;
          calculatorId = state.listForm.id;
          allowedDiagnosesTypes = state.listForm.allowedDiagnosesTypes;
          hasPrescription = state.listForm.hasPrescription;
          doctor = state.listForm.doctor;
        });
      } else if (state is CalculatorsPatched) {
        isLoading.value = false;
      }
    });
  }

  _showPrescricao() async {
    // ignore: unused_local_variable
    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return WithPatientCalculatorModal(
          calculatorId: calculatorId!,
          doctor: doctor!,
        );
      },
    );
  }

  getPrescriptionBloc() {}

  _updateCalculator() {
    _calculatorBloc.add(PatchCalculator(
      calculator: objectForm,
      calculatorId: calculatorId!,
      xCalculatorType: widget.calculatorType,
    ));
  }

  _updateMinimized(objectUpdate) {}

  void _toggleMenu() {
    setState(() {
      _isMenuExpanded = !_isMenuExpanded;
      if (_isMenuExpanded) {
        _menuController.forward();
      } else {
        _menuController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryBackground,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Substitua o _buildMenuExpanded e _buildMenu por este widget
          AnimatedBuilder(
            animation: _menuAnimation,
            builder: (context, child) {
              const double maxWidth = 194.0;
              const double minWidth = 64.0;
              final double currentWidth =
                  minWidth + (_menuAnimation.value * (maxWidth - minWidth));

              return Container(
                width: currentWidth,
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: AppTheme.lightBackground,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: const Offset(1, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                child: OverflowBox(
                  maxWidth: maxWidth,
                  child: SizedBox(
                    width: maxWidth,
                    child:
                        _isMenuExpanded ? _buildMenuExpanded() : _buildMenu(),
                  ),
                ),
              );
            },
          ),
          Expanded(
            flex: 7,
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: forms,
                  builder: (context, snapshot) {
                    return forms.value.isNotEmpty
                        ? Expanded(
                            child: DynamicForm(
                              key: _dynamicFormKey,
                              formResponse: forms.value,
                              onChange: (value, backAttribute) {
                                objectForm = value;
                                if (backAttribute != null) {
                                  if (!validationErrors
                                      .containsKey(backAttribute)) {
                                    _updateCalculator();
                                    // Map<String, dynamic> partialData =
                                    //     extractAttributeByPath(
                                    //         objectForm, backAttribute);
                                    // _updateConsultationPartial(partialData);
                                  }
                                }
                              },
                              minimizedChange: (value) {
                                _updateMinimized(value);
                              },
                              onValidationStatusChanged: (errors) {
                                setState(() {
                                  validationErrors = errors;
                                });
                              },
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: calculatorId != null
                      ? HeaderCalculator(
                          calculatorId: calculatorId!,
                          calculatorBloc: _calculatorBloc,
                          reloadConsulta: getPrescriptionBloc,
                          reloadForm: _getForms,
                          allowedDiagnosesTypes: allowedDiagnosesTypes,
                        )
                      : const SizedBox.shrink(),
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenu() {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 20,
          maxWidth: 64, // Largura fixa para o menu colapsado
        ),
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => context.go('/home?tab=calculators'),
                    child: SvgPicture.asset(
                      Strings.logoSvg,
                    ),
                  ),
                ),
              ),
              // Divider
              Container(
                height: 2,
                width: 48,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: const Color(0xff0041554D).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Botão Voltar
              PrimaryIconButtonMedGo(
                leftIcon: Icon(
                  PhosphorIcons.caretLeft(
                    PhosphorIconsStyle.bold,
                  ),
                  size: 24,
                  color: AppTheme.warning,
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                onTap: () {
                  _saveForm();
                  context.go('/home?tab=calculators');
                },
              ),
              // Divider
              Container(
                height: 2,
                width: 48,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: const Color(0xff0041554D).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Botão Menu
              PrimaryIconButtonMedGo(
                leftIcon: Icon(
                  PhosphorIcons.list(
                    PhosphorIconsStyle.bold,
                  ),
                  size: 24,
                  color: AppTheme.primary,
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                onTap: _toggleMenu,
              ),
              // Loading Animation
              AnimatedBuilder(
                animation: isLoading,
                builder: (context, state) {
                  if (isLoading.value == false) {
                    return const SizedBox.shrink();
                  }
                  return Lottie.asset(
                    'assets/animations/looping.json',
                    repeat: true,
                    animate: true,
                    width: 80,
                    height: 80,
                  );
                },
              ),
              const Spacer(),
              // Botões do final
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PrimaryIconButtonMedGo(
                    leftIcon: Icon(
                      PhosphorIcons.broom(
                        PhosphorIconsStyle.bold,
                      ),
                      color: AppTheme.warning,
                      size: 24.0,
                    ),
                    onTap: () {
                      showTheDialog(
                        context: context,
                        title: "Limpar",
                        actionButtonText2: Strings.fechar,
                        onActionButtonPressed: () {
                          Navigator.of(context).pop(true);
                          _cleanedCalculation();
                        },
                        actionButtonText: 'Confirmar',
                        body: const Text(
                          "Tem certeza que deseja limpar os dados da calculadora?",
                        ),
                      );
                    },
                  ),
                  hasPrescription
                      ? Container(
                          height: 2,
                          width: 48,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            color: const Color(0xff0041554D).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        )
                      : const SizedBox.shrink(),
                  hasPrescription
                      ? PrimaryIconButtonMedGo(
                          leftIcon: Icon(
                            PhosphorIcons.prescription(
                              PhosphorIconsStyle.bold,
                            ),
                            size: 24,
                            color: AppTheme.salmon,
                            shadows: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          onTap: () {
                            _showPrescricao();
                          },
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Atualize o _buildMenuExpanded
  Widget _buildMenuExpanded() {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 20,
          maxWidth: 194,
        ),
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => context.go('/home?tab=calculators'),
                  child: SvgPicture.asset(
                    Strings.logoSvg,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 184,
                    child: PrimaryIconButtonMedGo(
                      leftIcon: Icon(
                        PhosphorIcons.caretLeft(
                          PhosphorIconsStyle.bold,
                        ),
                        size: 24,
                        color: AppTheme.warning,
                        shadows: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      onTap: () {
                        _saveForm();
                        context.go('/home?tab=calculators');
                      },
                      title: 'Voltar',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 184,
                    child: PrimaryIconButtonMedGo(
                      leftIcon: Icon(
                        PhosphorIcons.houseSimple(
                          PhosphorIconsStyle.bold,
                        ),
                        size: 24,
                        color: AppTheme.primary,
                        shadows: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      onTap: () {
                        _saveForm();
                        context.go('/home?tab=calculators');
                      },
                      title: 'Início',
                    ),
                  ),
                  Container(
                    height: 2,
                    width: 170,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: const Color(0xff0041554D).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(
                    width: 184,
                    child: PrimaryIconButtonMedGo(
                      leftIcon: Icon(
                        PhosphorIcons.caretLineLeft(
                          PhosphorIconsStyle.bold,
                        ),
                        size: 24,
                        color: AppTheme.primary,
                        shadows: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      onTap: _toggleMenu,
                      title: 'Colapsar',
                    ),
                  ),
                  AnimatedBuilder(
                    animation: isLoading,
                    builder: (context, state) {
                      if (isLoading.value == false) {
                        return const SizedBox.shrink();
                      }
                      return Lottie.asset(
                        'assets/animations/looping.json',
                        repeat: true,
                        animate: true,
                        width: 140,
                        height: 140,
                      );
                    },
                  ),
                ],
              ),
              const Spacer(),
              // Botões inferiores
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 184,
                    child: PrimaryIconButtonMedGo(
                      leftIcon: Icon(
                        PhosphorIcons.broom(
                          PhosphorIconsStyle.bold,
                        ),
                        color: AppTheme.warning,
                        size: 24.0,
                      ),
                      onTap: () {
                        showTheDialog(
                          context: context,
                          title: "Limpar",
                          actionButtonText2: Strings.fechar,
                          onActionButtonPressed: () {
                            Navigator.of(context).pop(true);
                            _cleanedCalculation();
                          },
                          actionButtonText: 'Confirmar',
                          body: const Text(
                            "Tem certeza que deseja limpar os dados da calculadora?",
                          ),
                        );
                      },
                      title: 'Limpar',
                    ),
                  ),
                  hasPrescription
                      ? Container(
                          height: 2,
                          width: 170,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            color: const Color(0xff0041554D).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        )
                      : const SizedBox.shrink(),
                  hasPrescription
                      ? SizedBox(
                          width: 184,
                          child: PrimaryIconButtonMedGo(
                            leftIcon: Icon(
                              PhosphorIcons.prescription(
                                PhosphorIconsStyle.bold,
                              ),
                              size: 24,
                              color: AppTheme.salmon,
                              shadows: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            onTap: () {
                              _showPrescricao();
                            },
                            title: 'Prescrever',
                          ),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveForm() {
    if (validationErrors.keys.isEmpty) {
      _updateCalculator();
    } else {
      // Construa uma string contendo todos os erros
      String errorDetails = validationErrors.entries.map((entry) {
        String? title = entry.value['title'];
        String? error = entry.value['error'];
        return '$title $error';
      }).join('\n');

      showTheDialog(
        context: context,
        title: "Erro de Validação",
        actionButtonText2: Strings.fechar,
        onActionButtonPressed: () {},
        body: Text(
          "Por favor, corrija os erros antes de salvar:\n\n$errorDetails",
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
  }

  Map<String, dynamic> extractBackAttribute(
      Map<String, dynamic> map, String backAttribute) {
    // Verifica se o atributo está presente no mapa
    if (map.containsKey(backAttribute)) {
      return {backAttribute: map[backAttribute]};
    }

    // Percorre os valores do mapa recursivamente para encontrar o atributo
    for (var key in map.keys) {
      var value = map[key];
      if (value is Map<String, dynamic>) {
        var result = extractBackAttribute(value, backAttribute);
        if (result.isNotEmpty) {
          return {key: result};
        }
      }
    }

    // Retorna um mapa vazio se o atributo não for encontrado
    return {};
  }

  Map<String, dynamic> extractAttributeByPath(
      Map<dynamic, dynamic> map, String path) {
    // Divide o caminho em partes
    List<String> keys = path.split('.');

    // Inicializa o mapa atual como o mapa de entrada
    var currentMap = map;
    Map<String, dynamic> result = {};

    // Referência para o mapa que será construído
    Map<String, dynamic> currentResult = result;

    // Percorre as chaves do caminho
    for (int i = 0; i < keys.length; i++) {
      String key = keys[i];

      // Verifica se o mapa atual contém a chave
      if (currentMap.containsKey(key)) {
        var value = currentMap[key];

        // Se for a última chave, adiciona o valor ao resultado
        if (i == keys.length - 1) {
          currentResult[key] = value;
        } else {
          // Se não for a última, prepara o próximo nível no resultado
          if (currentResult[key] == null) {
            currentResult[key] = <String, dynamic>{};
          }
          currentResult = currentResult[key] as Map<String, dynamic>;

          // Continua a busca no próximo nível do mapa
          if (value is Map) {
            currentMap = value;
          } else {
            return {};
          }
        }
      } else {
        return {};
      }
    }

    return result;
  }

  _cleanedCalculation() {
    if (_dynamicFormKey.currentState != null) {
      _calculatorBloc.add(CleanCalculator(
        calculatorId: calculatorId!,
      ));
    }
  }

  @override
  void dispose() {
    _menuController.dispose();
    super.dispose();
    _calculatorBloc.close();
  }
}
