import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/buttons/primary_icon_button.dart';
import 'package:medgo/widgets/news_widgets/date_input.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PrescriptionFooter extends StatefulWidget {
  final DateTime? initialEmissionDate;
  final DateTime? initialExpirationDate;
  final bool showPreview;
  final Function(DateTime?) onEmissionDateChanged;
  final Function(DateTime?) onExpirationDateChanged;
  final VoidCallback onPreviewPrint;
  final VoidCallback onNavigateBack;
  final VoidCallback onDeletePrescription;
  final VoidCallback onCopyPrescription;
  final VoidCallback onPrintPrescription;
  final VoidCallback onSavePrescription;

  const PrescriptionFooter({
    super.key,
    this.initialEmissionDate,
    this.initialExpirationDate,
    this.showPreview = false,
    required this.onEmissionDateChanged,
    required this.onExpirationDateChanged,
    required this.onPreviewPrint,
    required this.onNavigateBack,
    required this.onDeletePrescription,
    required this.onCopyPrescription,
    required this.onPrintPrescription,
    required this.onSavePrescription,
  });

  @override
  State<PrescriptionFooter> createState() => _PrescriptionFooterState();
}

class _PrescriptionFooterState extends State<PrescriptionFooter> {
  late TextEditingController _emissionController;
  late TextEditingController _expirationController;

  @override
  void initState() {
    super.initState();
    _emissionController = TextEditingController();
    _expirationController = TextEditingController();

    // Inicializa com as datas fornecidas
    if (widget.initialEmissionDate != null) {
      final date = widget.initialEmissionDate!;
      _emissionController.text =
          '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }

    if (widget.initialExpirationDate != null) {
      final date = widget.initialExpirationDate!;
      _expirationController.text =
          '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
  }

  @override
  void dispose() {
    _emissionController.dispose();
    _expirationController.dispose();
    super.dispose();
  }

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
            controller: _emissionController,
            labelText: 'Data de emissão',
            onDateChanged: widget.onEmissionDateChanged,
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 200,
          child: DateInputMedgo(
            controller: _expirationController,
            labelText: 'Data de validade',
            onDateChanged: widget.onExpirationDateChanged,
          ),
        ),
        const SizedBox(width: 10),
        PrimaryIconButtonMedGo(
          title:
              widget.showPreview ? 'Ocultar impressão' : 'Visualizar impressão',
          onTap: widget.onPreviewPrint,
          leftIcon: Icon(
            size: 20,
            color: AppTheme.primary,
            widget.showPreview
                ? PhosphorIcons.eye(PhosphorIconsStyle.bold)
                : PhosphorIcons.eyeClosed(PhosphorIconsStyle.bold),
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
        _buildNavigateBackButton(),
        const SizedBox(width: 10),
        _buildDeleteButton(),
        const SizedBox(width: 10),
        _buildCopyButton(),
        const SizedBox(width: 10),
        _buildPrintButton(),
        const SizedBox(width: 10),
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildNavigateBackButton() {
    return PrimaryIconButtonMedGo(
      onTap: widget.onNavigateBack,
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
    );
  }

  Widget _buildDeleteButton() {
    return PrimaryIconButtonMedGo(
      onTap: widget.onDeletePrescription,
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
    );
  }

  Widget _buildCopyButton() {
    return PrimaryIconButtonMedGo(
      onTap: widget.onCopyPrescription,
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
    );
  }

  Widget _buildPrintButton() {
    return PrimaryIconButtonMedGo(
      onTap: widget.onPrintPrescription,
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
    );
  }

  Widget _buildSaveButton() {
    return PrimaryIconButtonMedGo(
      onTap: widget.onSavePrescription,
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
    );
  }
}
