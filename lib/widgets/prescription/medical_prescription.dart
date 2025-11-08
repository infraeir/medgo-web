import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:medgo/data/models/new_prescription_model.dart';
import 'package:medgo/helper/helper.dart';
import 'package:medgo/data/models/doctor_model.dart';
import 'package:medgo/data/models/patients_model.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/icon_button.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';

class MedicalPrescription extends StatefulWidget {
  final DoctorModel doctor;
  final PatientsModel? patient;
  final String? peso;
  final DateTime? emissionDate;
  final DateTime? expirationDate;
  final List<NewPrescriptionModel> prescriptionsVacination;
  final List<NewPrescriptionModel> prescriptionsMedication;

  const MedicalPrescription({
    super.key,
    this.patient,
    required this.doctor,
    required this.prescriptionsVacination,
    required this.prescriptionsMedication,
    this.peso,
    this.emissionDate,
    this.expirationDate,
  });

  @override
  State<MedicalPrescription> createState() => _MedicalPrescriptionState();
}

class _MedicalPrescriptionState extends State<MedicalPrescription> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    List<ItemModel> itensEscolhidos = [];

    for (var prescription in widget.prescriptionsVacination) {
      itensEscolhidos
          .addAll(prescription.items.where((item) => item.isChosen == true));
    }
    for (var prescription in widget.prescriptionsMedication) {
      itensEscolhidos
          .addAll(prescription.items.where((item) => item.isChosen == true));
    }

    TextStyle atkinsonTextStyle(
        {double size = 16,
        FontWeight fontWeight = FontWeight.normal,
        Color color = Colors.black,
        TextDecoration decoration = TextDecoration.none}) {
      return TextStyle(
        fontFamily: 'AtkinsonHyperlegible', // Nome da fonte adicionada
        fontSize: size,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration,
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.1, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
        border: Border.all(width: 1.0, color: Colors.black),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Receita Médica',
                style: atkinsonTextStyle(
                  size: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          // Só exibe informações do paciente se houver um paciente
          if (widget.patient != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: atkinsonTextStyle(size: 16, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Nome: ',
                        style: atkinsonTextStyle(
                            size: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      TextSpan(
                        text: '${widget.patient?.name ?? ''}    ',
                        style: atkinsonTextStyle(size: 16, color: Colors.black),
                      ),
                      TextSpan(
                        text: 'Idade: ',
                        style: atkinsonTextStyle(
                            size: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      TextSpan(
                        text: '${widget.patient?.age ?? ''}    ',
                        style: atkinsonTextStyle(size: 16, color: Colors.black),
                      ),
                      if (widget.peso != null) ...[
                        TextSpan(
                          text: 'Peso: ',
                          style: atkinsonTextStyle(
                              size: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        TextSpan(
                          text: '${widget.peso} g',
                          style:
                              atkinsonTextStyle(size: 16, color: Colors.black),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'VIA ORAL',
                style: atkinsonTextStyle(
                    size: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Column(
            children: itensEscolhidos
                .map((medication) {
                  int index = itensEscolhidos.indexOf(medication);
                  return medication.type == 'medication'
                      ? _getMedicationDescription(
                          medication: medication,
                          index: index,
                        )
                      : _getVacinationDescription(
                          medication: medication,
                          index: index,
                        );
                })
                .toList()
                .cast<Widget>(), // Adicione .cast<Widget>()
          ),
          const SizedBox(
            height: 50,
          ),
          // Datas de emissão e validade se disponíveis
          if (widget.emissionDate != null || widget.expirationDate != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.emissionDate != null)
                  Text(
                    'Data de emissão: ${widget.emissionDate!.day.toString().padLeft(2, '0')}/${widget.emissionDate!.month.toString().padLeft(2, '0')}/${widget.emissionDate!.year}',
                    style: atkinsonTextStyle(
                      size: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (widget.expirationDate != null &&
                    widget.emissionDate != null)
                  const SizedBox(
                    width: 20,
                  ),
                if (widget.expirationDate != null)
                  Text(
                    'Válido até: ${widget.expirationDate!.day.toString().padLeft(2, '0')}/${widget.expirationDate!.month.toString().padLeft(2, '0')}/${widget.expirationDate!.year}',
                    style: atkinsonTextStyle(
                      size: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          if (widget.emissionDate != null || widget.expirationDate != null)
            const SizedBox(height: 20),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.black,
                height: 2,
                width: size.width * 0.15,
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Dr(a). ${widget.doctor.name!}  ',
                style: atkinsonTextStyle(
                  size: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                height: 5,
                width: 5,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                ),
              ),
              Text(
                '  ${widget.doctor.registrationNumber!}',
                style: atkinsonTextStyle(
                  size: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  Future<void> generatePDF(List<ItemModel> medications) async {
    final pdfLib.Document pdf = pdfLib.Document();
    final fontAtkinson =
        await rootBundle.load("assets/fonts/AtkinsonHyperlegible-Regular.ttf");
    final ttfAtkinson = pdfLib.Font.ttf(fontAtkinson);

    // Função auxiliar para formatar números
    String formatNumber(int number) {
      return number.toString().padLeft(2, '0');
    }

    // Função para criar cabeçalho
    pdfLib.Widget _buildHeader(pdfLib.Context context) {
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
          // Só exibe informações do paciente se houver um paciente
          if (widget.patient != null)
            pdfLib.RichText(
              text: pdfLib.TextSpan(
                style: pdfLib.TextStyle(
                  font: ttfAtkinson,
                  fontSize: 14,
                ),
                children: [
                  pdfLib.TextSpan(
                    text: 'Nome: ',
                    style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                  ),
                  pdfLib.TextSpan(text: '${widget.patient?.name ?? ''}    '),
                  pdfLib.TextSpan(
                    text: 'Idade: ',
                    style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                  ),
                  pdfLib.TextSpan(text: '${widget.patient?.age ?? ''}    '),
                  if (widget.peso != null) ...[
                    pdfLib.TextSpan(
                      text: 'Peso: ',
                      style:
                          pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                    ),
                    pdfLib.TextSpan(text: '${widget.peso} g'),
                  ],
                ],
              ),
            ),
          // Adiciona padding extra se não for a primeira página
          pdfLib.SizedBox(height: context.pageNumber == 1 ? 0 : 20),
        ],
      );
    }

    // Função para criar rodapé
    pdfLib.Widget _buildFooter() {
      return pdfLib.Column(
        children: [
          // Datas de emissão e validade se disponíveis
          if (widget.emissionDate != null || widget.expirationDate != null)
            pdfLib.Row(
              mainAxisAlignment: pdfLib.MainAxisAlignment.center,
              children: [
                if (widget.emissionDate != null)
                  pdfLib.Text(
                    'Data de emissão: ${widget.emissionDate!.day.toString().padLeft(2, '0')}/${widget.emissionDate!.month.toString().padLeft(2, '0')}/${widget.emissionDate!.year}',
                    style: pdfLib.TextStyle(fontSize: 10, font: ttfAtkinson),
                  ),
                if (widget.emissionDate != null &&
                    widget.expirationDate != null)
                  pdfLib.SizedBox(
                    width: 20,
                  ),
                if (widget.expirationDate != null)
                  pdfLib.Text(
                    'Válido até: ${widget.expirationDate!.day.toString().padLeft(2, '0')}/${widget.expirationDate!.month.toString().padLeft(2, '0')}/${widget.expirationDate!.year}',
                    style: pdfLib.TextStyle(fontSize: 10, font: ttfAtkinson),
                  ),
              ],
            ),
          if (widget.emissionDate != null || widget.expirationDate != null)
            pdfLib.SizedBox(height: 10),
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
              'Dr(a). ${widget.doctor.name!}  ${widget.doctor.registrationNumber!}',
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
        header: (context) => _buildHeader(context),
        footer: (context) => _buildFooter(),
        build: (pdfLib.Context context) {
          return [
            pdfLib.SizedBox(height: 30),
            pdfLib.Center(
              child: pdfLib.Text(
                'VIA ORAL',
                style: pdfLib.TextStyle(
                  fontSize: 14,
                  font: ttfAtkinson,
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
                    pdfLib.Padding(
                      padding: const pdfLib.EdgeInsets.only(bottom: 12),
                      child: medication.type == 'medication'
                          ? _buildPdfMedicationDescription(
                              medication, ttfAtkinson, index, formatNumber)
                          : _buildPdfVaccinationDescription(
                              medication, ttfAtkinson, index, formatNumber),
                    ),
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

  // Atualize a função _buildPdfMedicationDescription
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
                    '${formatNumber(index + 1)}. ',
                    style: pdfLib.TextStyle(
                      font: font,
                      color: PdfColors.black,
                      fontWeight: pdfLib.FontWeight.bold,
                    ),
                  ),
                ),
                pdfLib.Container(
                  width: 370, // Largura fixa para o texto principal
                  child: pdfLib.Text(
                    '${medication.entity.tradeName} (${medication.entity.presentation}, ${medication.entity.activeIngredient} - ${medication.entity.activeIngredientConcentration} mg/ml)',
                    style: pdfLib.TextStyle(
                      font: font,
                      color: PdfColors.black,
                      fontWeight: pdfLib.FontWeight.bold,
                    ),
                  ),
                ),
                pdfLib.Container(
                  width: 100, // Largura fixa para a duração
                  child: pdfLib.Text(
                    medication.instructions.duration,
                    style: pdfLib.TextStyle(
                      font: font,
                      color: PdfColors.black,
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
                color: PdfColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Atualize a função _buildPdfVaccinationDescription
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
                    '${formatNumber(index + 1)}. ',
                    style: pdfLib.TextStyle(
                      font: font,
                      color: PdfColors.black,
                      fontWeight: pdfLib.FontWeight.bold,
                    ),
                  ),
                ),
                pdfLib.Container(
                  width: 370, // Largura fixa para o nome da vacina
                  child: pdfLib.Text(
                    medication.entity.vaccineName,
                    style: pdfLib.TextStyle(
                      font: font,
                      color: PdfColors.black,
                      fontWeight: pdfLib.FontWeight.bold,
                    ),
                  ),
                ),
                pdfLib.Container(
                  width: 100, // Largura fixa para o número da dose
                  child: pdfLib.Text(
                    '${medication.entity.doseNumber} dose',
                    style: pdfLib.TextStyle(
                      font: font,
                      color: PdfColors.black,
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
                color: PdfColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _getMedicationDescription({
    required ItemModel medication,
    required int index,
  }) {
    TextStyle atkinsonTextStyle(
        {double size = 16,
        FontWeight fontWeight = FontWeight.normal,
        Color color = Colors.black,
        TextDecoration decoration = TextDecoration.none}) {
      return TextStyle(
        fontFamily: 'AtkinsonHyperlegible', // Nome da fonte adicionada
        fontSize: size,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration,
      );
    }

    return Column(
      children: [
        Row(
          children: [
            const SizedBox(
              width: 16,
            ),
            Text(
              '${index + 1}. ',
              style: atkinsonTextStyle(
                size: 16,
                color: Colors.black, // Mudei para preto
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              '${medication.entity.tradeName} (${medication.entity.presentation}, ${medication.entity.activeIngredient} - ${medication.entity.activeIngredientConcentration} mg/ml)',
              style: atkinsonTextStyle(
                size: 16,
                color: Colors.black, // Mudei para preto
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            const Expanded(
                child: Divider(
              color: Colors.black, // Mudei para preto
              height: 1,
            )),
            const SizedBox(
              width: 16,
            ),
            Text(
              medication.instructions.duration,
              style: atkinsonTextStyle(
                size: 16,
                color: Colors.black, // Mudei para preto
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            CustomIconButtonMedGo(
              onPressed: () {
                Clipboard.setData(ClipboardData(
                  text:
                      '${medication.entity.tradeName} (${medication.entity.presentation} ${medication.entity.activeIngredient} - ${medication.entity.activeIngredientConcentration}) mg/ml',
                ));
                showToast(
                  'Posologia copiada para a área de transferência!',
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
              },
              icon: Icon(
                PhosphorIcons.copySimple(
                  PhosphorIconsStyle.bold,
                ),
                color: AppTheme.theme.primaryColor,
                size: 32,
                shadows: const [
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  )
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 32,
            ),
            Text(
              medication.instructions.prescription,
              style: atkinsonTextStyle(
                size: 16,
                color: Colors.black, // Mudei para preto
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        )
      ],
    );
  }

  _getVacinationDescription({
    required ItemModel medication,
    required int index,
  }) {
    TextStyle atkinsonTextStyle(
        {double size = 16,
        FontWeight fontWeight = FontWeight.normal,
        Color color = Colors.black,
        TextDecoration decoration = TextDecoration.none}) {
      return TextStyle(
        fontFamily: 'AtkinsonHyperlegible', // Nome da fonte adicionada
        fontSize: size,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration,
      );
    }

    return Column(
      children: [
        Row(
          children: [
            const SizedBox(
              width: 16,
            ),
            Text(
              '${index + 1}. ',
              style: atkinsonTextStyle(
                size: 16,
                color: Colors.black, // Mudei para preto
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              medication.entity.vaccineName,
              style: atkinsonTextStyle(
                size: 16,
                color: Colors.black, // Mudei para preto
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            const Expanded(
                child: Divider(
              color: Colors.black, // Mudei para preto
              height: 1,
            )),
            const SizedBox(
              width: 16,
            ),
            Text(
              '${medication.entity.doseNumber} dose',
              style: atkinsonTextStyle(
                size: 16,
                color: Colors.black, // Mudei para preto
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            CustomIconButtonMedGo(
              onPressed: () {
                Clipboard.setData(ClipboardData(
                  text:
                      '${medication.entity.vaccineName} - Aplicar ${medication.entity.doseNumber} dose',
                ));
                showToast(
                  'Vacina copiada para a área de transferência!',
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
              },
              icon: Icon(
                PhosphorIcons.copySimple(
                  PhosphorIconsStyle.bold,
                ),
                color: AppTheme.theme.primaryColor,
                size: 32,
                shadows: const [
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  )
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 32,
            ),
            Text(
              'Aplicar ${medication.entity.doseNumber} dose',
              style: atkinsonTextStyle(
                size: 16,
                color: Colors.black, // Mudei para preto
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        )
      ],
    );
  }
}
