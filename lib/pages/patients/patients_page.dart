// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:medgo/data/blocs/consultation/consultation_bloc.dart';
import 'package:medgo/data/blocs/consultation/consultation_state.dart';
import 'package:medgo/helper/helper.dart';
import 'package:medgo/data/blocs/patients/patients_service_bloc.dart';
import 'package:medgo/data/blocs/patients/patients_service_event.dart';
import 'package:medgo/data/blocs/patients/patients_service_state.dart';
import 'package:medgo/pages/patients/widgets/crud_patient_modal.dart';
import 'package:medgo/pages/patients/widgets/responsive_table.dart';
import 'package:medgo/pages/prescription/modals/with_patient_outside_modal.dart';
import 'package:medgo/pages/prescription/modals/without_patient_selection_modal.dart';
import 'package:medgo/strings/strings.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/pages/patients/patients_binding.dart';
import 'package:medgo/widgets/news_widgets/buttons/primary_icon_button.dart';
import 'package:medgo/widgets/news_widgets/buttons/tertiary_icon_button.dart';
import 'package:medgo/widgets/news_widgets/icon_button.dart';
import 'package:medgo/widgets/dialogs/dialog.dart';
import 'package:medgo/widgets/dialogs/loading_dialog.dart';
import 'package:medgo/widgets/news_widgets/search_input.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/patients_model.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/doctor_model.dart';

class PatientsPage extends StatefulWidget {
  final Function(List<bool> value) selected;
  const PatientsPage({Key? key, required this.selected}) : super(key: key);

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  late final ScrollController _scrollController;
  late PatientsBloc _patientsBloc;
  late final ConsultationBloc _consultationsBloc;
  TextEditingController searchController = TextEditingController();
  List<PatientsModel> listPatients = [];
  int patientsLenght = 0;
  int totalPages = 1;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    setUpMain();
    _patientsBloc = GetIt.I<PatientsBloc>();
    _consultationsBloc = GetIt.I<ConsultationBloc>();
    getPacientesIniciais();
    _listenEvents();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 200) {
      if (_currentPage < totalPages) {
        _geNewtPacientes(_currentPage + 1);
        setState(() {
          _currentPage++;
        });
      }
    }
  }

  getPacientesIniciais() {
    _patientsBloc.add(GetPatients(
        loadedPatients: listPatients, search: searchController.text));
  }

  _geNewtPacientes(current) {
    if (current <= totalPages) {
      _patientsBloc.add(LoadMoreData(
          currentPage: current,
          loadedPatients: listPatients,
          search: searchController.text));
    }
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

    if (result == 'true') {
      getPacientesIniciais();
    }
  }

  void _listenEvents() {
    _consultationsBloc.stream.listen((state) {
      if (state is ConsultationLoading) {
        shoLoadingDialog(context: context, barriedDismissible: false);
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
      if (state is PatientsLoaded) {
        setState(() {
          patientsLenght = state.patients.total;
        });
      }
    });
  }

  _navigationConsult(String idConsultation, String idPatient) async {
    context.go(
      '/consultation/$idPatient/$idConsultation/',
    );
  }

  void _openPrescriptionModal(PatientsModel patient) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String nameUser = preferences.getString('nameUser') ?? '';
    String registrationNumber =
        preferences.getString('registrationNumber') ?? '';

    final DoctorModel doctor = DoctorModel(
      id: 'doctor-id',
      name: nameUser,
      registrationNumber: registrationNumber,
    );

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WithPatientOutsideModal(
          doctor: doctor,
          patient: patient,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: 0,
            top: 6,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: PrimaryIconButtonMedGo(
                  title: Strings.prescrever,
                  rightIcon: Icon(
                    size: 18,
                    color: AppTheme.salmon,
                    PhosphorIcons.prescription(
                      PhosphorIconsStyle.bold,
                    ),
                    shadows: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 5.0,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  onTap: () async {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();

                    String nameUser = preferences.getString('nameUser') ?? '';
                    String registrationNumber =
                        preferences.getString('registrationNumber') ?? '';

                    final DoctorModel doctor = DoctorModel(
                      id: 'doctor-id',
                      name: nameUser,
                      registrationNumber: registrationNumber,
                    );

                    await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return WithoutPatientSelectionModal(
                          doctor: doctor,
                        );
                      },
                    );
                  },
                ),
              ),
              Flexible(
                flex: 4,
                child: Column(
                  children: [
                    Text(
                      patientsLenght == 0
                          ? 'Cadastre um paciente para começar a atender!'
                          : "Selecione um paciente ou cadastre um novo para começar a atender.",
                      style: AppTheme.p(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: 528,
                      child: SearchInputMedgo(
                        controller: searchController,
                        hintText: Strings.procurarPaciente,
                        enabled: true,
                        onChanged: (value) {
                          getPacientesIniciais();
                        },
                        iconSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: PrimaryIconButtonMedGo(
                  title: Strings.cadastrePaciente,
                  rightIcon: Icon(
                    size: 18,
                    PhosphorIcons.userCirclePlus(
                      PhosphorIconsStyle.bold,
                    ),
                    shadows: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 5.0,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  onTap: () async {
                    var result = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CrudPatientModal();
                      },
                    );

                    if (result == 'true') {
                      searchController.text = '';
                      getPacientesIniciais();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: BlocBuilder<PatientsBloc, PatientsState>(
            bloc: _patientsBloc,
            builder: (context, state) {
              if (state is PatientsLoaded ||
                  state is PatientsLoading ||
                  state is PatientsLoadingMore) {
                if (state is PatientsLoaded) {
                  listPatients.clear();
                  listPatients.addAll(state.patients.patients);
                  totalPages = state.patients.totalPages;
                }

                return Padding(
                  padding: const EdgeInsets.only(
                    right: 24,
                    left: 24,
                    bottom: 20,
                  ),
                  child: ResponsiveTable(
                    scrollController: _scrollController,
                    headerCells: [
                      Text(
                        "Paciente",
                        style: AppTheme.h5(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryText,
                        ),
                      ),
                      Text(
                        "Filiação",
                        style: AppTheme.h5(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryText,
                        ),
                      ),
                      Text(
                        "Idade",
                        style: AppTheme.h5(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryText,
                        ),
                      ),
                      Text(
                        "Última consulta",
                        style: AppTheme.h5(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryText,
                        ),
                      ),
                      const SizedBox.shrink(), // Botão de histórico
                      const SizedBox.shrink(), // Botão de consulta
                    ],
                    isLoading: state is PatientsLoading,
                    isLoadingMore: state is PatientsLoadingMore,
                    bodyCells: listPatients.map((patient) {
                      return [
                        // Primeira coluna (Nome) - Width fixa + Expanded para o texto
                        SizedBox(
                          width: 200, // Ajuste esse valor conforme necessário
                          child: Row(
                            children: [
                              CustomIconButtonMedGo(
                                icon: Icon(
                                  PhosphorIcons.pencilSimple(
                                      PhosphorIconsStyle.bold),
                                  color: AppTheme.theme.primaryColor,
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 4.0,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                onPressed: () => _showEditPatients(patient),
                              ),
                              Expanded(
                                child: Text(
                                  patient.name.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Segunda coluna (Filação) - Container com width fixa
                        SizedBox(
                          width: 200, // Ajuste esse valor conforme necessário
                          child: Text(
                            patient.motherName.toString(),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // Terceira coluna (Idade) - Container com width fixa
                        SizedBox(
                          width: 80, // Ajuste esse valor conforme necessário
                          child: Text(patient.age),
                        ),

                        // Quarta coluna (Última consulta) - Container com width fixa
                        SizedBox(
                          width: 120, // Ajuste esse valor conforme necessário
                          child: Text(
                            patient.lastConsultationData.createdAt != 'N/A'
                                ? Helper.getData(patient
                                    .lastConsultationData.createdAt
                                    .toString())
                                : patient.lastConsultationData.createdAt,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        const SizedBox(width: 40), // Espaçador fixo

                        // Última coluna (Botões) - Container com width fixa
                        SizedBox(
                          width:
                              400, // Aumentado para acomodar o botão de prescrever
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              PrimaryIconButtonMedGo(
                                onTap: () => context.go(
                                    '/consultation-history/${patient.id}',
                                    extra: patient),
                                title: Strings.historico,
                                leftIcon: Icon(
                                  Icons.history_edu,
                                  size: 24,
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 4.0,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              PrimaryIconButtonMedGo(
                                onTap: () => _openPrescriptionModal(patient),
                                leftIcon: Icon(
                                  PhosphorIcons.prescription(
                                    PhosphorIconsStyle.bold,
                                  ),
                                  size: 20,
                                  color: AppTheme.salmon,
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 4.0,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                              patient.lastConsultationData.status ==
                                          'not_initialized' ||
                                      patient.lastConsultationData.status ==
                                          'completed'
                                  ? Container(
                                      width: 185,
                                      margin: const EdgeInsets.only(left: 8),
                                      child: PrimaryIconButtonMedGo(
                                        onTap: () => context
                                            .go('/acompanying/${patient.id}'),
                                        title: Strings.novaConsulta,
                                        leftIcon: Icon(
                                          PhosphorIcons.plusCircle(
                                            PhosphorIconsStyle.bold,
                                          ),
                                          size: 24,
                                          shadows: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              blurRadius: 4.0,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 185,
                                      margin: const EdgeInsets.only(left: 8),
                                      child: TertiaryIconButtonMedGo(
                                        onTap: () => _navigationConsult(
                                            patient.lastConsultationData.id,
                                            patient.id),
                                        title: Strings.consultasPendente,
                                        leftIcon: const Icon(
                                          Icons.pending_actions_outlined,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ];
                    }).toList(),
                    columnFlex: const [
                      3,
                      3,
                      1,
                      2,
                      1,
                      5
                    ], // Ajuste esses valores conforme necessário
                    footerText: patientsLenght == 0
                        ? 'Nenhum paciente encontrado'
                        : '$patientsLenght ${patientsLenght == 1 ? 'paciente encontrado' : 'pacientes encontrados'}',
                    title: 'Pacientes',
                    isEmpty: listPatients.isEmpty,
                    emptyStateWidget: Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.lightOutline,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "images/image_empty.svg",
                                height: 150,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Nenhum paciente encontrado',
                                style: TextStyle(
                                  color: AppTheme.theme.primaryColor,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else if (state is PatientsError) {
                return const Center(child: Text("Erro ao carregar pacientes"));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        )
      ],
    );
  }
}
