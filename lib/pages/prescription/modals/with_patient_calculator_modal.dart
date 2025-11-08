// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get_it/get_it.dart';
import 'package:medgo/pages/prescription/prescription_binding.dart';
import 'package:medgo/widgets/load/load_ball.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:printing/printing.dart';

import 'package:medgo/data/blocs/prescription/prescription_bloc.dart';
import 'package:medgo/data/blocs/prescription/prescription_event.dart';
import 'package:medgo/data/blocs/prescription/prescription_state.dart';
import 'package:medgo/data/models/doctor_model.dart';
import 'package:medgo/data/models/new_prescription_model.dart';
import 'package:medgo/helper/helper.dart';
import 'package:medgo/pages/prescription/base/base_prescription_modal.dart';
import 'package:medgo/pages/prescription/widgets/prescription_header.dart';
import 'package:medgo/pages/prescription/widgets/prescription_footer.dart';
import 'package:medgo/pages/prescription/widgets/prescription_list.dart';
import 'package:medgo/pages/prescription/enums/prescription_type.dart';
import 'package:medgo/strings/strings.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/button/primary_button.dart';
import 'package:medgo/widgets/dialogs/dialog.dart';
import 'package:medgo/widgets/prescription/medical_prescription.dart';

/// Modal específico para prescrições geradas por calculadoras médicas
/// - NÃO há paciente selecionado nem opção para selecionar
/// - APENAS indicações automáticas da calculadora
/// - NÃO há modal de seleção de medicamentos
/// - NÃO pode TROCAR nem EDITAR paciente (não existe)
/// - Impressão: Não exibe informações de paciente
class WithPatientCalculatorModal extends BasePrescriptionModal {
  final String calculatorId;
  final DoctorModel doctor;
  final String? peso;

  const WithPatientCalculatorModal({
    super.key,
    required this.calculatorId,
    required this.doctor,
    this.peso,
  });

  @override
  State<WithPatientCalculatorModal> createState() =>
      _WithPatientCalculatorModalState();
}

class _WithPatientCalculatorModalState
    extends BasePrescriptionModalState<WithPatientCalculatorModal> {
  late final PrescriptionBloc _prescriptionBloc;
  List<NewPrescriptionModel> prescriptionsVacination = [];
  List<NewPrescriptionModel> prescriptionsMedication = [];
  bool loaded = false;
  DateTime? emissionDate;
  DateTime? expirationDate;
  bool showPrintPreview = true;

  @override
  void initState() {
    super.initState();
    setUpPrescription();
    _prescriptionBloc = GetIt.I<PrescriptionBloc>();
    _getPrescriptionBloc();
    // Inicializa a data de emissão com a data atual
    emissionDate = DateTime.now();
    _listenEvents();
  }

  void _getPrescriptionBloc() {
    _prescriptionBloc.add(
      GetPrescriptions(
        consultationId: null,
        calculatorId: widget.calculatorId,
      ),
    );
  }

  void _listenEvents() {
    _prescriptionBloc.stream.listen((state) {
      if (state is PrescriptionsByIdLoaded) {
        _handlePrescriptionsLoaded(state);
      } else if (state is PrescriptionError) {
        _handlePrescriptionError(state);
      }
    });
  }

  void _handlePrescriptionsLoaded(PrescriptionsByIdLoaded state) {
    setState(() {
      loaded = true;
      prescriptionsMedication.clear();
      prescriptionsVacination.clear();

      if (state.prescription != null) {
        for (var prsc in state.prescription!) {
          if (prsc.items[0].type == 'medication') {
            prescriptionsMedication.add(prsc);
          } else {
            prescriptionsVacination.add(prsc);
          }
        }
      }
    });
  }

  void _handlePrescriptionError(PrescriptionError state) {
    if (state.e.toString().contains('Peso')) {
      _showWeightDialog();
    } else {
      _showErrorDialog(state.e.toString());
    }
  }

  void _showWeightDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Peso necessário"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(32),
        content: const Text(
          'Adicione o peso para calcular as prescrições automáticas',
          style: TextStyle(color: Colors.red),
        ),
        actions: [
          SizedBox(
            width: 200,
            child: PrimaryButton(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              conteudo: const Text(
                Strings.voltar,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String error) {
    showTheDialog(
      context: context,
      title: "Erro!",
      actionButtonText2: Strings.fechar,
      onActionButtonPressed: () {},
      body: Text(
        error,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  void _updatePrescription({
    required String prescriptionItemId,
    required bool isChosen,
  }) {
    // Atualiza o estado local primeiro
    setState(() {
      // Atualiza nas medicações
      for (var prescription in prescriptionsMedication) {
        for (var item in prescription.items) {
          if (item.id == prescriptionItemId) {
            item.isChosen = isChosen;
            break;
          }
        }
      }

      // Atualiza nas vacinações
      for (var prescription in prescriptionsVacination) {
        for (var item in prescription.items) {
          if (item.id == prescriptionItemId) {
            item.isChosen = isChosen;
            break;
          }
        }
      }
    });

    // Depois envia para o backend
    _prescriptionBloc.add(NewPatchPrescription(
      prescriptionItemId: prescriptionItemId,
      isChosen: isChosen,
    ));
  }

  void _reloadPrescriptions() {
    setState(() {
      loaded = false;
    });
    _getPrescriptionBloc();
  }

  bool _hasSelectedItems() {
    bool vacinationHasSelected = prescriptionsVacination
        .any((prescription) => prescription.items.any((item) => item.isChosen));

    bool medicationHasSelected = prescriptionsMedication
        .any((prescription) => prescription.items.any((item) => item.isChosen));

    return vacinationHasSelected || medicationHasSelected;
  }

  // Footer callbacks - específicos para calculadora
  void _onEmissionDateChanged(DateTime? date) {
    setState(() {
      emissionDate = date;
    });
    if (date != null) {
      print(
          'Data de emissão selecionada: ${date.day}/${date.month}/${date.year}');
    }
  }

  void _onExpirationDateChanged(DateTime? date) {
    setState(() {
      expirationDate = date;
    });
    if (date != null) {
      print(
          'Data de validade selecionada: ${date.day}/${date.month}/${date.year}');
    }
  }

  void _onPreviewPrint() {
    setState(() {
      showPrintPreview = !showPrintPreview;
    });
    print(
        'Visualização de impressão ${showPrintPreview ? 'ativada' : 'desativada'} para calculadora ${widget.calculatorId}');
  }

  void _onNavigateBack() {
    // Volta para a calculadora
    Navigator.of(context).pop();
  }

  void _onDeletePrescription() {
    // TODO: Implementar exclusão de prescrição da calculadora
    print('Excluir prescrição da calculadora ${widget.calculatorId}');
  }

  void _onCopyPrescription() {
    List<ItemModel> allItems = [];

    // Adiciona todas as vacinas escolhidas
    for (var prescription in prescriptionsVacination) {
      allItems
          .addAll(prescription.items.where((item) => item.isChosen == true));
    }

    // Adiciona todas as medicações escolhidas
    for (var prescription in prescriptionsMedication) {
      allItems
          .addAll(prescription.items.where((item) => item.isChosen == true));
    }

    if (allItems.isEmpty) {
      showToast(
        'Nenhuma indicação selecionada!',
        context: context,
        axis: Axis.horizontal,
        alignment: Alignment.center,
        position: StyledToastPosition.top,
        animation: StyledToastAnimation.slideFromTopFade,
        reverseAnimation: StyledToastAnimation.fade,
        backgroundColor: AppTheme.error,
        textStyle: const TextStyle(color: Colors.white),
        duration: const Duration(seconds: 2),
        borderRadius: BorderRadius.circular(8),
      );
      return;
    }

    String allMedicationsText = '';
    int index = 1;

    for (var item in allItems) {
      if (item.type == 'medication') {
        allMedicationsText +=
            '$index. ${item.entity.tradeName} (${item.entity.presentation} ${item.entity.activeIngredient} - ${item.entity.activeIngredientConcentration}) mg/ml\n';
        allMedicationsText += '   ${item.instructions.prescription}\n\n';
      } else {
        allMedicationsText +=
            '$index. ${item.entity.vaccineName} - Aplicar ${item.entity.doseNumber} dose\n\n';
      }
      index++;
    }

    // Copia para clipboard
    Clipboard.setData(ClipboardData(text: allMedicationsText.trim()));

    // Mostra toast de sucesso
    showToast(
      'Indicações da calculadora copiadas com sucesso!',
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

  void _onPrintPrescription() {
    List<ItemModel> allItems = [];

    // Adiciona todas as vacinas escolhidas
    for (var prescription in prescriptionsVacination) {
      allItems
          .addAll(prescription.items.where((item) => item.isChosen == true));
    }

    // Adiciona todas as medicações escolhidas
    for (var prescription in prescriptionsMedication) {
      allItems
          .addAll(prescription.items.where((item) => item.isChosen == true));
    }

    if (allItems.isEmpty) {
      showToast(
        'Nenhuma indicação selecionada para impressão!',
        context: context,
        axis: Axis.horizontal,
        alignment: Alignment.center,
        position: StyledToastPosition.top,
        animation: StyledToastAnimation.slideFromTopFade,
        reverseAnimation: StyledToastAnimation.fade,
        backgroundColor: AppTheme.error,
        textStyle: const TextStyle(color: Colors.white),
        duration: const Duration(seconds: 2),
        borderRadius: BorderRadius.circular(8),
      );
      return;
    }

    // Gera e abre PDF para impressão
    _generatePDF(allItems);
  }

  void _onSavePrescription() {
    // TODO: Implementar salvamento específico para calculadora
    print('Salvar prescrição da calculadora ${widget.calculatorId}');
  }

  @override
  Widget buildHeader() {
    return PrescriptionHeader(
      prescriptionType: PrescriptionType.withPatientDuringCalculator,
      patient: null, // Calculadora não tem paciente
      onClose: () => Navigator.pop(context),
      // Não tem callbacks de paciente pois não existe paciente
    );
  }

  @override
  Widget buildContent() {
    if (prescriptionsMedication.isEmpty && prescriptionsVacination.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      controller: scrollController,
      // Otimizar physics para web - ClampingScrollPhysics é mais performático
      physics: kIsWeb
          ? const ClampingScrollPhysics()
          : const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 105, bottom: 110),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              // NÃO há select de medicamentos na calculadora
              // Apenas as listas de indicações automáticas

              // Lista de medicações automáticas
              PrescriptionList(
                prescriptions: prescriptionsMedication,
                listIndex: 0,
                onUpdatePrescription: _updatePrescription,
                onReload: _reloadPrescriptions,
                consultationId: null,
                calculatorId: widget.calculatorId,
                prescriptionBloc: _prescriptionBloc,
              ),
              const SizedBox(height: 10),
              // Lista de vacinações automáticas
              PrescriptionList(
                prescriptions: prescriptionsVacination,
                listIndex: 1,
                onUpdatePrescription: _updatePrescription,
                onReload: _reloadPrescriptions,
                consultationId: null,
                calculatorId: widget.calculatorId,
                prescriptionBloc: _prescriptionBloc,
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Preview da prescrição se houver itens selecionados e visualização ativada
          if (_hasSelectedItems() && showPrintPreview)
            MedicalPrescription(
              patient: null,
              doctor: widget.doctor,
              peso: widget.peso,
              emissionDate: emissionDate,
              expirationDate: expirationDate,
              prescriptionsMedication: prescriptionsMedication,
              prescriptionsVacination: prescriptionsVacination,
            ),
        ],
      ),
    );
  }

  @override
  Widget buildFooter() {
    return PrescriptionFooter(
      initialEmissionDate: emissionDate,
      initialExpirationDate: expirationDate,
      showPreview: showPrintPreview,
      onEmissionDateChanged: _onEmissionDateChanged,
      onExpirationDateChanged: _onExpirationDateChanged,
      onPreviewPrint: _onPreviewPrint,
      onNavigateBack: _onNavigateBack,
      onDeletePrescription: _onDeletePrescription,
      onCopyPrescription: _onCopyPrescription,
      onPrintPrescription: _onPrintPrescription,
      onSavePrescription: _onSavePrescription,
    );
  }

  Widget _buildEmptyState() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          controller: scrollController,
          // Otimizar physics para web - ClampingScrollPhysics é mais performático
          physics: kIsWeb
              ? const ClampingScrollPhysics()
              : const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.9 - 100,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!loaded)
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [LoadingAnimation()],
                    )
                  else ...[
                    const Icon(
                      Icons.calculate_outlined,
                      size: 80,
                      color: AppTheme.secondary,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Calculadora Médica',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Aguarde o carregamento das indicações automáticas baseadas nos cálculos médicos',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.secondaryText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    if (widget.peso != null)
                      Card(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.monitor_weight_outlined,
                                color: AppTheme.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Peso: ${widget.peso} kg',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _generatePDF(List<ItemModel> medications) async {
    final pdfLib.Document pdf = pdfLib.Document();
    final fontAtkinson =
        await rootBundle.load("assets/fonts/AtkinsonHyperlegible-Regular.ttf");
    final ttfAtkinson = pdfLib.Font.ttf(fontAtkinson);

    // Função auxiliar para formatar números
    String formatNumber(int number) {
      return number.toString().padLeft(2, '0');
    }

    pdfLib.Widget buildHeader(pdfLib.Context context) {
      return pdfLib.Column(
        children: [
          pdfLib.Center(
            child: pdfLib.Text(
              'Prescrição - Calculadora Médica',
              style: pdfLib.TextStyle(
                font: ttfAtkinson,
                fontSize: 18,
                fontWeight: pdfLib.FontWeight.bold,
              ),
            ),
          ),
          pdfLib.SizedBox(height: context.pageNumber == 1 ? 20 : 40),
          // NÃO exibe informações de paciente na calculadora
          if (widget.peso != null)
            pdfLib.RichText(
              text: pdfLib.TextSpan(
                style: pdfLib.TextStyle(font: ttfAtkinson, fontSize: 14),
                children: [
                  pdfLib.TextSpan(
                    text: 'Peso: ',
                    style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                  ),
                  pdfLib.TextSpan(text: '${widget.peso} kg'),
                ],
              ),
            ),
          pdfLib.SizedBox(height: context.pageNumber == 1 ? 10 : 20),
        ],
      );
    }

    // Função para criar rodapé
    pdfLib.Widget buildFooter() {
      return pdfLib.Column(
        children: [
          if (emissionDate != null || expirationDate != null)
            pdfLib.Row(
              mainAxisAlignment: pdfLib.MainAxisAlignment.center,
              children: [
                if (emissionDate != null)
                  pdfLib.Text(
                    'Data de emissão: ${emissionDate!.day.toString().padLeft(2, '0')}/${emissionDate!.month.toString().padLeft(2, '0')}/${emissionDate!.year}',
                    style: pdfLib.TextStyle(fontSize: 10, font: ttfAtkinson),
                  ),
                if (emissionDate != null && expirationDate != null)
                  pdfLib.SizedBox(
                    width: 15,
                  ),
                if (expirationDate != null)
                  pdfLib.Text(
                    'Válido até: ${expirationDate!.day.toString().padLeft(2, '0')}/${expirationDate!.month.toString().padLeft(2, '0')}/${expirationDate!.year}',
                    style: pdfLib.TextStyle(fontSize: 10, font: ttfAtkinson),
                  ),
              ],
            ),
          if (emissionDate != null || expirationDate != null)
            pdfLib.SizedBox(height: 10),
          pdfLib.Center(
            child: pdfLib.Text(
              Helper.formatDateNow(),
              style: pdfLib.TextStyle(fontSize: 12, font: ttfAtkinson),
            ),
          ),
          pdfLib.SizedBox(height: 60),
          pdfLib.Center(
            child: pdfLib.Container(
              color: PdfColors.black,
              height: 2,
              width: 200,
            ),
          ),
          pdfLib.SizedBox(height: 8),
          pdfLib.Center(
            child: pdfLib.Text(
              'Dr(a). ${widget.doctor.name}  ${widget.doctor.registrationNumber}',
              style: pdfLib.TextStyle(fontSize: 12, font: ttfAtkinson),
            ),
          ),
        ],
      );
    }

    pdf.addPage(
      pdfLib.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pdfLib.EdgeInsets.all(32),
        header: (context) => buildHeader(context),
        footer: (context) => buildFooter(),
        build: (pdfLib.Context context) {
          return [
            pdfLib.SizedBox(height: 30),
            pdfLib.Center(
              child: pdfLib.Text(
                'Indicações Automáticas',
                style: pdfLib.TextStyle(
                  font: ttfAtkinson,
                  fontSize: 16,
                  fontWeight: pdfLib.FontWeight.bold,
                ),
              ),
            ),
            pdfLib.SizedBox(height: 20),
            // Usando Table para manter os itens juntos
            pdfLib.Table(
              children: medications.asMap().entries.map((entry) {
                int index = entry.key + 1;
                ItemModel medication = entry.value;

                return pdfLib.TableRow(
                  children: [
                    if (medication.type == 'medication')
                      _buildPdfMedicationDescription(
                          medication, ttfAtkinson, index, formatNumber)
                    else
                      _buildPdfVaccinationDescription(
                          medication, ttfAtkinson, index, formatNumber),
                  ],
                );
              }).toList(),
            ),
          ];
        },
      ),
    );

    final Uint8List bytes = await pdf.save();
    await Printing.layoutPdf(onLayout: (format) => bytes);
  }

  // Função auxiliar para medicações no PDF
  pdfLib.Widget _buildPdfMedicationDescription(ItemModel medication,
      pdfLib.Font font, int index, Function formatNumber) {
    return pdfLib.Container(
      width: 500,
      child: pdfLib.Column(
        crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
        children: [
          pdfLib.Container(
            child: pdfLib.Row(
              mainAxisSize: pdfLib.MainAxisSize.max,
              children: [
                pdfLib.Container(
                  width: 30,
                  child: pdfLib.Text(
                    '${formatNumber(index)}.',
                    style: pdfLib.TextStyle(
                      font: font,
                      fontSize: 14,
                      fontWeight: pdfLib.FontWeight.bold,
                      color: PdfColors.black,
                    ),
                  ),
                ),
                pdfLib.Expanded(
                  child: pdfLib.Text(
                    '${medication.entity.tradeName} (${medication.entity.presentation} ${medication.entity.activeIngredient} - ${medication.entity.activeIngredientConcentration}) mg/ml',
                    style: pdfLib.TextStyle(
                      font: font,
                      fontSize: 14,
                      fontWeight: pdfLib.FontWeight.bold,
                      color: PdfColors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          pdfLib.SizedBox(height: 4),
          pdfLib.Padding(
            padding: const pdfLib.EdgeInsets.only(left: 30),
            child: pdfLib.Text(
              medication.instructions.prescription,
              style: pdfLib.TextStyle(
                font: font,
                fontSize: 12,
                color: PdfColors.black,
              ),
            ),
          ),
          pdfLib.SizedBox(height: 10),
        ],
      ),
    );
  }

  // Função auxiliar para vacinações no PDF
  pdfLib.Widget _buildPdfVaccinationDescription(ItemModel medication,
      pdfLib.Font font, int index, Function formatNumber) {
    return pdfLib.Container(
      width: 500,
      child: pdfLib.Column(
        crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
        children: [
          pdfLib.Container(
            child: pdfLib.Row(
              mainAxisSize: pdfLib.MainAxisSize.max,
              children: [
                pdfLib.Container(
                  width: 30,
                  child: pdfLib.Text(
                    '${formatNumber(index)}.',
                    style: pdfLib.TextStyle(
                      font: font,
                      fontSize: 14,
                      fontWeight: pdfLib.FontWeight.bold,
                      color: PdfColors.black,
                    ),
                  ),
                ),
                pdfLib.Expanded(
                  child: pdfLib.Text(
                    '${medication.entity.vaccineName}',
                    style: pdfLib.TextStyle(
                      font: font,
                      fontSize: 14,
                      fontWeight: pdfLib.FontWeight.bold,
                      color: PdfColors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          pdfLib.SizedBox(height: 4),
          pdfLib.Padding(
            padding: const pdfLib.EdgeInsets.only(left: 30),
            child: pdfLib.Text(
              'Aplicar ${medication.entity.doseNumber} dose',
              style: pdfLib.TextStyle(
                font: font,
                fontSize: 12,
                color: PdfColors.black,
              ),
            ),
          ),
          pdfLib.SizedBox(height: 10),
        ],
      ),
    );
  }
}
