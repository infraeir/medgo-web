import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:medgo/data/models/doctor_model.dart';
import 'package:medgo/data/models/patients_model.dart';
import 'package:medgo/data/models/system_prescription_model.dart';
import 'package:medgo/data/models/prescription_item_model.dart';

import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/icon_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Widget de preview da prescrição médica que funciona com SystemPrescriptionModel
/// Versão adaptada do NewMedicalPrescription para a nova estrutura da API
class NewSystemMedicalPrescription extends StatefulWidget {
  final DoctorModel doctor;
  final PatientsModel? patient;
  final String? peso;
  final DateTime? emissionDate;
  final DateTime? expirationDate;
  final List<SystemPrescriptionModel> prescriptionsVacination;
  final List<SystemPrescriptionModel> prescriptionsMedication;

  const NewSystemMedicalPrescription({
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
  State<NewSystemMedicalPrescription> createState() =>
      _NewSystemMedicalPrescriptionState();
}

class _NewSystemMedicalPrescriptionState
    extends State<NewSystemMedicalPrescription> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    List<PrescriptionItemModel> itensEscolhidos = [];

    for (var prescription in widget.prescriptionsVacination) {
      itensEscolhidos
          .addAll(prescription.items.where((item) => item.isChosen == true));
    }
    for (var prescription in widget.prescriptionsMedication) {
      itensEscolhidos
          .addAll(prescription.items.where((item) => item.isChosen == true));
    }

    TextStyle atkinsonTextStyle({
      double size = 16,
      FontWeight fontWeight = FontWeight.normal,
      Color color = Colors.black,
      TextDecoration decoration = TextDecoration.none,
    }) {
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
                    style: atkinsonTextStyle(
                      size: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                    children: [
                      TextSpan(
                        text: 'Nome: ',
                        style: atkinsonTextStyle(
                          size: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: widget.patient!.name,
                      ),
                      if (widget.peso != null) ...[
                        TextSpan(
                          text: '  Peso: ',
                          style: atkinsonTextStyle(
                            size: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '${widget.peso} kg',
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
                    'Emitido em: ${widget.emissionDate!.day.toString().padLeft(2, '0')}/${widget.emissionDate!.month.toString().padLeft(2, '0')}/${widget.emissionDate!.year}',
                    style: atkinsonTextStyle(
                      size: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
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
                      size: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
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

  _getMedicationDescription({
    required PrescriptionItemModel medication,
    required int index,
  }) {
    TextStyle atkinsonTextStyle({
      double size = 16,
      FontWeight fontWeight = FontWeight.normal,
      Color color = Colors.black,
      TextDecoration decoration = TextDecoration.none,
    }) {
      return TextStyle(
        fontFamily: 'AtkinsonHyperlegible', // Nome da fonte adicionada
        fontSize: size,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration,
      );
    }

    // Adaptar para os novos campos do PrescriptionItemModel
    final presentation = 'N/A'; // Não há mais presentations no MedicationModel
    final concentration =
        'N/A'; // Não há mais strengthValue/strengthUnit no ActiveIngredientModel

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
            Expanded(
              child: Text(
                '${medication.entities.first.tradeName} ($presentation, - $concentration)',
                style: atkinsonTextStyle(
                  size: 16,
                  color: Colors.black, // Mudei para preto
                  fontWeight: FontWeight.w600,
                ),
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
                      '${medication.entities.first.tradeName} ($presentation, - $concentration)\n${medication.instructions.prescription}',
                ));
                showToast(
                  'Medicação copiada para a área de transferência!',
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
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
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
            Expanded(
              child: Text(
                medication.instructions.prescription,
                style: atkinsonTextStyle(
                  size: 16,
                  color: Colors.black, // Mudei para preto
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  _getVacinationDescription({
    required PrescriptionItemModel medication,
    required int index,
  }) {
    TextStyle atkinsonTextStyle({
      double size = 16,
      FontWeight fontWeight = FontWeight.normal,
      Color color = Colors.black,
      TextDecoration decoration = TextDecoration.none,
    }) {
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
            Expanded(
              child: Text(
                medication.entities.first.tradeName,
                style: atkinsonTextStyle(
                  size: 16,
                  color: Colors.black, // Mudei para preto
                  fontWeight: FontWeight.w600,
                ),
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
                      '${medication.entities.first.tradeName}\n${medication.instructions.prescription}',
                ));
                showToast(
                  'Vacinação copiada para a área de transferência!',
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
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
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
            Expanded(
              child: Text(
                medication.instructions.prescription,
                style: atkinsonTextStyle(
                  size: 16,
                  color: Colors.black, // Mudei para preto
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
