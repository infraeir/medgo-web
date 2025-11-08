// ignore_for_file: depend_on_referenced_packages

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
import 'package:medgo/widgets/news_widgets/icon_button.dart';
import 'package:medgo/widgets/button/outline_button.dart';
import 'package:medgo/widgets/load/load_ball.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../themes/app_theme.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class FinalizedConsultationModal extends StatefulWidget {
  final ConsultationModel consultation;

  const FinalizedConsultationModal({
    super.key,
    required this.consultation,
  });

  @override
  State<FinalizedConsultationModal> createState() =>
      _FinalizedConsultationModalState();
}

class _FinalizedConsultationModalState
    extends State<FinalizedConsultationModal> {
  late final ConsultationBloc _consultationsBloc;
  BlocksModel? reportString;
  String concatenatedText = '';
  List<Block> blocksCache = [];

  @override
  void initState() {
    super.initState();
    setUpPrescription();
    _consultationsBloc = GetIt.I<ConsultationBloc>();

    _getPrescriptionBloc();
  }

  _getPrescriptionBloc() {
    _consultationsBloc.add(GetConsultationReport(
      idConsultation: widget.consultation.id!,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(32.0),
        )),
        // Adicionado Material envolvendo o modal
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.9,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox.shrink(),
                  Text(
                    'Relatório de consulta finalizada',
                    style: AppTheme.h3(
                      color: AppTheme.theme.primaryColorDark,
                      fontWeight: FontWeight.bold,
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
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: BlocBuilder<ConsultationBloc, ConsultationState>(
                  bloc: _consultationsBloc,
                  builder: (context, state) {
                    if (state is ConsultationLoading) {
                      return const LoadingAnimation();
                    } else if (state is ConsultationReportLoaded) {
                      concatenatedText = "";
                      blocksCache = state.report.blocks;
                      for (var block in state.report.blocks) {
                        if (block.freeText.isNotEmpty) {
                          concatenatedText += '${block.freeText}\n';
                        }
                      }

                      if (concatenatedText.isNotEmpty) {
                        concatenatedText = concatenatedText.trim();
                      }

                      return ListView.builder(
                          itemCount: state.report.blocks.length,
                          itemBuilder: (context, index) {
                            Block block = state.report.blocks[index];

                            Widget html = Html(
                              data:
                                  markdown.markdownToHtml(block.formattedText),
                            );
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: html,
                                    ),
                                    CustomIconButtonMedGo(
                                      onPressed: () {
                                        _copyToClipboard(block.freeText);
                                      },
                                      icon: Icon(PhosphorIcons.copySimple()),
                                    ),
                                  ],
                                ),
                                const Divider(),
                              ],
                            );
                          });
                    } else {
                      return const LoadingAnimation();
                    }
                  },
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: OutlinePrimaryButton(
                      onTap: () {
                        _copyToClipboard(concatenatedText.trim());
                      },
                      title: Strings.copiarTudo,
                      iconeLeft: PhosphorIcons.copySimple(),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 200,
                    child: OutlinePrimaryButton(
                      onTap: () {
                        _printReport(blocksCache);
                      },
                      title: Strings.imprimir,
                      iconeLeft: PhosphorIcons.printer(),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
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
                      style: pw.TextStyle(fontSize: 14),
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
}
