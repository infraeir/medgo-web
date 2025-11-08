import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/themes/app_theme_spacing.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HeaderMedicineLabelWidget extends StatelessWidget {
  const HeaderMedicineLabelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppThemeSpacing.quatro),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppThemeSpacing.dez),
          boxShadow: [
            BoxShadow(
              color: AppTheme.theme.primaryColor,
              blurRadius: 1,
            )
          ]),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          'Medicação em uso',
          style: TextStyle(
              color: AppTheme.theme.primaryColor, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: AppThemeSpacing.quatro,
        ),
        Container(
            height: AppThemeSpacing.trinta,
            decoration: BoxDecoration(
              color: AppTheme.theme.primaryColor,
              borderRadius: BorderRadius.circular(AppThemeSpacing.oito),
            ),
            child: Row(children: [
              const SizedBox(
                width: AppThemeSpacing.quatro,
              ),
              const Text(
                '2 gotas',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(
                width: AppThemeSpacing.quatro,
              ),
              Icon(
                PhosphorIcons.sunHorizon(),
                color: Colors.white,
                size: AppThemeSpacing.vinte,
              ),
              const SizedBox(
                width: AppThemeSpacing.quatro,
              ),
            ])),
        const SizedBox(
          width: AppThemeSpacing.quatro,
        ),
        Container(
            height: AppThemeSpacing.trinta,
            decoration: BoxDecoration(
              color: Color(0xffE0E3E7),
              borderRadius: BorderRadius.circular(AppThemeSpacing.oito),
            ),
            child: Row(children: [
              const SizedBox(
                width: AppThemeSpacing.quatro,
              ),
              const Text(
                '0',
                style: TextStyle(color: Color(0xff57636C)),
              ),
              const SizedBox(
                width: AppThemeSpacing.quatro,
              ),
              Icon(
                PhosphorIcons.sun(),
                color: Color(0xff57636C),
                size: AppThemeSpacing.vinte,
              ),
              const SizedBox(
                width: AppThemeSpacing.quatro,
              ),
            ])),
        const SizedBox(
          width: AppThemeSpacing.quatro,
        ),
        Container(
            height: AppThemeSpacing.trinta,
            decoration: BoxDecoration(
              color: Color(0xffE0E3E7),
              borderRadius: BorderRadius.circular(AppThemeSpacing.oito),
            ),
            child: Row(children: [
              const SizedBox(
                width: AppThemeSpacing.quatro,
              ),
              const Text(
                '0',
                style: TextStyle(color: Color(0xff57636C)),
              ),
              const SizedBox(
                width: AppThemeSpacing.quatro,
              ),
              Icon(
                PhosphorIcons.moon(),
                color: Color(0xff57636C),
                size: AppThemeSpacing.vinte,
              ),
              const SizedBox(
                width: AppThemeSpacing.quatro,
              ),
            ])),
        const SizedBox(
          width: AppThemeSpacing.quatro,
        ),
        Icon(
          PhosphorIcons.pencilSimple(),
          color: AppTheme.theme.primaryColor,
          size: AppThemeSpacing.vinte,
        ),
      ]),
    );
  }
}
