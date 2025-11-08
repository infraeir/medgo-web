import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:medgo/strings/strings.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/buttons/primary_icon_button.dart';
import 'package:medgo/widgets/news_widgets/icon_button.dart';
import 'package:medgo/widgets/button/toggle_primary_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBarHome extends StatefulWidget {
  final bool isHome;
  final List<bool>? isSelected;
  final Function(int)? onToggle;
  final VoidCallback onLogout;
  final String? backRoute;

  const AppBarHome({
    super.key,
    this.isHome = false,
    this.isSelected,
    this.onToggle,
    this.backRoute,
    required this.onLogout,
  });

  @override
  State<AppBarHome> createState() => _AppBarHomeState();
}

class _AppBarHomeState extends State<AppBarHome> {
  String nameUser = '';

  @override
  void initState() {
    super.initState();
    getName();
  }

  getName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('nameUser') ?? '';
    });
  }

  String _getSelectedId(List<bool>? isSelected) {
    if (isSelected == null || isSelected.isEmpty) return 'patients';

    if (isSelected.length >= 4) {
      if (isSelected[0]) return 'patients';
      if (isSelected[1]) return 'calculators';
      if (isSelected[2]) return 'prescriptions';
      if (isSelected[3]) return 'consultations';
    } else if (isSelected.length >= 2) {
      if (isSelected[0]) return 'patients';
      if (isSelected[1]) return 'calculators';
    }

    return 'patients';
  }

  int _getIndexFromId(String id) {
    switch (id) {
      case 'patients':
        return 0;
      case 'calculators':
        return 1;
      case 'prescriptions':
        return 2;
      case 'consultations':
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.lightBackground,
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
      child: Row(
        children: [
          // Logo e boas-vindas (lado esquerdo)
          Flexible(
            flex: 1,
            child: Row(
              children: [
                if (widget.backRoute != null)
                  CustomIconButtonMedGo(
                    onPressed: () {
                      context.go('/${widget.backRoute}');
                    },
                    icon: Icon(
                      PhosphorIcons.caretLeft(),
                      color: AppTheme.primary,
                    ),
                  ),
                SvgPicture.asset(Strings.logoSvg, width: 64, height: 64),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seja bem vindo:',
                        style: TextStyle(
                          color: AppTheme.primaryText,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 3),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Dr(a). $nameUser',
                        style: TextStyle(
                          color: AppTheme.primaryText,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 3),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Botão toggle centralizado
          if (widget.isHome)
            Expanded(
              flex: 4,
              child: Center(
                child: SwitchBarMedGo(
                  options: [
                    SwitchBarOption(
                      name: Strings.pacientes,
                      id: 'patients',
                      icon: PhosphorIcons.userCircle(
                        PhosphorIconsStyle.bold,
                      ),
                    ),
                    SwitchBarOption(
                      name: 'Consultas',
                      id: 'consultations',
                      icon: PhosphorIcons.stethoscope(
                        PhosphorIconsStyle.regular,
                      ),
                    ),
                    SwitchBarOption(
                      name: 'Prescrições',
                      id: 'prescriptions',
                      iconOnRight: true,
                      color: AppTheme.salmon,
                      icon: PhosphorIcons.prescription(
                        PhosphorIconsStyle.bold,
                      ),
                    ),
                    SwitchBarOption(
                      name: Strings.calculadoras,
                      id: 'calculators',
                      iconOnRight: true,
                      icon: PhosphorIcons.calculator(
                        PhosphorIconsStyle.regular,
                      ),
                    ),
                  ],
                  selectedId: _getSelectedId(widget.isSelected),
                  onPressed: (id) {
                    if (widget.onToggle != null) {
                      widget.onToggle!(_getIndexFromId(id));
                    }
                  },
                ),
              ),
            ),
          if (!widget.isHome) const Expanded(flex: 4, child: SizedBox()),
          // Botão de logout (lado direito)
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: PrimaryIconButtonMedGo(
                    onTap: () async {
                      widget.onLogout();
                    },
                    title: Strings.sair,
                    rightIcon: Icon(
                      PhosphorIcons.signOut(
                        PhosphorIconsStyle.bold,
                      ),
                      color: AppTheme.error,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
