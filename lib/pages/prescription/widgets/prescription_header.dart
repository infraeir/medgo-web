import 'package:flutter/material.dart';
import 'package:medgo/data/models/patients_model.dart';
import 'package:medgo/helper/helper.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/buttons/primary_icon_button.dart';
import 'package:medgo/widgets/news_widgets/icon_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../enums/prescription_type.dart';

class PrescriptionHeader extends StatelessWidget {
  final PrescriptionType prescriptionType;
  final PatientsModel? patient;
  final VoidCallback onClose;
  final VoidCallback? onChangePatient;
  final VoidCallback? onEditPatient;
  final VoidCallback? onSelectPatient;

  const PrescriptionHeader({
    super.key,
    required this.prescriptionType,
    this.patient,
    required this.onClose,
    this.onChangePatient,
    this.onEditPatient,
    this.onSelectPatient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 4,
        top: 8,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(223, 238, 255, 0.25),
        borderRadius: const BorderRadius.all(
          Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 0),
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: Column(
          children: [
            _buildTopRow(),
            if (prescriptionType.hasPatient && patient != null)
              _buildPatientInfo()
          ],
        ),
      ),
    );
  }

  Widget _buildTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLeftButton(),
        _buildTitle(),
        _buildCloseButton(),
      ],
    );
  }

  Widget _buildLeftButton() {
    if (prescriptionType.needsPatientSelection) {
      return CustomIconButtonMedGo(
        onPressed: onSelectPatient ?? () {},
        size: 34,
        icon: Icon(
          PhosphorIcons.userCircle(
            PhosphorIconsStyle.bold,
          ),
          color: AppTheme.primary,
          size: 22,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildTitle() {
    return Stack(
      children: [
        // Stroke
        Text(
          'Prescrição',
          style: AppTheme.h3(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ).copyWith(
            fontFamily: 'Roboto',
            fontSize: 22,
            fontStyle: FontStyle.normal,
            height: 28 / 22,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 0.5
              ..color = Colors.white,
          ),
        ),
        // Fill
        Text(
          'Prescrição',
          style: AppTheme.h3(
            color: AppTheme.theme.primaryColor,
            fontWeight: FontWeight.w800,
          ).copyWith(
            fontFamily: 'Roboto',
            fontSize: 22,
            fontStyle: FontStyle.normal,
            height: 28 / 22,
          ),
        ),
      ],
    );
  }

  Widget _buildCloseButton() {
    return CustomIconButtonMedGo(
      onPressed: onClose,
      size: 34,
      icon: const Icon(
        Icons.close,
        color: Colors.red,
        size: 22,
      ),
    );
  }

  Widget _buildPatientInfo() {
    if (patient == null) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        prescriptionType == PrescriptionType.withoutPatient ||
                prescriptionType == PrescriptionType.withoutPatientNeedSelection
            ? _buildChangePatientButton()
            : const SizedBox.shrink(),
        _buildPatientDetails(),
        _buildEditPatientButton(),
      ],
    );
  }

  Widget _buildChangePatientButton() {
    return PrimaryIconButtonMedGo(
      title: 'Trocar paciente',
      onTap: onChangePatient ?? () {},
      leftIcon: Icon(
        size: 20,
        color: AppTheme.primary,
        PhosphorIcons.userCircle(
          PhosphorIconsStyle.bold,
        ),
        shadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }

  Widget _buildEditPatientButton() {
    return PrimaryIconButtonMedGo(
      title: 'Editar paciente',
      onTap: onEditPatient ?? () {},
      rightIcon: Icon(
        size: 20,
        color: AppTheme.primary,
        PhosphorIcons.pencilSimpleLine(
          PhosphorIconsStyle.bold,
        ),
        shadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientDetails() {
    if (patient == null) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            patient!.gender == 'female'
                ? Icon(
                    PhosphorIcons.genderFemale(
                      PhosphorIconsStyle.bold,
                    ),
                    size: 24,
                    color: const Color(0xffAD00B1),
                    shadows: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 1.5,
                        offset: const Offset(-0.25, 1),
                      ),
                    ],
                  )
                : Icon(
                    PhosphorIcons.genderMale(
                      PhosphorIconsStyle.bold,
                    ),
                    size: 24,
                    color: const Color.fromARGB(255, 0, 150, 177),
                    shadows: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 1.5,
                        offset: const Offset(-0.25, 1),
                      ),
                    ],
                  ),
          ],
        ),
        const SizedBox(width: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            double fontSize = constraints.maxWidth < 400 ? 12 : 16;
            return Row(
              children: [
                Text(
                  'Nome: ',
                  style: AppTheme.h5(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                  ).copyWith(fontSize: fontSize),
                ),
                Text(
                  patient!.name,
                  style: AppTheme.h5(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ).copyWith(fontSize: fontSize),
                ),
                const SizedBox(width: 8),
                Text(
                  'Idade: ',
                  style: AppTheme.h5(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                  ).copyWith(fontSize: fontSize),
                ),
                Text(
                  patient!.age,
                  style: AppTheme.h5(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ).copyWith(fontSize: fontSize),
                ),
                Text(
                  ' (DN: ${Helper.convertToDate(patient!.dateOfBirth)})',
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.h5(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ).copyWith(fontSize: fontSize),
                ),
                const SizedBox(width: 8),
                Text(
                  'Etnia: ',
                  style: AppTheme.h5(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                  ).copyWith(fontSize: fontSize),
                ),
                Text(
                  Helper.getEthnicity(patient!.ethnicity),
                  style: AppTheme.h5(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ).copyWith(fontSize: fontSize),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
