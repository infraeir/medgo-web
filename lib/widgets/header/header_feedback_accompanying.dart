import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/themes/app_theme_spacing.dart';
import 'package:medgo/widgets/news_widgets/icon_button.dart';
import 'package:medgo/widgets/news_widgets/toggable_icon.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HeaderFeedbackAccompanying extends StatefulWidget {
  final String companionName;
  final bool selected;
  final Function(bool isEdit) didTap;

  const HeaderFeedbackAccompanying({
    super.key,
    required this.companionName,
    required this.didTap,
    required this.selected,
  });

  @override
  State<HeaderFeedbackAccompanying> createState() =>
      _HeaderFeedbackAccompanyingState();
}

class _HeaderFeedbackAccompanyingState
    extends State<HeaderFeedbackAccompanying> {
  bool iconPressed = false;

  void didTap() {
    setState(() {
      iconPressed = !iconPressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppThemeSpacing.quatro,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppThemeSpacing.dez),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Cor da sombra
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const SizedBox(
                width: AppThemeSpacing.dezesseis,
              ),
              ToggleIconButtonMedgo(
                  onToggle: (isSelected) {
                    didTap();
                    widget.didTap(false);
                  },
                  isSelected: widget.selected),
              const SizedBox(
                width: AppThemeSpacing.quatro,
              ),
              Text(
                widget.companionName,
              ),
            ],
          ),
          CustomIconButtonMedGo(
            icon: Icon(
              PhosphorIcons.pencilSimple(
                PhosphorIconsStyle.bold,
              ),
              color: AppTheme.theme.primaryColor,
              size: AppThemeSpacing.vinteQuatro,
              shadows: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), // Cor da sombra
                  spreadRadius: 3,
                  blurRadius: 5,
                ),
              ],
            ),
            onPressed: () {
              widget.didTap(true);
            },
          ),
        ],
      ),
    );
  }
}
