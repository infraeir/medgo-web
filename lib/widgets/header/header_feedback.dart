// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:medgo/data/blocs/acompanying/acompanying_bloc.dart';
import 'package:medgo/data/blocs/acompanying/acompanying_event.dart';
import 'package:medgo/data/blocs/patients/patients_service_bloc.dart';
import 'package:medgo/data/blocs/patients/patients_service_event.dart';
import 'package:medgo/data/blocs/patients/patients_service_state.dart';
import 'package:medgo/helper/helper.dart';
import 'package:medgo/data/models/companion_model.dart';
import 'package:medgo/pages/acompanying/widgets/acompanying_modal.dart';
import 'package:medgo/data/models/consultation_socket_model.dart';
import 'package:medgo/data/models/patients_model.dart';
import 'package:medgo/data/socket/socket_manager.dart';
import 'package:medgo/strings/strings.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/themes/app_theme_spacing.dart';
import 'package:medgo/widgets/news_widgets/icon_button.dart';
import 'package:medgo/widgets/scrollbar/custom_scroll_bar.dart';
import 'package:medgo/widgets/header/header_feedback_accompanying.dart';
import 'package:medgo/widgets/header/header_feedback_confirmados.dart';
import 'package:medgo/widgets/header/header_feedback_hipoteses.dart';
import 'package:medgo/widgets/header/header_feedback_model.dart';
import 'package:medgo/widgets/header/header_feedback_sugestoes.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeaderFeedBack extends StatefulWidget {
  final String consultationId;
  final String patientId;
  final PatientsModel? patient;
  final List<CompanionModel> companions;
  final List<HeaderFeedbackModel> dadosFeedback;
  final PatientsBloc patientBloc;
  final CompanionBloc companionsBloc;
  final VoidCallback reloadConsulta;
  final VoidCallback reloadForm;
  const HeaderFeedBack({
    super.key,
    required this.consultationId,
    required this.patientId,
    this.patient,
    required this.companions,
    required this.companionsBloc,
    required this.dadosFeedback,
    required this.reloadConsulta,
    required this.reloadForm,
    required this.patientBloc,
  });

  @override
  State<HeaderFeedBack> createState() => _HeaderFeedBackState();
}

class _HeaderFeedBackState extends State<HeaderFeedBack> {
  late SocketManager socketManager;
  late ScrollController scrollController;
  bool hasSuggestions = false;
  ConsultationSocketModel? consultationModel;
  bool mostrarElementos = false;
  bool hasNewCompanion = false;
  List<CompanionModel> allCompanions = [];
  List<String> selectedCompanions = [];

  String concatenatedText = '';

  @override
  void initState() {
    super.initState();
    socketManager = SocketManager.getInstance();
    openSocketConnections();
    scrollController = ScrollController();
    consultationModel = ConsultationSocketModel(
        suggestions: [], consultationId: widget.consultationId);

    setState(() {
      for (var comp in widget.companions) {
        selectedCompanions.add(comp.id);
      }
    });

    _listenEvents();
    getPaciente();
  }

  getPaciente() {
    widget.patientBloc.add(
      GetPatient(
        id: widget.patientId,
      ),
    );
  }

  patchCompanion(String companionID) {
    widget.companionsBloc.add(
      PatchtExtraCompanion(
        consultationsID: widget.consultationId,
        companionID: companionID,
      ),
    );
  }

  deleteCompanion(String companionID) {
    widget.companionsBloc.add(
      DeleteExtraCompanion(
        consultationsID: widget.consultationId,
        companionID: companionID,
      ),
    );
  }

  void _listenEvents() {
    widget.patientBloc.stream.listen((state) {
      if (state is PatientLoaded) {
        setState(() {
          allCompanions = state.patient.companions;
        });
      }
    });
  }

  void updateSuggestions(ConsultationSocketModel suggestions) {
    if (mounted) {
      setState(() {
        consultationModel = suggestions;
      });
    }
  }

  void reloadForm() {
    if (mounted) {
      widget.reloadForm();
    }
  }

  Future<void> openSocketConnections() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    openDiagnosesConnection(token);
    openConsultationConnection(token);
  }

  void openDiagnosesConnection(String token) {
    final fullPath = "diagnoses?consultationId=${widget.consultationId}";
    const event = 'diagnoses_updated';
    socketManager.connect(
      fullPath,
      event,
      token,
      (eventData) {
        print("Recebidas novas sugestões de diagnóstico: $eventData");
        updateSuggestions(ConsultationSocketModel.fromJson(eventData['data']));
      },
    );
  }

  void openConsultationConnection(String token) {
    final fullPathConsultation =
        "consultations?consultationId=${widget.consultationId}";
    const eventConsultation = 'update_consultation_dynamic_form';
    socketManager.connect(
      fullPathConsultation,
      eventConsultation,
      token,
      (eventData) {
        print("Recebida atualização do formulário dinâmico: $eventData");
        reloadForm();
      },
    );
  }

  Future<void> acceptSocketConnection(String diagnosisID) async {
    final Map<String, String> payload = {
      "diagnosisId": diagnosisID,
    };

    socketManager.notifyServerWith('accept_diagnosis_suggestion', payload);
  }

  Future<void> rejectSocketConnection(String diagnosisID) async {
    final Map<String, String> payload = {
      "diagnosisId": diagnosisID,
    };

    socketManager.notifyServerWith('reject_diagnosis_suggestion', payload);
  }

  Future<void> updateConductSocketConnection(
      String conductID, bool accept) async {
    final Map<String, dynamic> payload = {
      "conductId": conductID,
      "isAccepted": accept
    };

    socketManager.notifyServerWith('update_conduct_status', payload);
  }

  String _getDateConsultation() {
    final lastConsultation = widget.patient?.lastConsultationData;
    if (lastConsultation == null) {
      return 'N/A';
    }
    if (lastConsultation.createdAt == 'N/A') {
      return 'N/A';
    }
    return Helper.getData(lastConsultation.createdAt.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.98,
      decoration: BoxDecoration(
        color: AppTheme.lightBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.theme.primaryColor.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomScrollbar(
              controller: scrollController,
              trackMargin: const EdgeInsets.only(
                top: 40,
              ),
              child: Builder(
                builder: (context) => ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      scrollbars: false,
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 18.0, top: 8, bottom: 8, left: 8),
                        child: Column(
                          children: [
                            Container(
                                margin: const EdgeInsets.only(
                                    left: 8.0, right: 8.0, top: 40),
                                padding: const EdgeInsets.only(
                                    top: 10.0,
                                    left: 14.0,
                                    right: 14.0,
                                    bottom: 10.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey
                                          .withOpacity(0.5), // Cor da sombra
                                      spreadRadius:
                                          2, // Quão espalhada a sombra será
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: AppThemeSpacing.quatorze),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            Strings.acompanhante_s,
                                            style: TextStyle(
                                                color:
                                                    AppTheme.theme.primaryColor,
                                                fontSize:
                                                    AppThemeSpacing.dezesseis,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              CustomIconButtonMedGo(
                                                onPressed: () {
                                                  setState(() {
                                                    mostrarElementos =
                                                        !mostrarElementos;
                                                  });
                                                },
                                                icon: Icon(
                                                  mostrarElementos
                                                      ? PhosphorIcons
                                                          .arrowsInLineVertical(
                                                          PhosphorIconsStyle
                                                              .bold,
                                                        )
                                                      : PhosphorIcons
                                                          .arrowsOutLineVertical(
                                                          PhosphorIconsStyle
                                                              .bold,
                                                        ),
                                                  color: AppTheme
                                                      .theme.primaryColor,
                                                  shadows: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(
                                                              0.5), // Cor da sombra
                                                      spreadRadius: 3,
                                                      blurRadius: 5,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              CustomIconButtonMedGo(
                                                onPressed: () async {
                                                  var result = await showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return CompanionModal(
                                                        patient:
                                                            widget.patient!,
                                                        consultationID: widget
                                                            .consultationId,
                                                        companionsUpdated:
                                                            (companionsList) {
                                                          if (companionsList!
                                                              .isNotEmpty) {
                                                            for (var cpn
                                                                in companionsList) {
                                                              if (!selectedCompanions
                                                                  .contains(
                                                                      cpn)) {
                                                                selectedCompanions
                                                                    .add(
                                                                        cpn.id);
                                                              }
                                                            }
                                                          }
                                                        },
                                                      );
                                                    },
                                                  );

                                                  if (result != null) {
                                                    getPaciente();
                                                  }
                                                },
                                                icon: Icon(
                                                  PhosphorIcons.userCirclePlus(
                                                    PhosphorIconsStyle.bold,
                                                  ),
                                                  color: AppTheme
                                                      .theme.primaryColor,
                                                  shadows: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(
                                                              0.5), // Cor da sombra
                                                      spreadRadius: 3,
                                                      blurRadius: 5,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            AppThemeSpacing.oito),
                                      ),
                                      child: Column(
                                        children: [
                                          ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: allCompanions.length,
                                            itemBuilder: (context, index) {
                                              CompanionModel companion =
                                                  allCompanions[index];

                                              if (mostrarElementos) {
                                                return Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10.0),
                                                  child:
                                                      HeaderFeedbackAccompanying(
                                                    companionName:
                                                        '${companion.name}, ${Helper.getRelationship(companion.relationship)}',
                                                    didTap: (value) async {
                                                      if (value) {
                                                        var result =
                                                            await showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return CompanionModal(
                                                              patient: widget
                                                                  .patient!,
                                                              consultationID: widget
                                                                  .consultationId,
                                                              companion:
                                                                  companion,
                                                              companionsUpdated:
                                                                  (companionsList) {
                                                                if (companionsList!
                                                                    .isNotEmpty) {
                                                                  for (var cpn
                                                                      in companionsList) {
                                                                    if (!selectedCompanions
                                                                        .contains(
                                                                            cpn)) {
                                                                      selectedCompanions
                                                                          .add(cpn
                                                                              .id);
                                                                    }
                                                                  }
                                                                }
                                                              },
                                                            );
                                                          },
                                                        );

                                                        if (result != null) {
                                                          getPaciente();
                                                        }
                                                      } else {
                                                        if (selectedCompanions
                                                            .contains(
                                                                companion.id)) {
                                                          selectedCompanions
                                                              .remove(
                                                                  companion.id);
                                                          deleteCompanion(
                                                              companion.id);
                                                        } else {
                                                          selectedCompanions
                                                              .add(
                                                                  companion.id);
                                                          patchCompanion(
                                                              companion.id);
                                                        }
                                                        setState(() {});
                                                      }
                                                    },
                                                    selected: selectedCompanions
                                                        .contains(companion.id),
                                                  ),
                                                );
                                              } else {
                                                if (selectedCompanions
                                                    .contains(companion.id)) {
                                                  return Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10.0),
                                                    child:
                                                        HeaderFeedbackAccompanying(
                                                      companionName:
                                                          '${companion.name}, ${Helper.getRelationship(companion.relationship)}',
                                                      didTap: (value) async {
                                                        if (value) {
                                                          var result =
                                                              await showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return CompanionModal(
                                                                patient: widget
                                                                    .patient!,
                                                                consultationID:
                                                                    widget
                                                                        .consultationId,
                                                                companion:
                                                                    companion,
                                                                companionsUpdated:
                                                                    (companionsList) {
                                                                  if (companionsList!
                                                                      .isNotEmpty) {
                                                                    for (var cpn
                                                                        in companionsList) {
                                                                      if (!selectedCompanions
                                                                          .contains(
                                                                              cpn)) {
                                                                        selectedCompanions
                                                                            .add(cpn.id);
                                                                      }
                                                                    }
                                                                  }
                                                                },
                                                              );
                                                            },
                                                          );

                                                          if (result != null) {
                                                            getPaciente();
                                                          }
                                                        } else {
                                                          if (selectedCompanions
                                                              .contains(
                                                                  companion
                                                                      .id)) {
                                                            selectedCompanions
                                                                .remove(
                                                                    companion
                                                                        .id);
                                                            deleteCompanion(
                                                                companion.id);
                                                          } else {
                                                            selectedCompanions
                                                                .add(companion
                                                                    .id);
                                                            patchCompanion(
                                                                companion.id);
                                                          }
                                                          setState(() {});
                                                        }
                                                      },
                                                      selected:
                                                          selectedCompanions
                                                              .contains(
                                                                  companion.id),
                                                    ),
                                                  );
                                                } else {
                                                  return const SizedBox
                                                      .shrink();
                                                }
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Container(
                                    //   decoration: BoxDecoration(
                                    //     color: Colors.white,
                                    //     borderRadius:
                                    //         BorderRadius.circular(AppThemeSpacing.oito),
                                    //   ),
                                    //   child: Column(
                                    //     children: [
                                    //       HeaderFeedbackAccompanying(
                                    //         companionName: widget.companion.name,
                                    //       ),
                                    //       const SizedBox(
                                    //         height: AppThemeSpacing.dez,
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                )),
                            const SizedBox(
                              height: AppThemeSpacing.dez,
                            ),
                            HeaderFeedbackSugestoesWidget(
                              suggestionModel: consultationModel,
                              accept: (id) {
                                acceptSocketConnection(id);
                              },
                            ),
                            const SizedBox(
                              height: AppThemeSpacing.dez,
                            ),
                            HeaderFeedbackHipotesesWidget(
                              hyphoteseModel: consultationModel,
                              reject: (id) {
                                rejectSocketConnection(id);
                              },
                              updateConduct: (id, accept) {
                                updateConductSocketConnection(id, accept);
                              },
                            ),
                            const SizedBox(
                              height: AppThemeSpacing.dez,
                            ),
                            HeaderFeedbackConfirmadoWidget(
                              confirmedModel: consultationModel,
                              updateConduct: (id, accept) {
                                updateConductSocketConnection(id, accept);
                              },
                            ),
                            const SizedBox(
                              height: AppThemeSpacing.dez,
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  padding: const EdgeInsets.all(
                    4,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.lightBackground.withOpacity(1),
                        AppTheme.lightBackground.withOpacity(0.7),
                        AppTheme.lightBackground.withOpacity(0.0),
                      ],
                      stops: const [
                        0.0,
                        0.5,
                        1.0
                      ], // Define os pontos de transição
                    ),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.01),
                        blurRadius: 1,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppThemeSpacing.dezesseis,
                      vertical: AppThemeSpacing.seis,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              PhosphorIcons.listChecks(
                                PhosphorIconsStyle.bold,
                              ),
                              size: 18,
                              color: AppTheme.secondaryText,
                              shadows: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 1.5,
                                  offset: const Offset(-0.25, 1),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Painel de feedback",
                              style: TextStyle(
                                color: AppTheme.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                shadows: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.date_range_outlined,
                              color: AppTheme.secondaryText,
                              size: 18,
                              shadows: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 1.5,
                                  offset: const Offset(-0.25, 1),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "${Strings.ultimaConsulta}: ${_getDateConsultation()}",
                              style: TextStyle(
                                color: AppTheme.secondaryText,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                shadows: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
