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
import 'package:phosphor_flutter/phosphor_flutter.dart';
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
import 'package:medgo/widgets/select_patient/select_patient.dart';

/// Modal específico para prescrição com seleção obrigatória de paciente
/// - Obrigatoriamente deve selecionar paciente primeiro
/// - Select de medicamentos só aparece após seleção do paciente
/// - Deve ser criado um select de pacientes (comportamento igual ao de medicamentos)
/// - NÃO há indicações automáticas
/// - Pode TROCAR e EDITAR paciente após seleção
/// - Impressão: Exibe informações do paciente selecionado
class WithoutPatientSelectionModal extends BasePrescriptionModal {
  final DoctorModel doctor;

  const WithoutPatientSelectionModal({
    super.key,
    required this.doctor,
  });

  @override
  State<WithoutPatientSelectionModal> createState() =>
      _WithoutPatientSelectionModalState();
}

class _WithoutPatientSelectionModalState
    extends BasePrescriptionModalState<WithoutPatientSelectionModal> {
  late final PrescriptionBloc _prescriptionBloc;
  late final PatientsBloc _patientsBloc;
  List<NewPrescriptionModel> prescriptionsVacination = [];
  List<NewPrescriptionModel> prescriptionsMedication = [];
  bool loaded = false;
  PatientsModel? selectedPatient;
  DateTime? emissionDate;
  DateTime? expirationDate;
  bool showPrintPreview = false;

  @override
  void initState() {
    super.initState();
    setUpPrescription();
    _prescriptionBloc = GetIt.I<PrescriptionBloc>();
    _patientsBloc = GetIt.I<PatientsBloc>();
    // Inicializa a data de emissão com a data atual
    emissionDate = DateTime.now();
    // Para prescrição com seleção obrigatória, começamos sem paciente
    loaded = true;
    _listenEvents();
  }

  void _listenEvents() {
    _patientsBloc.stream.listen((state) {
      if (state is PatientLoaded) {
        setState(() {
          selectedPatient = state.patient;
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

  // Header callbacks - específicos para seleção obrigatória
  void _onSelectPatient() async {
    // TODO: Implementar seleção de paciente via modal ou dropdown
    print('Seleção obrigatória de paciente');
  }

  void _onChangePatient() {
    setState(() {
      selectedPatient = null;
      // Limpa as prescrições quando troca de paciente
      prescriptionsMedication.clear();
      prescriptionsVacination.clear();
    });
  }

  void _onEditPatient() async {
    if (selectedPatient == null) return;

    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CrudPatientModal(
          patient: selectedPatient!,
        );
      },
    );
    if (result == 'true') {
      _patientsBloc.add(
        GetPatient(id: selectedPatient!.id),
      );
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
        'Visualização de impressão ${showPrintPreview ? 'ativada' : 'desativada'} ${selectedPatient != null ? 'para paciente ${selectedPatient!.name}' : 'sem paciente selecionado'}');
  }

  void _onNavigateBack() {
    Navigator.of(context).pop();
  }

  void _onDeletePrescription() {
    // TODO: Implementar exclusão de prescrição
    print(
        'Excluir prescrição${selectedPatient != null ? ' para paciente ${selectedPatient!.name}' : ''}');
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
      selectedPatient != null
          ? 'Prescrição para ${selectedPatient!.name} copiada com sucesso!'
          : 'Prescrição copiada com sucesso!',
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
    // TODO: Implementar salvamento específico para prescrição com seleção obrigatória
    print(
        'Salvar prescrição${selectedPatient != null ? ' para paciente ${selectedPatient!.name}' : ''}');
  }

  @override
  Widget buildHeader() {
    return PrescriptionHeader(
      prescriptionType: selectedPatient != null
          ? PrescriptionType.withPatientOutsideConsultation
          : PrescriptionType.withoutPatientNeedSelection,
      patient: selectedPatient,
      onClose: () => Navigator.pop(context),
      onSelectPatient: _onSelectPatient,
      onChangePatient: selectedPatient != null ? _onChangePatient : null,
      onEditPatient: selectedPatient != null ? _onEditPatient : null,
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
      padding: EdgeInsets.only(
        top: selectedPatient != null
            ? 105
            : 80, // 105 quando há paciente (igual ao WithPatientOutsideModal), 80 quando não há
        bottom: 110,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Se NÃO há paciente selecionado, mostra o seletor
          if (selectedPatient == null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: 800,
                      child: SelectPatientMedGo(
                        selectedPatient: selectedPatient,
                        onChanged: (patient) {
                          setState(() {
                            selectedPatient = patient;
                            prescriptionsMedication.clear();
                            prescriptionsVacination.clear();
                          });
                          print('Paciente selecionado: ${patient?.name}');
                        },
                        hintText: 'Selecione um paciente para prescrever...',
                        enabled: true,
                        maxHeight: 300.0,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryBackground,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppTheme.warning,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.35),
                            blurRadius: 25,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            PhosphorIcons.warning(PhosphorIconsStyle.regular),
                            color: AppTheme.warning,
                            size: 48,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 1.5,
                                offset: const Offset(0.25, 1),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Column(
                            children: [
                              Text(
                                'Para quem é o documento? \nEscolha um paciente para prescrever.',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppTheme.warning,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ] else ...[
            // Se HÁ paciente selecionado, comporta-se como WithPatientOutsideModal
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
                              'Prescrição para ${selectedPatient!.name}',
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
              ],
            ),
          ],

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

          const SizedBox(height: 15),
          // Preview da prescrição se houver itens selecionados, paciente selecionado e visualização ativada
          if (selectedPatient != null &&
              _hasSelectedItems() &&
              showPrintPreview)
            MedicalPrescription(
              patient: selectedPatient!,
              doctor: widget.doctor,
              peso: null, // TODO: Pegar peso do paciente se disponível
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
          // Só exibe informações do paciente se houver um paciente selecionado
          if (selectedPatient != null)
            pdfLib.RichText(
              text: pdfLib.TextSpan(
                style: pdfLib.TextStyle(font: ttfAtkinson, fontSize: 14),
                children: [
                  pdfLib.TextSpan(
                    text: 'Paciente: ',
                    style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                  ),
                  pdfLib.TextSpan(text: '${selectedPatient!.name} '),
                  pdfLib.TextSpan(
                    text: 'Idade: ',
                    style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                  ),
                  pdfLib.TextSpan(text: '${selectedPatient!.age} anos'),
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
