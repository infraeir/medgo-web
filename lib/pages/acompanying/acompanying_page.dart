// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:medgo/data/blocs/consultation/consultation_bloc.dart';
import 'package:medgo/data/blocs/consultation/consultation_event.dart';
import 'package:medgo/data/blocs/consultation/consultation_state.dart';
import 'package:medgo/helper/helper.dart';
import 'package:medgo/data/models/companion_model.dart';
import 'package:medgo/pages/acompanying/companion_binding.dart';
import 'package:medgo/pages/acompanying/widgets/acompanying_modal.dart';
import 'package:medgo/data/providers/logout_service.dart';
import 'package:medgo/data/blocs/patients/patients_service_bloc.dart';
import 'package:medgo/data/blocs/patients/patients_service_event.dart';
import 'package:medgo/data/blocs/patients/patients_service_state.dart';
import 'package:medgo/data/models/patients_model.dart';
import 'package:medgo/pages/home/widgets/app_bar_home.dart';
import 'package:medgo/pages/patients/widgets/responsive_table.dart';
import 'package:medgo/strings/strings.dart';
import 'package:medgo/widgets/news_widgets/buttons/primary_icon_button.dart';
import 'package:medgo/widgets/news_widgets/icon_button.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/dialogs/dialog.dart';
import 'package:medgo/widgets/dialogs/loading_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AcompanyingData extends StatefulWidget {
  final String patientId;

  const AcompanyingData({
    super.key,
    required this.patientId,
  });

  @override
  State<AcompanyingData> createState() => _AcompanyingDataState();
}

class _AcompanyingDataState extends State<AcompanyingData> {
  TextEditingController sexoController = TextEditingController();
  late final PatientsBloc _patientsBloc;
  late final ConsultationBloc _consultationsBloc;
  final List<String> _checkedItems = [];
  late List<CompanionModel> _companionsSelecionados = [];
  PatientsModel? patient;

  @override
  void initState() {
    super.initState();
    setUpCompanion();
    _patientsBloc = GetIt.I<PatientsBloc>();
    _consultationsBloc = GetIt.I<ConsultationBloc>();
    getPaciente();
    _listenEvents();
  }

  getPaciente() {
    _patientsBloc.add(
      GetPatient(id: widget.patientId),
    );
  }

  postConsultation(List<CompanionModel> companions) {
    _consultationsBloc.add(PostConsultation(
      patient: patient!,
      companions: companions,
    ));
  }

  _showEditComnpanion(CompanionModel companion) async {
    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CompanionModal(
          patient: patient!,
          companion: companion,
          companionsUpdated: (_) {},
        );
      },
    );

    if (result != null) {
      getPaciente();
    }
  }

  void _listenEvents() {
    _consultationsBloc.stream.listen((state) {
      if (state is ConsultationLoading) {
        if (_companionsSelecionados.isNotEmpty) {
          shoLoadingDialog(context: context, barriedDismissible: false);
        }
      } else if (state is ConsultationPosted) {
        Navigator.of(context).pop();
        _navigationConsult(state.consultation.id!);
      } else if (state is ConsultationError) {
        Navigator.of(context).pop();

        String errorMessage = state.e.toString();

        showTheDialog(
          context: context,
          title: "Erro!",
          actionButtonText2: Strings.fechar,
          onActionButtonPressed: () {},
          body: Text(
            errorMessage,
            style: const TextStyle(color: Colors.red),
          ),
        );
      }
    });

    _patientsBloc.stream.listen((state) {
      if (state is PatientLoaded) {
        patient = state.patient;
        setState(() {});
      }
    });
  }

  _navigationConsult(String consultationId) async {
    context.go(
      '/consultation/${patient?.id}/$consultationId/',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryBackground,
      body: Column(
        children: [
          AppBarHome(
            onLogout: () async {
              await postLogout();
              if (mounted) {
                context.go('/signin');
              }
            },
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrimaryIconButtonMedGo(
                  title: 'Voltar',
                  leftIcon: Icon(
                    PhosphorIcons.caretLeft(
                      PhosphorIconsStyle.bold,
                    ),
                    color: AppTheme.warning,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 3),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  onTap: () {
                    context.go('/home');
                  },
                ),
                Column(
                  children: [
                    // ignore: prefer_if_null_operators
                    Text('${Strings.quemAcompanha} ${patient?.name ?? ''}?',
                        style: AppTheme.h5(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(
                      Strings.selecioneCadastreAcompanhante,
                      style: AppTheme.h5(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    )
                  ],
                ),
                PrimaryIconButtonMedGo(
                  onTap: () async {
                    var result = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CompanionModal(
                          patient: patient!,
                          companionsUpdated: (_) {},
                        );
                      },
                    );

                    if (result != null) {
                      getPaciente();
                    }
                  },
                  title: Strings.novoAcompanhante,
                  rightIcon: Icon(
                    Icons.add_circle_outline_rounded,
                    color: AppTheme.theme.primaryColor,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 3),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Row(
              children: [
                Text(
                  Strings.acompanhantes,
                  style: AppTheme.h3(
                    color: AppTheme.theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<PatientsBloc, PatientsState>(
              bloc: _patientsBloc,
              builder: (context, state) {
                if (state is PatientLoaded || state is PatientsLoading) {
                  if (state is PatientLoaded) {
                    return _buildTable(state.patient, state is PatientsLoading);
                  }
                  return _buildTable(null, state is PatientsLoading);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(PatientsModel? patient, bool isLoading) {
    List<CompanionModel> companions = patient?.companions ?? [];
    if (patient != null) {
      if (patient.companions.isEmpty) {
        return SizedBox(
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "images/image_empty.svg",
                height: 200,
              ),
              const SizedBox(height: 10),
              Text(
                Strings.nenhumAcompanhanteEncontrado,
                style: AppTheme.h3(
                    color: Colors.black, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      }
    }

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              right: 28,
              left: 28,
              bottom: 10,
            ),
            child: ResponsiveTable(
              title: Strings.acompanhantes,
              isLoading: isLoading,
              headerCells: [
                Container(
                  margin: const EdgeInsets.only(left: 70),
                  child: Text("Nome",
                      style: AppTheme.h5(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryText,
                      )),
                ),
                Text("Filiação",
                    style: AppTheme.h5(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryText,
                    )),
                Text("Sexo",
                    style: AppTheme.h5(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryText,
                    )),
                Text("Última consulta",
                    style: AppTheme.h5(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryText,
                    )),
              ],
              bodyCells: companions.map((companion) {
                return [
                  Row(
                    children: [
                      Checkbox(
                        activeColor: AppTheme.theme.primaryColor,
                        value: _checkedItems.contains(companion.id),
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              _checkedItems.add(companion.id);
                            } else {
                              _checkedItems.remove(companion.id);
                            }
                          });
                        },
                      ),
                      CustomIconButtonMedGo(
                        icon: Icon(
                          PhosphorIcons.pencilSimple(
                            PhosphorIconsStyle.bold,
                          ),
                          color: AppTheme.theme.primaryColor,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 3),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        onPressed: () => _showEditComnpanion(companion),
                      ),
                      Expanded(
                        child: Text(
                          companion.name.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Text(
                      getFiliacao(
                        companion.relationship.toString(),
                      ),
                    ),
                  ),
                  Text(companion.gender == 'male'
                      ? Strings.masculino
                      : Strings.feminino),
                  Text(
                    patient?.lastConsultationData.createdAt != 'N/A'
                        ? Helper.getData(
                            patient!.lastConsultationData.createdAt.toString())
                        : patient!.lastConsultationData.createdAt,
                  ),
                ];
              }).toList(),
              columnFlex: const [2, 2, 2, 2],
              footerText: companions.isEmpty
                  ? 'Nenhum acompanhante encontrado'
                  : '${companions.length} ${companions.length == 1 ? 'acompanhante encontrado' : 'acompanhantes encontrados'}',
              isEmpty: companions.isEmpty,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 28),
              child: PrimaryIconButtonMedGo(
                onTap: () async {
                  getCompanions(companions);
                },
                title: Strings.prosseguir,
                rightIcon: Icon(
                  PhosphorIcons.caretRight(
                    PhosphorIconsStyle.bold,
                  ),
                  color: AppTheme.success,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0, 3),
                      blurRadius: 5,
                    ),
                  ],
                ),
                isDisabled: _checkedItems.isEmpty,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  getCompanions(List<CompanionModel> companions) {
    List<CompanionModel> matchingCompanions = [];

    for (var checkedId in _checkedItems) {
      var companionWithId = companions.firstWhere(
        (companion) => companion.id == checkedId,
      );

      matchingCompanions.add(companionWithId);
    }

    _companionsSelecionados = matchingCompanions;
    postConsultation(matchingCompanions);
  }

  String getFiliacao(String name) {
    switch (name) {
      case 'father':
        return 'Pai';
      case 'mother':
        return 'Mãe';
      case 'uncle':
        return 'Tio/Tia';
      case 'godfather':
        return 'Padrinho';
      case 'family_friend':
        return 'Amigo';
      default:
        return 'Outro';
    }
  }

  @override
  void dispose() {
    super.dispose();
    _patientsBloc.close();
    _consultationsBloc.close();
  }
}
