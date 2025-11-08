import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medgo/data/models/medication_model.dart';
import 'package:medgo/themes/app_theme.dart';

/// Widget responsável por exibir o cabeçalho do medicamento
class MedicationHeaderWidget extends StatelessWidget {
  final MedicationModel medication;

  const MedicationHeaderWidget({
    super.key,
    required this.medication,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 6.0,
        ),
        child: Row(
          children: [
            SvgPicture.asset('assets/icons/${medication.type}.svg'),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                medication.displayName,
                style: AppTheme.p(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
