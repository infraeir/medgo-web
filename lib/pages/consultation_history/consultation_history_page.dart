// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:medgo/data/blocs/consultation/consultation_bloc.dart';
import 'package:medgo/data/blocs/consultation/consultation_event.dart';
import 'package:medgo/data/blocs/consultation/consultation_state.dart';
import 'package:medgo/data/blocs/patients/patients_service_bloc.dart';
import 'package:medgo/data/blocs/patients/patients_service_event.dart';
import 'package:medgo/data/blocs/patients/patients_service_state.dart';
import 'package:medgo/data/models/block_model.dart';
import 'package:medgo/data/models/patients_model.dart';
import 'package:medgo/helper/helper.dart';
import 'package:medgo/data/models/consultation_model.dart';
import 'package:medgo/data/providers/logout_service.dart';
import 'package:markdown/markdown.dart' as markdown;
import 'package:medgo/pages/consultation_history/consultation_history_binding.dart';
import 'package:medgo/pages/consultation_history/widget/responsive_table_expanded.dart';
import 'package:medgo/pages/home/widgets/app_bar_home.dart';
import 'package:medgo/strings/strings.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/buttons/primary_icon_button.dart';
import 'package:medgo/widgets/news_widgets/buttons/tertiary_icon_button.dart';
import 'package:medgo/widgets/news_widgets/icon_button.dart';
import 'package:medgo/widgets/dialogs/dialog.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:printing/printing.dart';

class ConsultationHistoryPage extends StatefulWidget {
  final String patientId;

  const ConsultationHistoryPage({super.key, required this.patientId});

  @override
  State<ConsultationHistoryPage> createState() =>
      _ConsultationHistoryPageState();
}

class _ConsultationHistoryPageState extends State<ConsultationHistoryPage> {
  TextEditingController sexoController = TextEditingController();
  late final PatientsBloc _patientsBloc;
  late final ConsultationBloc _consultationsBloc;
  late final ConsultationBloc _consultationsReportBloc;
  Map<String, BlocksModel> blocksCache = {}; // Cache para armazenar os reports
  List<String> expandedConsultationId = [];
  PatientsModel? patient;
  bool isLoadingReport = false;

  @override
  void initState() {
    super.initState();
    setUpConsultationHistory();
    _patientsBloc = GetIt.I<PatientsBloc>();
    _consultationsBloc = GetIt.I<ConsultationBloc>();
    _consultationsReportBloc = GetIt.I<ConsultationBloc>();
    getPaciente();
    getConsultation();
    _listenEvents();
  }

  getPaciente() {
    _patientsBloc.add(
      GetPatient(id: widget.patientId),
    );
  }

  getConsultation() {
    _consultationsBloc.add(GetConsultations(idPatient: widget.patientId));
  }

  _getReportBloc(String consultationId) {
    // Verifica se já temos os dados em cache
    if (!blocksCache.containsKey(consultationId)) {
      _consultationsReportBloc.add(GetConsultationReport(
        idConsultation: consultationId,
      ));
    }
  }

  void _listenEvents() {
    _consultationsBloc.stream.listen((state) {
      if (state is ConsultationError) {
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

    _consultationsReportBloc.stream.listen((state) {
      if (state is ConsultationReportLoading) {
        setState(() {
          isLoadingReport = true;
        });
      } else if (state is ConsultationReportLoaded) {
        // Armazena no cache em vez de adicionar na lista
        setState(() {
          blocksCache[state.report.idConsultation] = state.report;
          isLoadingReport = false;
        });
      } else {
        isLoadingReport = false;
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

  void _toggleExpansion(String consultationId) {
    setState(() {
      if (expandedConsultationId.contains(consultationId)) {
        expandedConsultationId.remove(consultationId);
      } else {
        expandedConsultationId.add(consultationId);
        _getReportBloc(consultationId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryBackground,
      body: Column(
        children: [
          AppBarHome(
            backRoute: 'home',
            onLogout: () async {
              await postLogout();
              if (mounted) {
                context.go('/signin');
              }
            },
          ),
          const SizedBox(
            height: 50,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: BlocBuilder<ConsultationBloc, ConsultationState>(
                bloc: _consultationsBloc,
                builder: (context, state) {
                  if (state is ConsultationLoaded ||
                      state is ConsultationLoading) {
                    if (state is ConsultationLoaded) {
                      return _buildConsultationTable(
                          state.consultations, false);
                    } else {
                      return _buildConsultationTable([], true);
                    }
                  } else if (state is ConsultationError) {
                    return Center(child: Text(state.e.toString()));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationTable(
      List<ConsultationModel> consultations, bool isLoading) {
    if (consultations.isEmpty && !isLoading) {
      return SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("images/image_empty.svg", height: 200),
            const SizedBox(height: 10),
            Text(
              Strings.nenhumaConsultaEncontrada,
              style:
                  AppTheme.h3(color: Colors.black, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Text(
              '${Strings.historicoConsultas} do ${patient?.name}',
              style: AppTheme.h3(
                color: AppTheme.theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ResponsiveTableExpanded(
            title: 'consultas',
            isLoading: isLoading,
            headerCells: [
              Text(Strings.dataConsulta,
                  style: AppTheme.h5(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryText,
                  )),
              Text(Strings.medicoResponsavel,
                  style: AppTheme.h5(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryText,
                  )),
              Text(Strings.idadePaciente,
                  style: AppTheme.h5(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryText,
                  )),
              const SizedBox(width: 195),
            ],
            bodyRows: consultations.map((consultation) {
              return TableRowData(
                id: consultation.id!,
                cells: [
                  Text(
                    Helper.getData(consultation.createdAt!),
                    style: AppTheme.h5(
                      color: AppTheme.theme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(consultation.doctor!.name!),
                  Text(consultation.patient!.ageAtConsultation),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 200,
                        child: consultation.status == 'pending'
                            ? TertiaryIconButtonMedGo(
                                onTap: () =>
                                    _navigationConsult(consultation.id!),
                                rightIcon: const Icon(
                                  Icons.pending_actions_outlined,
                                ),
                                title: Strings.consultasPendente,
                              )
                            : SizedBox(
                                width: 190,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CustomIconButtonMedGo(
                                      onPressed: () {
                                        _toggleExpansion(consultation.id!);
                                      },
                                      icon: Icon(
                                        expandedConsultationId
                                                .contains(consultation.id)
                                            ? Icons.expand_less
                                            : Icons.expand_more,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  )
                ],
                isExpanded: expandedConsultationId.contains(consultation.id),
                onExpand: _toggleExpansion,
                expandedContent:
                    expandedConsultationId.contains(consultation.id)
                        ? expandedConsultation(consultation.id!)
                        : null,
              );
            }).toList(),
            columnFlex: const [2, 2, 1, 2],
            footerText:
                '${consultations.length} ${consultations.length == 1 ? 'consulta encontrada' : 'consultas encontradas'}',
            isEmpty: consultations.isEmpty,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget expandedConsultation(String idConsultation) {
    // Obtém do cache em vez da lista
    BlocksModel? blockExpanded = blocksCache[idConsultation];

    if (isLoadingReport && blockExpanded == null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: AppTheme.theme.primaryColor,
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text('Carregando dados...'),
              ],
            ),
          ),
        ],
      );
    }

    if (blockExpanded != null && blockExpanded.blocks.isNotEmpty) {
      return Column(
        children: [
          ...blockExpanded.blocks.map((block) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Html(
                          data: markdown.markdownToHtml(block.formattedText)),
                    ),
                    CustomIconButtonMedGo(
                      onPressed: () => _copyToClipboard(block.freeText),
                      icon: Icon(PhosphorIcons.copySimple()),
                    ),
                  ],
                ),
                const Divider(),
              ],
            );
          }),
          Row(
            children: [
              SizedBox(
                width: 180,
                child: PrimaryIconButtonMedGo(
                  onTap: () {
                    final concatenatedText = blockExpanded.blocks
                        .map((block) => block.freeText)
                        .where((text) => text.isNotEmpty)
                        .join('\n\n');
                    _copyToClipboard(concatenatedText.trim());
                  },
                  title: Strings.copiarTudo,
                  leftIcon: Icon(
                    PhosphorIcons.copySimple(
                      PhosphorIconsStyle.bold,
                    ),
                    shadows: const [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 4.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                width: 180,
                child: PrimaryIconButtonMedGo(
                  onTap: () {
                    _printReport(blockExpanded.blocks);
                  },
                  title: Strings.imprimir,
                  leftIcon: Icon(
                    PhosphorIcons.printer(
                      PhosphorIconsStyle.bold,
                    ),
                    shadows: const [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 4.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Nenhum relatório disponível.',
              style: AppTheme.h5(
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget colunasTabelaConsultas(size) {
    return Container(
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        children: [
          const SizedBox(
            width: 50,
          ),
          Expanded(
            child: SizedBox(
                child: Text(
              Strings.dataConsulta,
              style:
                  AppTheme.h5(color: Colors.black, fontWeight: FontWeight.w600),
            )),
          ),
          SizedBox(
              width: size.width * 0.2,
              child: Text(
                Strings.medicoResponsavel,
                style: AppTheme.h5(
                    color: Colors.black, fontWeight: FontWeight.w600),
              )),
          SizedBox(
            width: size.width * 0.2,
            child: Text(
              Strings.idadePaciente,
              style:
                  AppTheme.h5(color: Colors.black, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            width: 195,
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    showToast(
      'Texto copiado para a área de transferência.',
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
  }

  void _printReport(List<Block> blocks) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Finalização de consulta',
                style:
                    pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 16),
              ...blocks.map((block) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      block.freeText,
                      style: const pw.TextStyle(fontSize: 14),
                    ),
                    pw.Divider(),
                  ],
                );
              }).toList(),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _consultationsBloc.close();
  }
}
