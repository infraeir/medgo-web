// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get_it/get_it.dart';
import 'package:medgo/pages/patients/widgets/crud_patient_modal.dart';
import 'package:medgo/pages/prescription/prescription_binding.dart';
import 'package:medgo/widgets/prescription/prescription_forms/form_prescription_medgo.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:printing/printing.dart';

import 'package:medgo/data/blocs/prescription/prescription_bloc.dart';
import 'package:medgo/data/blocs/patients/patients_service_bloc.dart';
import 'package:medgo/data/blocs/patients/patients_service_event.dart';
import 'package:medgo/data/blocs/patients/patients_service_state.dart';
import 'package:medgo/data/models/doctor_model.dart';
import 'package:medgo/data/models/new_prescription_model.dart';
import 'package:medgo/data/models/patients_model.dart';
import 'package:medgo/helper/helper.dart';
import 'package:medgo/pages/prescription/base/base_prescription_modal.dart';
import 'package:medgo/pages/prescription/widgets/prescription_header.dart';
import 'package:medgo/pages/prescription/widgets/prescription_footer.dart';
import 'package:medgo/pages/prescription/widgets/prescription_list.dart';
import 'package:medgo/pages/prescription/enums/prescription_type.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/prescription/medical_prescription.dart';

import 'package:medgo/widgets/select_medication/select_medication.dart';

/// Modal específico para prescrição com paciente pré-selecionado fora de consulta
/// - Paciente já selecionado ao abrir o modal
/// - NÃO há indicações automáticas
/// - Select de medicamentos disponível imediatamente
/// - Pode EDITAR informações do paciente
/// - NÃO pode TROCAR paciente (contexto específico)
/// - Impressão: Exibe nome e informações do paciente
class WithPatientOutsideModal extends BasePrescriptionModal {
  final DoctorModel doctor;
  final PatientsModel patient;
  final String? peso;

  const WithPatientOutsideModal({
    super.key,
    required this.doctor,
    required this.patient,
    this.peso,
  });

  @override
  State<WithPatientOutsideModal> createState() =>
      _WithPatientOutsideModalState();
}

class _WithPatientOutsideModalState
    extends BasePrescriptionModalState<WithPatientOutsideModal> {
  late final PrescriptionBloc _prescriptionBloc;
  late final PatientsBloc _patientsBloc;
  List<NewPrescriptionModel> prescriptionsVacination = [];
  List<NewPrescriptionModel> prescriptionsMedication = [];
  bool loaded = false;
  late PatientsModel patient;
  DateTime? emissionDate;
  DateTime? expirationDate;
  bool showPrintPreview = false;

  @override
  void initState() {
    super.initState();
    setUpPrescription();
    _prescriptionBloc = GetIt.I<PrescriptionBloc>();
    _patientsBloc = GetIt.I<PatientsBloc>();
    patient = widget.patient;
    // Inicializa a data de emissão com a data atual
    emissionDate = DateTime.now();
    // Para prescrição fora de consulta, começamos com dados vazios
    loaded = true;
    _listenEvents();
  }

  void _getPaciente() {
    _patientsBloc.add(
      GetPatient(id: widget.patient.id),
    );
  }

  void _listenEvents() {
    _patientsBloc.stream.listen((state) {
      if (state is PatientLoaded) {
        setState(() {
          patient = state.patient;
        });
      }
    });
  }

  bool _hasSelectedItems() {
    bool vacinationHasSelected = prescriptionsVacination
        .any((prescription) => prescription.items.any((item) => item.isChosen));

    bool medicationHasSelected = prescriptionsMedication
        .any((prescription) => prescription.items.any((item) => item.isChosen));

    return vacinationHasSelected || medicationHasSelected;
  }

  // Header callbacks - específicos para paciente fora de consulta
  void _onEditPatient() async {
    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CrudPatientModal(
          patient: patient,
        );
      },
    );
    if (result == 'true') {
      _getPaciente();
    }
  }

  // Footer callbacks
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
        'Visualização de impressão ${showPrintPreview ? 'ativada' : 'desativada'} para paciente ${patient.name}');
  }

  void _onNavigateBack() {
    Navigator.of(context).pop();
  }

  void _onDeletePrescription() {
    // TODO: Implementar exclusão de prescrição fora de consulta
    print('Excluir prescrição para paciente ${patient.name}');
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
      'Prescrição para ${patient.name} copiada com sucesso!',
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
    // TODO: Implementar salvamento específico para paciente fora de consulta
    print('Salvar prescrição para paciente ${patient.name}');
  }

  @override
  Widget buildHeader() {
    return PrescriptionHeader(
      prescriptionType: PrescriptionType.withPatientOutsideConsultation,
      patient: patient,
      onClose: () => Navigator.pop(context),
      onEditPatient: _onEditPatient,
      // Não tem onChangePatient pois não pode trocar paciente neste contexto
    );
  }

  @override
  Widget buildContent() {
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
              // Select de medicamentos sempre disponível
              SizedBox(
                width: 800,
                child: SelectMedicationMedGo(
                  selectedMedication: null,
                  onChanged: (medication) async {
                    if (medication != null) {
                      var result = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return FormPrescriptionMedgoModal(
                            prescriptionId: '',
                            medication: medication,
                            prescriptionBloc: _prescriptionBloc,
                          );
                        },
                      );

                      if (result == true) {}
                    }
                  },
                  hintText: 'Procurar medicamento...',
                  enabled: true,
                  maxHeight: 300.0,
                ),
              ),
              const SizedBox(height: 24),
              // Estado sem medicamentos selecionados
              if (!_hasSelectedItems())
                Container(
                  padding: const EdgeInsets.all(40),
                  margin: const EdgeInsets.only(top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const Icon(
                            Icons.medical_services_outlined,
                            size: 80,
                            color: AppTheme.textPrimary,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Prescrição para ${patient.name}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Selecione medicamentos ou vacinas para prescrever',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.secondaryText,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                ),

              // Lista de medicações (se houver)
              if (prescriptionsMedication.isNotEmpty)
                PrescriptionList(
                  prescriptions: prescriptionsMedication,
                  listIndex: 0,
                  onUpdatePrescription: (
                      {required String prescriptionItemId,
                      required bool isChosen}) {
                    // TODO: Implementar atualização local da prescrição
                  },
                  onReload: () {
                    // TODO: Implementar reload se necessário
                  },
                  consultationId: null,
                  calculatorId: null,
                  prescriptionBloc: _prescriptionBloc,
                ),

              const SizedBox(height: 10),

              // Lista de vacinações (se houver)
              if (prescriptionsVacination.isNotEmpty)
                PrescriptionList(
                  prescriptions: prescriptionsVacination,
                  listIndex: 1,
                  onUpdatePrescription: (
                      {required String prescriptionItemId,
                      required bool isChosen}) {
                    // TODO: Implementar atualização local da prescrição
                  },
                  onReload: () {
                    // TODO: Implementar reload se necessário
                  },
                  consultationId: null,
                  calculatorId: null,
                  prescriptionBloc: _prescriptionBloc,
                ),
            ],
          ),
          const SizedBox(height: 15),
          // Preview da prescrição se houver itens selecionados e visualização ativada
          if (_hasSelectedItems() && showPrintPreview)
            MedicalPrescription(
              patient: patient,
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
          pdfLib.SizedBox(height: context.pageNumber == 1 ? 20 : 40),
          pdfLib.RichText(
            text: pdfLib.TextSpan(
              style: pdfLib.TextStyle(font: ttfAtkinson, fontSize: 14),
              children: [
                pdfLib.TextSpan(
                  text: 'Paciente: ',
                  style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                ),
                pdfLib.TextSpan(text: '${patient.name} '),
                pdfLib.TextSpan(
                  text: 'Idade: ',
                  style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                ),
                pdfLib.TextSpan(text: '${patient.age} anos '),
                if (widget.peso != null) ...[
                  pdfLib.TextSpan(
                    text: 'Peso: ',
                    style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                  ),
                  pdfLib.TextSpan(text: '${widget.peso} kg'),
                ],
              ],
            ),
          ),
          pdfLib.SizedBox(height: context.pageNumber == 1 ? 0 : 20),
        ],
      );
    }

    // Função para criar rodapé
    pdfLib.Widget buildFooter() {
      return pdfLib.Column(
        children: [
          if (emissionDate != null || expirationDate != null)
            pdfLib.Row(
              mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
              children: [
                if (emissionDate != null)
                  pdfLib.Text(
                    'Data de emissão: ${emissionDate!.day.toString().padLeft(2, '0')}/${emissionDate!.month.toString().padLeft(2, '0')}/${emissionDate!.year}',
                    style: pdfLib.TextStyle(fontSize: 10, font: ttfAtkinson),
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
                'Prescrição Médica',
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
