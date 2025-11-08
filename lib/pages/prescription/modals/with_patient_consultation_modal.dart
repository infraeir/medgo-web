// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get_it/get_it.dart';
import 'package:medgo/pages/patients/widgets/crud_patient_modal.dart';
import 'package:medgo/pages/prescription/prescription_binding.dart';
import 'package:medgo/pages/prescription/widgets/new_prescription_list.dart';
import 'package:medgo/widgets/load/load_ball.dart';
import 'package:medgo/widgets/prescription/prescription_forms/form_prescription_medgo.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:printing/printing.dart';

import 'package:medgo/data/blocs/prescription/prescription_bloc.dart';
import 'package:medgo/data/blocs/prescription/prescription_event.dart';
import 'package:medgo/data/blocs/prescription/prescription_state.dart';
import 'package:medgo/data/blocs/patients/patients_service_bloc.dart';
import 'package:medgo/data/blocs/patients/patients_service_event.dart';
import 'package:medgo/data/blocs/patients/patients_service_state.dart';
import 'package:medgo/data/models/doctor_model.dart';
import 'package:medgo/data/models/prescription_response_model.dart';
import 'package:medgo/data/models/system_prescription_model.dart';
import 'package:medgo/data/models/prescription_item_model.dart';
import 'package:medgo/data/models/patients_model.dart';
import 'package:medgo/helper/helper.dart';
import 'package:medgo/pages/prescription/base/base_prescription_modal.dart';
import 'package:medgo/pages/prescription/widgets/prescription_header.dart';
import 'package:medgo/pages/prescription/widgets/prescription_footer.dart';
import 'package:medgo/pages/prescription/enums/prescription_type.dart';
import 'package:medgo/strings/strings.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/button/primary_button.dart';
import 'package:medgo/widgets/dialogs/dialog.dart';
import 'package:medgo/widgets/prescription/new_system_medical_prescription.dart';
import 'package:medgo/widgets/prescription/new_custom_prescription.dart';

import 'package:medgo/widgets/select_medication/select_medication.dart';

/// Modal específico para prescrição durante consulta ativa
/// - Paciente já selecionado e vinculado à consulta
/// - Lista de indicações baseada no diagnóstico
/// - Select de medicamentos disponível
/// - Pode EDITAR informações do paciente
/// - NÃO pode TROCAR paciente (vinculado à consulta)
/// - Impressão: Exibe nome completo e informações do paciente
class WithPatientConsultationModal extends BasePrescriptionModal {
  final String consultationId;
  final DoctorModel doctor;
  final PatientsModel patient;
  final String? peso;

  const WithPatientConsultationModal({
    super.key,
    required this.consultationId,
    required this.doctor,
    required this.patient,
    this.peso,
  });

  @override
  State<WithPatientConsultationModal> createState() =>
      _WithPatientConsultationModalState();
}

class _WithPatientConsultationModalState
    extends BasePrescriptionModalState<WithPatientConsultationModal> {
  late final PrescriptionBloc _prescriptionBloc;
  late final PatientsBloc _patientsBloc;
  late StreamSubscription _prescriptionSubscription;
  late StreamSubscription _patientsSubscription;

  PrescriptionResponseModel? prescriptionResponse;
  List<SystemPrescriptionModel> prescriptionsVacination = [];
  List<SystemPrescriptionModel> prescriptionsMedication = [];
  List<PrescriptionItemModel> customPrescriptions = [];
  bool loaded = false;
  late PatientsModel patient;
  DateTime? emissionDate;
  DateTime? expirationDate;
  bool showPrintPreview = true;

  @override
  void initState() {
    super.initState();
    setUpPrescription();
    _prescriptionBloc = GetIt.I<PrescriptionBloc>();
    _patientsBloc = GetIt.I<PatientsBloc>();
    _getPrescriptionBloc();
    patient = widget.patient;
    // Inicializa a data de emissão com a data atual
    emissionDate = DateTime.now();
    _listenEvents();
  }

  void _getPrescriptionBloc() {
    _prescriptionBloc.add(
      GetNewPrescriptions(
        consultationId: widget.consultationId,
        calculatorId: null,
      ),
    );
  }

  void _getPaciente() {
    _patientsBloc.add(
      GetPatient(id: widget.patient.id),
    );
  }

  void _listenEvents() {
    _prescriptionSubscription = _prescriptionBloc.stream.listen(
      (state) {
        if (!mounted) return; // Verificar se widget ainda está montado

        if (state is PrescriptionsNewByIdLoaded) {
          _handleNewPrescriptionsLoaded(state);
        } else if (state is PrescriptionError) {
          _handlePrescriptionError(state);
        }
        // Removido o reload automático - mantém apenas a atualização otimística local
      },
      onError: (error) {
        if (mounted) {
          print('Erro no stream de prescrição: $error');
        }
      },
    );

    _patientsSubscription = _patientsBloc.stream.listen(
      (state) {
        if (!mounted) return; // Verificar se widget ainda está montado

        if (state is PatientLoaded) {
          setState(() {
            patient = state.patient;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          print('Erro no stream de pacientes: $error');
        }
      },
    );
  }

  @override
  void dispose() {
    _prescriptionSubscription.cancel();
    _patientsSubscription.cancel();
    super.dispose();
  }

  void _handleNewPrescriptionsLoaded(PrescriptionsNewByIdLoaded state) {
    setState(() {
      loaded = true;
      prescriptionResponse = state.prescription;
      prescriptionsMedication.clear();
      prescriptionsVacination.clear();
      customPrescriptions.clear();

      // Processar prescrições do sistema
      for (var systemPrescription in state.prescription.system) {
        // Verificar se tem itens e qual o tipo baseado no primeiro item
        if (systemPrescription.items.isNotEmpty) {
          // Usar o tipo do primeiro item para categorizar
          final firstItemType = systemPrescription.items.first.type;
          if (firstItemType == 'medication') {
            prescriptionsMedication.add(systemPrescription);
          } else if (firstItemType == 'vaccination') {
            prescriptionsVacination.add(systemPrescription);
          }
        }
      }

      customPrescriptions.addAll(state.prescription.custom);
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
    // Atualização otimista local primeiro para feedback imediato da UI
    // Usar uma abordagem mais eficiente para evitar re-renderizações desnecessárias

    // Atualizar nas medicações de forma mais eficiente
    bool medicationUpdated = false;
    for (int prescriptionIndex = 0;
        prescriptionIndex < prescriptionsMedication.length;
        prescriptionIndex++) {
      final prescription = prescriptionsMedication[prescriptionIndex];
      for (int itemIndex = 0;
          itemIndex < prescription.items.length;
          itemIndex++) {
        if (prescription.items[itemIndex].id == prescriptionItemId) {
          // Atualizar diretamente o item sem criar novos objetos desnecessários
          prescription.items[itemIndex] =
              prescription.items[itemIndex].copyWith(isChosen: isChosen);
          medicationUpdated = true;
          break;
        }
      }
      if (medicationUpdated) break;
    }

    // Atualizar nas vacinações de forma mais eficiente
    if (!medicationUpdated) {
      for (int prescriptionIndex = 0;
          prescriptionIndex < prescriptionsVacination.length;
          prescriptionIndex++) {
        final prescription = prescriptionsVacination[prescriptionIndex];
        for (int itemIndex = 0;
            itemIndex < prescription.items.length;
            itemIndex++) {
          if (prescription.items[itemIndex].id == prescriptionItemId) {
            // Atualizar diretamente o item sem criar novos objetos desnecessários
            prescription.items[itemIndex] =
                prescription.items[itemIndex].copyWith(isChosen: isChosen);
            break;
          }
        }
      }
    }

    // Apenas chamar setState uma vez após todas as atualizações
    if (mounted) {
      setState(() {
        // O estado já foi atualizado acima, apenas força a reconstrução
      });
    }

    // Depois envia para o backend
    _prescriptionBloc.add(NewPatchPrescription(
      prescriptionItemId: prescriptionItemId,
      isChosen: isChosen,
    ));
  }

  void _deleteCustomPrescription({
    required String prescriptionItemId,
  }) {
    // Atualização otimista: remover da lista local
    setState(() {
      customPrescriptions.removeWhere((e) => e.id == prescriptionItemId);
    });

    // Dispatch para remover no backend
    _prescriptionBloc.add(
      DeleteCustomPrescription(
        prescriptionItemId: prescriptionItemId,
        prescriptionId: prescriptionResponse?.id ?? '',
      ),
    );
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

  // Header callbacks - específicos para consulta
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
        'Visualização de impressão ${showPrintPreview ? 'ativada' : 'desativada'} para consulta ${widget.consultationId}');
  }

  void _onNavigateBack() {
    Navigator.pop(context);
  }

  void _onDeletePrescription() {
    // TODO: Implementar exclusão de prescrição da consulta
    print('Excluir prescrição da consulta ${widget.consultationId}');
  }

  void _onCopyPrescription() {
    List<PrescriptionItemModel> allItems = [];

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

    // TODO: Implementar formatação das medicações para texto
    // O código foi comentado pois os campos foram alterados no modelo
    for (var item in allItems) {
      allMedicationsText +=
          '${item.entities.first.tradeName} - ${item.instructions.prescription}\n\n';
    }

    // Copia para clipboard
    Clipboard.setData(ClipboardData(text: allMedicationsText.trim()));

    // Mostra toast de sucesso
    showToast(
      'Prescrição da consulta copiada com sucesso!',
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
    List<PrescriptionItemModel> allItems = [];

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

    // Gera e abre PDF para impressão usando isolate
    _generatePDFAsync(allItems);
  }

  void _onSavePrescription() {
    // TODO: Implementar salvamento específico para consulta
    print('Salvar prescrição da consulta ${widget.consultationId}');
  }

  @override
  Widget buildHeader() {
    return PrescriptionHeader(
      prescriptionType: PrescriptionType.withPatientDuringConsultation,
      patient: patient,
      onClose: () => Navigator.pop(context),
      onEditPatient: _onEditPatient,
      // Não tem onChangePatient nem onSelectPatient pois está vinculado à consulta
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
              // Select de medicamentos sempre disponível na consulta
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
                            prescriptionId: prescriptionResponse?.id ?? '',
                            medication: medication,
                            prescriptionBloc: _prescriptionBloc,
                          );
                        },
                      );

                      if (result == true) {
                        _reloadPrescriptions();
                      }
                    }
                  },
                  hintText: 'Procurar...',
                  enabled: true,
                  maxHeight: 300.0,
                ),
              ),
              const SizedBox(height: 16),

              // Visualização das prescrições customizadas
              if (loaded && customPrescriptions.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: NewCustomPrescription(
                    customPrescriptions: customPrescriptions,
                    onUpdatePrescription: (
                        {required String prescriptionItemId}) {
                      _deleteCustomPrescription(
                        prescriptionItemId: prescriptionItemId,
                      );
                    },
                  ),
                ),
              if (loaded && customPrescriptions.isNotEmpty)
                const SizedBox(height: 16),

              if (!loaded)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4 - 100,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const LoadingAnimation(),
                        const SizedBox(height: 16),
                        Text(
                          'Carregando prescrições...',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Column(
                  children: [
                    NewPrescriptionList(
                      title: 'Medicações',
                      prescriptions: prescriptionsMedication,
                      onPrescriptionUpdated: (id, chosen) =>
                          _updatePrescription(
                        prescriptionItemId: id,
                        isChosen: chosen,
                      ),
                      onReload: _reloadPrescriptions,
                      consultationId: widget.consultationId,
                      calculatorId: null,
                      prescriptionBloc: _prescriptionBloc,
                    ),
                    const SizedBox(height: 10),
                    NewPrescriptionList(
                      title: 'Vacinações',
                      prescriptions: prescriptionsVacination,
                      onPrescriptionUpdated: (id, chosen) =>
                          _updatePrescription(
                        prescriptionItemId: id,
                        isChosen: chosen,
                      ),
                      onReload: _reloadPrescriptions,
                      consultationId: widget.consultationId,
                      calculatorId: null,
                      prescriptionBloc: _prescriptionBloc,
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 15),
          // Preview da prescrição se houver itens selecionados e visualização ativada
          //TODO: Ajustar para nova SystemMedicalPrescription
          if (_hasSelectedItems() && showPrintPreview)
            NewSystemMedicalPrescription(
              doctor: widget.doctor,
              prescriptionsVacination: prescriptionsVacination,
              prescriptionsMedication: prescriptionsMedication,
            )
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

  // Método otimizado que usa isolate para não bloquear a UI
  Future<void> _generatePDFAsync(
      List<PrescriptionItemModel> medications) async {
    // Mostrar loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Preparar dados para o isolate
      final pdfData = PDFData(
        medications: medications,
        patientName: patient.name,
        patientAge: patient.age,
        patientWeight: widget.peso ?? '',
        doctorName: widget.doctor.name ?? 'Dr(a).',
        doctorRegistration: widget.doctor.registrationNumber ?? '',
        emissionDate: emissionDate,
        expirationDate: expirationDate,
      );

      // Executar geração de PDF em isolate
      final pdfBytes = await compute(_generatePDFIsolate, pdfData);

      // Fechar loading
      if (mounted) Navigator.of(context).pop();

      // Abrir PDF
      await Printing.layoutPdf(onLayout: (format) => pdfBytes);
    } catch (e) {
      // Fechar loading em caso de erro
      if (mounted) Navigator.of(context).pop();

      showToast(
        'Erro ao gerar PDF: $e',
        context: context,
        axis: Axis.horizontal,
        alignment: Alignment.center,
        position: StyledToastPosition.top,
        animation: StyledToastAnimation.slideFromTopFade,
        reverseAnimation: StyledToastAnimation.fade,
        backgroundColor: AppTheme.error,
        textStyle: const TextStyle(color: Colors.white),
        duration: const Duration(seconds: 3),
        borderRadius: BorderRadius.circular(8),
      );
    }
  }

  // Função isolada para geração de PDF
  static Future<Uint8List> _generatePDFIsolate(PDFData data) async {
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
              'Receita Médica - Consulta',
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
                pdfLib.TextSpan(text: '${data.patientName} '),
                pdfLib.TextSpan(
                  text: 'Idade: ',
                  style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                ),
                pdfLib.TextSpan(text: '${data.patientAge} anos '),
                pdfLib.TextSpan(
                  text: 'Peso: ',
                  style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                ),
                pdfLib.TextSpan(text: '${data.patientWeight} kg'),
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
          if (data.emissionDate != null || data.expirationDate != null)
            pdfLib.Row(
              mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
              children: [
                if (data.emissionDate != null)
                  pdfLib.Text(
                    'Data de emissão: ${data.emissionDate!.day.toString().padLeft(2, '0')}/${data.emissionDate!.month.toString().padLeft(2, '0')}/${data.emissionDate!.year}',
                    style: pdfLib.TextStyle(fontSize: 10, font: ttfAtkinson),
                  ),
                if (data.expirationDate != null)
                  pdfLib.Text(
                    'Válido até: ${data.expirationDate!.day.toString().padLeft(2, '0')}/${data.expirationDate!.month.toString().padLeft(2, '0')}/${data.expirationDate!.year}',
                    style: pdfLib.TextStyle(fontSize: 10, font: ttfAtkinson),
                  ),
              ],
            ),
          if (data.emissionDate != null || data.expirationDate != null)
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
              'Dr(a). ${data.doctorName}  ${data.doctorRegistration}',
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
              children: data.medications.asMap().entries.map((entry) {
                int index = entry.key + 1;
                PrescriptionItemModel medication = entry.value;

                return pdfLib.TableRow(
                  children: [
                    if (medication.type == 'medication')
                      _buildPdfMedicationDescriptionIsolate(
                          medication, ttfAtkinson, index, formatNumber)
                    else
                      _buildPdfVaccinationDescriptionIsolate(
                          medication, ttfAtkinson, index, formatNumber),
                  ],
                );
              }).toList(),
            ),
          ];
        },
      ),
    );

    return await pdf.save();
  }
}

// Classe para dados do PDF que será serializada para o isolate
class PDFData {
  final List<PrescriptionItemModel> medications;
  final String patientName;
  final String patientAge;
  final String patientWeight;
  final String doctorName;
  final String doctorRegistration;
  final DateTime? emissionDate;
  final DateTime? expirationDate;

  PDFData({
    required this.medications,
    required this.patientName,
    required this.patientAge,
    required this.patientWeight,
    required this.doctorName,
    required this.doctorRegistration,
    this.emissionDate,
    this.expirationDate,
  });
}

// Funções auxiliares para o isolate
pdfLib.Widget _buildPdfMedicationDescriptionIsolate(
    PrescriptionItemModel medication,
    pdfLib.Font font,
    int index,
    Function formatNumber) {
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
                  '${medication.entities.first.tradeName} (${medication.entities.first.type} ',
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

pdfLib.Widget _buildPdfVaccinationDescriptionIsolate(
    PrescriptionItemModel medication,
    pdfLib.Font font,
    int index,
    Function formatNumber) {
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
                  '${medication.entities.first.tradeName}',
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
            '${medication.instructions.prescription}',
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
