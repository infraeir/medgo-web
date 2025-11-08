// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get_it/get_it.dart';
import 'package:markdown/markdown.dart' as markdown;
import 'package:medgo/data/blocs/consultation/consultation_bloc.dart';
import 'package:medgo/data/blocs/consultation/consultation_event.dart';
import 'package:medgo/data/blocs/consultation/consultation_state.dart';
import 'package:medgo/data/models/block_model.dart';
import 'package:medgo/data/models/consultation_model.dart';

import 'package:medgo/pages/prescription/prescription_binding.dart';
import 'package:medgo/strings/strings.dart';
import 'package:medgo/widgets/news_widgets/buttons/primary_icon_button.dart';
import 'package:medgo/widgets/news_widgets/buttons/tertiary_icon_button.dart';
import 'package:medgo/widgets/news_widgets/icon_button.dart';
import 'package:medgo/widgets/load/load_ball.dart';
import 'package:medgo/widgets/scrollbar/custom_scroll_bar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../themes/app_theme.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class FinalizationModal extends StatefulWidget {
  final ConsultationModel consultation;

  const FinalizationModal({
    super.key,
    required this.consultation,
  });

  @override
  State<FinalizationModal> createState() => _FinalizationModalState();
}

class _FinalizationModalState extends State<FinalizationModal> {
  late final ConsultationBloc _consultationsBloc;
  late ScrollController scrollController;
  BlocksModel? reportString;
  String concatenatedText = '';

  @override
  void initState() {
    super.initState();
    setUpPrescription();
    _consultationsBloc = GetIt.I<ConsultationBloc>();
    scrollController = ScrollController();

    _getPrescriptionBloc();
  }

  _getPrescriptionBloc() {
    _consultationsBloc.add(GetConsultationReport(
      idConsultation: widget.consultation.id!,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Center(
        child: Dialog(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(32.0),
          )),
          // Adicionado Material envolvendo o modal
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              color: AppTheme.info,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Sombra mais suave
                  blurRadius: 30,
                  offset: const Offset(0, 5),
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 5.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildFinalizationReportExpanded(
                        bloc: _consultationsBloc,
                        context: context,
                      ),
                    ],
                  ),
                ),
                // Header flutuante no topo com blur - deve estar depois para ficar na frente
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
                      filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 10,
                          left: 8.0,
                          right: 8,
                          bottom: 10.0,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withOpacity(1),
                              Colors.white.withOpacity(0.7),
                              Colors.white.withOpacity(0.0),
                            ],
                            stops: const [
                              0.0,
                              0.5,
                              1.0
                            ], // Define os pontos de transição
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox.shrink(),
                            Text(
                              'Finalização de consulta',
                              style: AppTheme.h3(
                                color: AppTheme.theme.primaryColorDark,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            CustomIconButtonMedGo(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 4,
                          left: 8.0,
                          right: 8,
                          bottom: 10.0,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.white.withOpacity(1),
                              Colors.white.withOpacity(0.7),
                              Colors.white.withOpacity(0.0),
                            ],
                            stops: const [
                              0.0,
                              0.5,
                              1.0
                            ], // Define os pontos de transição
                          ),
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 100,
                              child: PrimaryIconButtonMedGo(
                                onTap: () {
                                  Navigator.of(context).pop(false);
                                },
                                title: Strings.voltar,
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
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 140,
                                  child: PrimaryIconButtonMedGo(
                                    onTap: () {
                                      _copyToClipboard(concatenatedText);
                                    },
                                    title: Strings.copiarTudo,
                                    rightIcon: Icon(
                                      PhosphorIcons.copySimple(
                                        PhosphorIconsStyle.bold,
                                      ),
                                      size: 24,
                                      shadows: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          blurRadius: 2,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 120,
                                  child: PrimaryIconButtonMedGo(
                                    onTap: () {
                                      if (_consultationsBloc.state
                                          is ConsultationReportLoaded) {
                                        final state = _consultationsBloc.state
                                            as ConsultationReportLoaded;
                                        _printReport(state.report.blocks);
                                      } else {
                                        // Feedback caso relatório não esteja carregado
                                        showToast(
                                          'O relatório ainda não foi carregado para impressão.',
                                          context: context,
                                          axis: Axis.horizontal,
                                          alignment: Alignment.center,
                                          position: StyledToastPosition.top,
                                          animation: StyledToastAnimation
                                              .slideFromTopFade,
                                          reverseAnimation:
                                              StyledToastAnimation.fade,
                                          backgroundColor: AppTheme.secondary,
                                          textStyle: const TextStyle(
                                              color: Colors.white),
                                          duration: const Duration(seconds: 2),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        );
                                      }
                                    },
                                    title: Strings.imprimir,
                                    rightIcon: Icon(
                                      PhosphorIcons.printer(
                                        PhosphorIconsStyle.bold,
                                      ),
                                      size: 24,
                                      shadows: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          blurRadius: 2,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 180,
                              child: TertiaryIconButtonMedGo(
                                onTap: () {
                                  Navigator.of(context).pop(true);
                                },
                                title: Strings.finalizarConsulta,
                                rightIcon: Icon(
                                  color: AppTheme.success,
                                  PhosphorIcons.checkCircle(
                                    PhosphorIconsStyle.bold,
                                  ),
                                  size: 24,
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFinalizationReportExpanded({
    required ConsultationBloc bloc,
    required BuildContext context,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: BlocBuilder<ConsultationBloc, ConsultationState>(
              bloc: bloc,
              builder: (context, state) {
                if (state is ConsultationLoading) {
                  return const LoadingAnimation();
                } else if (state is ConsultationReportLoaded) {
                  concatenatedText = "";
                  for (var block in state.report.blocks) {
                    if (block.freeText.isNotEmpty) {
                      concatenatedText += '${block.freeText} \n \n';
                    }
                  }

                  if (concatenatedText.isNotEmpty) {
                    concatenatedText = concatenatedText.trim();
                  }

                  return CustomScrollbar(
                    controller: scrollController,
                    trackMargin: const EdgeInsets.only(
                      top: 60, // Margem no topo para não cobrir o header
                      bottom: 60, // Margem embaixo para não cobrir os botões
                    ),
                    child: Builder(builder: (context) {
                      return ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          scrollbars: false,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: state.report.blocks.length,
                            padding: const EdgeInsets.only(top: 60, bottom: 60),
                            itemBuilder: (context, index) {
                              Block block = state.report.blocks[index];

                              Widget html = Html(
                                data: markdown
                                    .markdownToHtml(block.formattedText),
                              );
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: html),
                                      CustomIconButtonMedGo(
                                        onPressed: () {
                                          Clipboard.setData(
                                            ClipboardData(text: block.freeText),
                                          );
                                          showToast(
                                            'Texto copiado para a área de transferência!',
                                            context: context,
                                            axis: Axis.horizontal,
                                            alignment: Alignment.center,
                                            position: StyledToastPosition.top,
                                            animation: StyledToastAnimation
                                                .slideFromTopFade,
                                            reverseAnimation:
                                                StyledToastAnimation.fade,
                                            backgroundColor: AppTheme.secondary,
                                            textStyle: const TextStyle(
                                                color: Colors.white),
                                            duration:
                                                const Duration(seconds: 2),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          );
                                        },
                                        icon: Icon(
                                          PhosphorIcons.copySimple(
                                            PhosphorIconsStyle.bold,
                                          ),
                                          shadows: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              blurRadius: 5,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                          color: AppTheme.primary,
                                          size: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                ],
                              );
                            },
                          ),
                        ),
                      );
                    }),
                  );
                } else {
                  return const LoadingAnimation();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _printReport(List<Block> blocks) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            ...blocks.map((block) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    block.freeText,
                    style: const pw.TextStyle(fontSize: 14),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Divider(),
                ],
              );
            }).toList(),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    showToast(
      'Texto copiado para a área de transferência!',
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

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    _consultationsBloc.close();
  }
}
