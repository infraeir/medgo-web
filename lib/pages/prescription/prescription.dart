// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:medgo/widgets/prescription/prescription_forms/form_prescription_medgo.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:printing/printing.dart';
import 'package:medgo/helper/helper.dart';

import 'package:medgo/data/blocs/prescription/prescription_bloc.dart';
import 'package:medgo/data/blocs/prescription/prescription_event.dart';
import 'package:medgo/data/blocs/prescription/prescription_state.dart';
import 'package:medgo/data/models/doctor_model.dart';
import 'package:medgo/data/models/new_prescription_model.dart';
import 'package:medgo/data/models/patients_model.dart';
import 'package:medgo/pages/prescription/prescription_binding.dart';
import 'package:medgo/strings/strings.dart';
import 'package:medgo/widgets/button/primary_button.dart';
import 'package:medgo/widgets/dialogs/dialog.dart';
import 'package:medgo/widgets/load/load_ball.dart';
import 'package:medgo/widgets/prescription/medical_prescription.dart';
import 'package:medgo/pages/prescription/widgets/prescription_list.dart';
import 'package:medgo/pages/prescription/widgets/prescription_header.dart';
import 'package:medgo/pages/prescription/widgets/prescription_footer.dart';
import 'package:medgo/pages/prescription/enums/prescription_type.dart';
import 'package:medgo/widgets/scrollbar/custom_scroll_bar.dart';
import 'package:medgo/widgets/select_medication/select_medication.dart';
import '../../themes/app_theme.dart';

class NewPrescriptionModal extends StatefulWidget {
  final String? consultationId;
  final String? calculatorId;
  final String? peso;
  final DoctorModel doctor;
  final PatientsModel? patient;
  final PrescriptionType prescriptionType;

  const NewPrescriptionModal({
    super.key,
    this.consultationId,
    this.calculatorId,
    required this.doctor,
    this.peso,
    this.patient,
    this.prescriptionType = PrescriptionType.withoutPatient,
  });

  @override
  State<NewPrescriptionModal> createState() => _NewPrescriptionModalState();
}

class _NewPrescriptionModalState extends State<NewPrescriptionModal> {
  late final PrescriptionBloc _prescriptionBloc;
  List<NewPrescriptionModel> prescriptionsVacination = [];
  List<NewPrescriptionModel> prescriptionsMedication = [];
  late ScrollController scrollController;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    setUpPrescription();
    _prescriptionBloc = GetIt.I<PrescriptionBloc>();
    scrollController = ScrollController();
    _getPrescriptionBloc();
    _listenEvents();
  }

  void _getPrescriptionBloc() {
    _prescriptionBloc.add(
      GetPrescriptions(
        consultationId: widget.consultationId,
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
        title: const Text("Peso do paciente"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(32),
        content: const Text(
          'Adicione o peso do paciente para ter acesso as prescrições',
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

  // Header callbacks
  void _onChangePatient() {
    // TODO: Implementar lógica para trocar paciente
    print('Trocar paciente');
  }

  void _onEditPatient() {
    // TODO: Implementar lógica para editar paciente
    print('Editar paciente');
  }

  void _onSelectPatient() {
    // TODO: Implementar lógica para selecionar paciente
    print('Selecionar paciente');
  }

  // Footer callbacks
  void _onEmissionDateChanged(DateTime? date) {
    if (date != null) {
      print(
          'Data de emissão selecionada: ${date.day}/${date.month}/${date.year}');
    }
  }

  void _onExpirationDateChanged(DateTime? date) {
    if (date != null) {
      print(
          'Data de validade selecionada: ${date.day}/${date.month}/${date.year}');
    }
  }

  void _onPreviewPrint() {
    // TODO: Implementar visualização de impressão
    print('Visualizar impressão');
  }

  void _onNavigateBack() {
    // TODO: Implementar navegação para trás
    print('Navegar para trás');
  }

  void _onDeletePrescription() {
    // TODO: Implementar exclusão de prescrição
    print('Excluir prescrição');
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
        'Nenhuma medicação selecionada!',
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
      'Todas as medicações copiadas para a área de transferência!',
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
        'Nenhuma medicação selecionada para impressão!',
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
    // TODO: Implementar salvamento
    print('Salvar prescrição');
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
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
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
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 5),
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 20.0,
                  ),
                  child: CustomScrollbar(
                    trackMargin: const EdgeInsets.only(
                      top: 100,
                      bottom: 100,
                    ),
                    controller: scrollController,
                    child: Builder(builder: (context) {
                      return ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          scrollbars: false,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: _buildContent(),
                        ),
                      );
                    }),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 5.0,
                          sigmaY: 5.0,
                          tileMode: TileMode.clamp,
                        ),
                        child: PrescriptionHeader(
                          prescriptionType: widget.prescriptionType,
                          patient: widget.patient,
                          onClose: () => Navigator.pop(context),
                          onChangePatient: _onChangePatient,
                          onEditPatient: _onEditPatient,
                          onSelectPatient: _onSelectPatient,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 5.0,
                          sigmaY: 5.0,
                          tileMode: TileMode.clamp,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 8,
                          ),
                          child: PrescriptionFooter(
                            showPreview:
                                false, // Modal genérico não usa preview
                            onEmissionDateChanged: _onEmissionDateChanged,
                            onExpirationDateChanged: _onExpirationDateChanged,
                            onPreviewPrint: _onPreviewPrint,
                            onNavigateBack: _onNavigateBack,
                            onDeletePrescription: _onDeletePrescription,
                            onCopyPrescription: _onCopyPrescription,
                            onPrintPrescription: _onPrintPrescription,
                            onSavePrescription: _onSavePrescription,
                          ),
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

  Widget _buildContent() {
    if (prescriptionsMedication.isEmpty && prescriptionsVacination.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 105, bottom: 110),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              SizedBox(
                width: 800,
                child: SelectMedicationMedGo(
                  selectedMedication: null,
                  onChanged: (medication) async {
                    print('medication $medication');
                    var result = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return FormPrescriptionMedgoModal(
                          prescriptionId: '',
                          medication: medication!,
                          prescriptionBloc: _prescriptionBloc,
                        );
                      },
                    );

                    if (result == true) {
                      _reloadPrescriptions();
                    }
                  },
                  hintText: 'Procurar...',
                  enabled: true,
                  maxHeight: 300.0,
                ),
              ),
              const SizedBox(height: 16),
              PrescriptionList(
                prescriptions: prescriptionsMedication,
                listIndex: 0,
                onUpdatePrescription: _updatePrescription,
                onReload: _reloadPrescriptions,
                consultationId: widget.consultationId,
                calculatorId: widget.calculatorId,
                prescriptionBloc: _prescriptionBloc,
              ),
              const SizedBox(height: 10),
              PrescriptionList(
                prescriptions: prescriptionsVacination,
                listIndex: 1,
                onUpdatePrescription: _updatePrescription,
                onReload: _reloadPrescriptions,
                consultationId: widget.consultationId,
                calculatorId: widget.calculatorId,
                prescriptionBloc: _prescriptionBloc,
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (_hasSelectedItems())
            MedicalPrescription(
              patient: widget.patient,
              doctor: widget.doctor,
              peso: widget.peso,
              prescriptionsMedication: prescriptionsMedication,
              prescriptionsVacination: prescriptionsVacination,
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
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
                    const LoadingAnimation()
                  else
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          'Nenhuma uma prescrição disponível ainda!',
                          style: AppTheme.h3(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Para visualizar as prescrições é necessário aceitar as sugestões diagnósticas e adicionar o peso no exame físico.',
                          style: AppTheme.h5(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        SvgPicture.asset(
                          "images/image_empty.svg",
                          height: 200,
                        ),
                      ],
                    ),
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
              'Receita Médica',
              style: pdfLib.TextStyle(
                font: ttfAtkinson,
                fontSize: 18,
                fontWeight: pdfLib.FontWeight.bold,
              ),
            ),
          ),
          // Adiciona padding extra se não for a primeira página
          pdfLib.SizedBox(height: context.pageNumber == 1 ? 20 : 40),
          pdfLib.RichText(
            text: pdfLib.TextSpan(
              style: pdfLib.TextStyle(
                font: ttfAtkinson,
                fontSize: 14,
              ),
              children: [
                pdfLib.TextSpan(
                  text: 'Paciente: ',
                  style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                ),
                pdfLib.TextSpan(text: '${widget.patient?.name ?? ''}    '),
                pdfLib.TextSpan(
                  text: 'Idade: ',
                  style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                ),
                pdfLib.TextSpan(text: '${widget.patient?.age ?? ''}    '),
                pdfLib.TextSpan(
                  text: 'Peso: ',
                  style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                ),
                pdfLib.TextSpan(text: '${widget.peso ?? ''} g'),
              ],
            ),
          ),
          // Adiciona padding extra se não for a primeira página
          pdfLib.SizedBox(height: context.pageNumber == 1 ? 0 : 20),
        ],
      );
    }

    // Função para criar rodapé
    pdfLib.Widget buildFooter() {
      return pdfLib.Column(
        children: [
          pdfLib.Center(
            child: pdfLib.Text(
              Helper.formatDateNow(),
              style: pdfLib.TextStyle(
                fontSize: 12,
                font: ttfAtkinson,
              ),
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
              style: pdfLib.TextStyle(
                fontSize: 12,
                font: ttfAtkinson,
              ),
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
                'VIA ORAL',
                style: pdfLib.TextStyle(
                  font: ttfAtkinson,
                  fontSize: 16,
                  fontWeight: pdfLib.FontWeight.bold,
                  decoration: pdfLib.TextDecoration.underline,
                ),
              ),
            ),
            pdfLib.SizedBox(height: 20),
            // Usando Table para manter os itens juntos
            pdfLib.Table(
              children: medications.asMap().entries.map((entry) {
                final index = entry.key;
                final medication = entry.value;
                return pdfLib.TableRow(
                  children: [
                    medication.type == 'medication'
                        ? _buildPdfMedicationDescription(
                            medication, ttfAtkinson, index, formatNumber)
                        : _buildPdfVaccinationDescription(
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
                    '${index + 1}. ',
                    style: pdfLib.TextStyle(
                      font: font,
                      fontSize: 12,
                      fontWeight: pdfLib.FontWeight.bold,
                    ),
                  ),
                ),
                pdfLib.Container(
                  width: 350,
                  child: pdfLib.Text(
                    '${medication.entity.tradeName} (${medication.entity.presentation}, ${medication.entity.activeIngredient} - ${medication.entity.activeIngredientConcentration} mg/ml)',
                    style: pdfLib.TextStyle(
                      font: font,
                      fontSize: 12,
                      fontWeight: pdfLib.FontWeight.bold,
                    ),
                  ),
                ),
                pdfLib.Container(
                  width: 120,
                  child: pdfLib.Text(
                    medication.instructions.duration,
                    style: pdfLib.TextStyle(
                      font: font,
                      fontSize: 12,
                      fontWeight: pdfLib.FontWeight.bold,
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
                fontSize: 11,
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
                    '${index + 1}. ',
                    style: pdfLib.TextStyle(
                      font: font,
                      fontSize: 12,
                      fontWeight: pdfLib.FontWeight.bold,
                    ),
                  ),
                ),
                pdfLib.Container(
                  width: 350,
                  child: pdfLib.Text(
                    medication.entity.vaccineName,
                    style: pdfLib.TextStyle(
                      font: font,
                      fontSize: 12,
                      fontWeight: pdfLib.FontWeight.bold,
                    ),
                  ),
                ),
                pdfLib.Container(
                  width: 120,
                  child: pdfLib.Text(
                    '${medication.entity.doseNumber} dose',
                    style: pdfLib.TextStyle(
                      font: font,
                      fontSize: 12,
                      fontWeight: pdfLib.FontWeight.bold,
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
                fontSize: 11,
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
