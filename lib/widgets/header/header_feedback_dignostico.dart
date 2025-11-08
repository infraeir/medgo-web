import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/themes/app_theme_spacing.dart';

class HeaderDignosticoLabelWidget extends StatelessWidget {
  final String criterionName;
  const HeaderDignosticoLabelWidget({super.key, required this.criterionName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              bottom: AppThemeSpacing.seis,
              left: AppThemeSpacing.oito,
              right: AppThemeSpacing.oito),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppThemeSpacing.quatro,
              vertical: AppThemeSpacing.quatro,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppThemeSpacing.quatro),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: AppThemeSpacing.quatro,
                          ),
                          Expanded(
                            child: Text(
                              criterionName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.secondaryText,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
