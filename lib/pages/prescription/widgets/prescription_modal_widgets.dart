import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:medgo/data/models/patients_model.dart';
import 'package:medgo/helper/helper.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/buttons/primary_icon_button.dart';
import 'package:medgo/widgets/news_widgets/date_input.dart';
import 'package:medgo/widgets/news_widgets/icon_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

enum PrescriptionModalType {
  withoutPatient,
  withPatient,
  selectPatient,
}

class PrescriptionModalHeader extends StatelessWidget {
  final PrescriptionModalType type;
  final PatientsModel? patient;
  final VoidCallback onClose;
  final VoidCallback? onSelectPatient;
  final VoidCallback? onChangePatient;
  final VoidCallback? onEditPatient;

  const PrescriptionModalHeader({
    super.key,
    required this.type,
    this.patient,
    required this.onClose,
    this.onSelectPatient,
    this.onChangePatient,
    this.onEditPatient,
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
            if (type == PrescriptionModalType.withPatient && patient != null)
              _buildPatientInfo(),
            if (type == PrescriptionModalType.selectPatient)
              _buildSelectPatientRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        type == PrescriptionModalType.withoutPatient
            ? CustomIconButtonMedGo(
                onPressed: onClose,
                size: 34,
                icon: Icon(
                  PhosphorIcons.userCircle(
                    PhosphorIconsStyle.bold,
                  ),
                  color: Colors.red,
                  size: 22,
                ),
              )
            : const SizedBox.shrink(),
        _buildTitle(),
        CustomIconButtonMedGo(
          onPressed: onClose,
          size: 34,
          icon: const Icon(
            Icons.close,
            color: Colors.red,
            size: 22,
          ),
        ),
      ],
    );
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

  Widget _buildPatientInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PrimaryIconButtonMedGo(
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
        ),
        _buildPatientDetails(),
        PrimaryIconButtonMedGo(
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
        ),
      ],
    );
  }

  Widget _buildPatientDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            patient?.gender == 'female'
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
                  patient?.name ?? '',
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
                  patient?.age ?? '',
                  style: AppTheme.h5(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ).copyWith(fontSize: fontSize),
                ),
                Text(
                  ' (DN: ${Helper.convertToDate(patient?.dateOfBirth ?? '')})',
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
                  Helper.getEthnicity(patient?.ethnicity ?? ''),
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

  Widget _buildSelectPatientRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            PhosphorIcons.userCircle(PhosphorIconsStyle.bold),
            size: 32,
            color: AppTheme.primary,
          ),
          const SizedBox(width: 12),
          Text(
            'Selecione um paciente para continuar',
            style: AppTheme.h4(
              color: AppTheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          PrimaryIconButtonMedGo(
            title: 'Selecionar Paciente',
            onTap: onSelectPatient ?? () {},
            rightIcon: Icon(
              size: 20,
              color: AppTheme.primary,
              PhosphorIcons.userCirclePlus(
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
          ),
        ],
      ),
    );
  }
}

class PrescriptionModalFooter extends StatelessWidget {
  final Function(DateTime?)? onEmissionDateChanged;
  final Function(DateTime?)? onValidityDateChanged;
  final VoidCallback? onPreview;
  final VoidCallback? onPrevious;
  final VoidCallback? onDelete;
  final VoidCallback? onCopy;
  final VoidCallback? onPrint;
  final VoidCallback? onSave;

  const PrescriptionModalFooter({
    super.key,
    this.onEmissionDateChanged,
    this.onValidityDateChanged,
    this.onPreview,
    this.onPrevious,
    this.onDelete,
    this.onCopy,
    this.onPrint,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildLeftSection(),
                _buildRightSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 200,
          child: DateInputMedgo(
            labelText: 'Data de emissão',
            onDateChanged: onEmissionDateChanged ?? (date) {},
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 200,
          child: DateInputMedgo(
            labelText: 'Data de validade',
            onDateChanged: onValidityDateChanged ?? (date) {},
          ),
        ),
        const SizedBox(width: 10),
        PrimaryIconButtonMedGo(
          title: 'Visualizando impressão',
          onTap: onPreview ?? () {},
          leftIcon: Icon(
            size: 20,
            color: AppTheme.primary,
            PhosphorIcons.eye(
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
        ),
      ],
    );
  }

  Widget _buildRightSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PrimaryIconButtonMedGo(
          onTap: onPrevious ?? () {},
          leftIcon: Icon(
            size: 20,
            color: AppTheme.warning,
            PhosphorIcons.caretLeft(
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
        ),
        const SizedBox(width: 10),
        PrimaryIconButtonMedGo(
          onTap: onDelete ?? () {},
          leftIcon: Icon(
            size: 20,
            color: AppTheme.error,
            PhosphorIcons.trash(
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
        ),
        const SizedBox(width: 10),
        PrimaryIconButtonMedGo(
          title: 'Copiar toda a prescrição',
          onTap: onCopy ?? () {},
          leftIcon: Icon(
            size: 20,
            color: AppTheme.primary,
            PhosphorIcons.copySimple(
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
        ),
        const SizedBox(width: 10),
        PrimaryIconButtonMedGo(
          onTap: onPrint ?? () {},
          leftIcon: Icon(
            size: 20,
            color: AppTheme.primary,
            PhosphorIcons.printer(
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
        ),
        const SizedBox(width: 10),
        PrimaryIconButtonMedGo(
          onTap: onSave ?? () {},
          leftIcon: Icon(
            size: 20,
            color: AppTheme.success,
            PhosphorIcons.floppyDisk(
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
        ),
      ],
    );
  }
}
