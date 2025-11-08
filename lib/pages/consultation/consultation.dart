// ignore_for_file: use_build_context_synchronously, deprecated_member_use, use_full_hex_values_for_flutter_colors

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:medgo/data/blocs/acompanying/acompanying_bloc.dart';
import 'package:medgo/data/models/companion_model.dart';
import 'package:medgo/data/blocs/consultation/consultation_bloc.dart';
import 'package:medgo/data/blocs/consultation/consultation_event.dart';
import 'package:medgo/data/blocs/consultation/consultation_state.dart';
import 'package:medgo/data/models/consultation_model.dart';
import 'package:medgo/pages/consultation/consultation_binding.dart';
import 'package:medgo/pages/consultation/widgets/finalization.dart';
import 'package:medgo/pages/prescription/modals/with_patient_consultation_modal.dart';
import 'package:medgo/pages/patients/widgets/crud_patient_modal.dart';
import 'package:medgo/data/blocs/patients/patients_service_bloc.dart';
import 'package:medgo/data/blocs/patients/patients_service_event.dart';
import 'package:medgo/data/blocs/patients/patients_service_state.dart';
import 'package:medgo/data/models/patients_model.dart';
import 'package:medgo/strings/strings.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/dialogs/dialog.dart';
import 'package:medgo/widgets/dialogs/loading_dialog.dart';
import 'package:medgo/widgets/dynamic_form/dynamic_form_screen.dart';
import 'package:medgo/widgets/dynamic_form/form_model.dart';
import 'package:medgo/widgets/header/header_feedback.dart';
import 'package:medgo/widgets/news_widgets/buttons/primary_icon_button.dart';
import 'package:medgo/widgets/news_widgets/buttons/tertiary_icon_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../widgets/header/header_pacient.dart';
import 'package:go_router/go_router.dart';

class ConsultationPage extends StatefulWidget {
  final String patientId;
  final String consultationId;

  const ConsultationPage({
    super.key,
    required this.patientId,
    required this.consultationId,
  });

  @override
  State<ConsultationPage> createState() => _ConsultationPageState();
}

class _ConsultationPageState extends State<ConsultationPage>
    with SingleTickerProviderStateMixin {
  late final List<CompanionModel> companions;
  late final ConsultationBloc _consultationsBloc;
  late final PatientsBloc _patientsBloc;
  late final CompanionBloc _companionsBloc;
  ConsultationModel? consultationData;
  PatientsModel? patientData;
  late bool _finishConsultation = false;
  late bool _voltarConsultation = false;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<ResponseForm>> forms =
      ValueNotifier<List<ResponseForm>>([]);
  late Map<String, dynamic> objectForm;
  final FocusNode _focusNode = FocusNode();
  Map<String, Map<String, String?>> validationErrors = {};

  // Adicione estas variáveis
  late AnimationController _menuController;
  late Animation<double> _menuAnimation;
  bool _isMenuExpanded = false;

  @override
  void initState() {
    super.initState();
    setUpConsultation();
    _consultationsBloc = GetIt.I<ConsultationBloc>();
    _patientsBloc = GetIt.I<PatientsBloc>();
    _companionsBloc = GetIt.I<CompanionBloc>();

    _listenEvents();
    _getPaciente();
    _getConsultationById();
    _getForms();
    _focusNode.requestFocus();

    // Inicialize o controller de animação
    _menuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _menuAnimation = CurvedAnimation(
      parent: _menuController,
      curve: Curves.easeInOut,
    );
  }

  _getConsultationById() {
    _consultationsBloc
        .add(GetConsultationById(idConsultation: widget.consultationId));
  }

  _getPaciente() {
    _patientsBloc.add(
      GetPatient(id: widget.patientId),
    );
  }

  getBloc() {
    if (mounted) {
      getPrescriptionBloc();
    }
  }

  _getForms() {
    _consultationsBloc.add(
      GetConsultationForm(
        idConsultation: widget.consultationId,
      ),
    );
  }

  _listenEvents() {
    _consultationsBloc.stream.listen((state) {
      if (state is ConsultationLoading) {
        isLoading.value = true;
      } else if (state is ConsultationByIdLoaded) {
        isLoading.value = false;
        consultationData = state.consultation;
        setState(() {});
      } else if (state is ConsultationPatched) {
        isLoading.value = false;
        if (_finishConsultation) {
          _showFinalizar();
          _finishConsultation = false;
        }
      } else if (state is ConsultationDeleted) {
        isLoading.value = false;
        context.go('/home');
      } else if (state is ConsultationFormLoaded) {
        isLoading.value = false;
        setState(() {
          forms.value = state.form;
        });
      } else if (state is ConsultationFinished) {
        isLoading.value = false;
        context.go('/home');
      } else if (state is ConsultationReportLoaded) {
        isLoading.value = false;
        Navigator.of(context).pop(true);
      } else if (state is ConsultationError) {
        isLoading.value = false;
        if (_voltarConsultation) {
          Navigator.of(context).pop(true);
        }
        showTheDialog(
          context: context,
          title: "Erro!",
          actionButtonText2: Strings.fechar,
          onActionButtonPressed: () {},
          body: Text(
            state.e.toString(),
            style: const TextStyle(color: Colors.red),
          ),
        );
      }
    });

    _patientsBloc.stream.listen((state) {
      if (state is PatientsLoading) {
        shoLoadingDialog(context: context, barriedDismissible: false);
      } else if (state is PatientLoaded) {
        Navigator.of(context).pop();
        setState(() {
          patientData = state.patient;
        });
      }
    });
  }

  _showEditPatients(PatientsModel patient) async {
    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CrudPatientModal(
          patient: patient,
        );
      },
    );

    if (result) {
      _getPaciente();
    }
  }

  _showPrescricao() async {
    // ignore: unused_local_variable
    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return WithPatientConsultationModal(
          consultationId: widget.consultationId,
          patient: patientData!,
          doctor: consultationData!.doctor!,
          peso: objectForm['physicalExamData']['weight'].toString(),
        );
      },
    );
  }

  _showFinalizar() async {
    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return FinalizationModal(
          consultation: consultationData!,
        );
      },
    );

    if (result == true) {
      _finishedConsultation();
    }
  }

  getPrescriptionBloc() {
    _consultationsBloc.add(GetConsultationReport(
      idConsultation: widget.consultationId,
    ));
  }

  _updateConsultation() {
    _consultationsBloc.add(PatchConsultation(
      consultation: objectForm,
      consultationId: consultationData!.id!,
    ));
  }

  // _updateConsultationPartial(objectUpdate) {
  //   _consultationsBloc.add(PatchPartialConsultation(
  //     consultation: consultationData,
  //     objectUpdate: objectUpdate,
  //   ));
  // }

  _updateMinimized(objectUpdate) {
    _consultationsBloc.add(PatchMinimizedConsultation(
      consultation: consultationData!,
      objectUpdate: objectUpdate,
    ));
  }

  _finishedConsultation() {
    _consultationsBloc.add(FinishConsultation(
      consultation: consultationData!,
    ));
  }

  _deletedConsultation() {
    _consultationsBloc
        .add(DeleteConsultation(consultationId: consultationData!.id!));
  }

  // Função para alternar o menu
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
            child: Stack(
              children: [
                Column(
                  children: [
                    AnimatedBuilder(
                      animation: forms,
                      builder: (context, snapshot) {
                        return forms.value.isNotEmpty
                            ? Expanded(
                                child: RepaintBoundary(
                                  child: DynamicForm(
                                    trackMarginScroll: const EdgeInsets.only(
                                      top: 90,
                                    ),
                                    formResponse: forms.value,
                                    onChange: (value, backAttribute) {
                                      objectForm = value;
                                      if (backAttribute != null) {
                                        if (!validationErrors
                                            .containsKey(backAttribute)) {
                                          _updateConsultation();
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
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: ClipRRect(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: kIsWeb
                        ? Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppTheme.secondaryBackground.withOpacity(1),
                                  AppTheme.secondaryBackground.withOpacity(0.7),
                                  AppTheme.secondaryBackground.withOpacity(0.0),
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: HeaderPaciente(
                              patient: patientData,
                              onPressed: () {
                                _showEditPatients(patientData!);
                              },
                            ),
                          )
                        : BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppTheme.secondaryBackground.withOpacity(1),
                                    AppTheme.secondaryBackground
                                        .withOpacity(0.7),
                                    AppTheme.secondaryBackground
                                        .withOpacity(0.0),
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: HeaderPaciente(
                                patient: patientData,
                                onPressed: () {
                                  _showEditPatients(patientData!);
                                },
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  bottom: 8.0,
                  right: 8.0,
                ),
                child: consultationData != null
                    ? HeaderFeedBack(
                        consultationId: widget.consultationId,
                        patient: patientData,
                        patientId: widget.patientId,
                        companions: consultationData!.companions,
                        companionsBloc: _companionsBloc,
                        dadosFeedback: const [],
                        patientBloc: _patientsBloc,
                        reloadConsulta: getPrescriptionBloc,
                        reloadForm: _getForms,
                      )
                    : const SizedBox.shrink(),
              )
            ]),
          ),
        ],
      ),
    );
  }

  // Atualize o _buildMenu
  Widget _buildMenu() {
    return SingleChildScrollView(
      // Otimizar physics para web
      physics: kIsWeb
          ? const ClampingScrollPhysics()
          : const AlwaysScrollableScrollPhysics(),
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
                    onTap: () => context.go('/home'),
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
                  _voltarConsultation = true;
                  _saveForm();
                  context.go('/home');
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
                      PhosphorIcons.floppyDisk(
                        PhosphorIconsStyle.bold,
                      ),
                      size: 24,
                      color: AppTheme.success,
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
                    },
                  ),
                  Container(
                    height: 2,
                    width: 48,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: const Color(0xff0041554D).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  PrimaryIconButtonMedGo(
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
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TertiaryIconButtonMedGo(
                    leftIcon: Icon(
                      PhosphorIcons.checkCircle(
                        PhosphorIconsStyle.bold,
                      ),
                      size: 24,
                      color: AppTheme.success,
                      shadows: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    onTap: () {
                      _finishConsultation = true;
                      _saveForm();
                    },
                  ),
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
      // Otimizar physics para web
      physics: kIsWeb
          ? const ClampingScrollPhysics()
          : const AlwaysScrollableScrollPhysics(),
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
                  onTap: () => context.go('/home'),
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
                        _voltarConsultation = true;
                        _saveForm();
                        context.go('/home');
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
                        _voltarConsultation = true;
                        _saveForm();
                        context.go('/home');
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
                        PhosphorIcons.trash(
                          PhosphorIconsStyle.bold,
                        ),
                        size: 24,
                        color: AppTheme.error,
                        shadows: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      onTap: () {
                        showTheDialog(
                          context: context,
                          title: "Cancelar",
                          actionButtonText2: Strings.fechar,
                          onActionButtonPressed: () {
                            Navigator.of(context).pop(true);
                            _deletedConsultation();
                          },
                          actionButtonText: 'Confirmar',
                          body: const Text(
                            "Tem certeza que deseja cancelar essa consulta?",
                          ),
                        );
                      },
                      title: 'Cancelar',
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
                        PhosphorIcons.arrowCounterClockwise(
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
                        _getForms();
                      },
                      title: 'Atualizar',
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: 184,
                    child: PrimaryIconButtonMedGo(
                      leftIcon: Icon(
                        PhosphorIcons.floppyDisk(
                          PhosphorIconsStyle.bold,
                        ),
                        size: 24,
                        color: AppTheme.success,
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
                      },
                      title: 'Salvar',
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
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: 184,
                    child: TertiaryIconButtonMedGo(
                      leftIcon: Icon(
                        PhosphorIcons.checkCircle(
                          PhosphorIconsStyle.bold,
                        ),
                        size: 24,
                        color: AppTheme.success,
                        shadows: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      onTap: () {
                        _finishConsultation = true;
                        _saveForm();
                      },
                      title: 'Finalizar Consulta',
                    ),
                  ),
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
      _updateConsultation();
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

  @override
  void dispose() {
    _menuController.dispose();
    super.dispose();
    _consultationsBloc.close();
    _patientsBloc.close();
  }
}
