import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Importar biblioteca do go_router
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/icon_button.dart';

class SegmentNavigation extends StatelessWidget {
  final List<String> paginas;
  final bool isBack;
  final String? route;

  const SegmentNavigation({
    super.key,
    required this.paginas,
    required this.isBack,
    this.route,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> textWidgets = [];

    for (int i = 0; i < paginas.length; i++) {
      textWidgets.add(Text(
        paginas[i],
        style: TextStyle(
          color: i == paginas.length - 1
              ? AppTheme.theme.primaryColor
              : AppTheme.theme.disabledColor,
          fontSize: 16,
        ),
      ));

      if (i < paginas.length - 1) {
        textWidgets.add(Text(
          " / ",
          style: TextStyle(
            color: AppTheme.theme.disabledColor,
            fontSize: 16,
          ),
        ));
      }
    }

    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        isBack
            ? CustomIconButtonMedGo(
                onPressed: () {
                  // Use o router.pop() que tem suporte em histórias de Navegação - go_router
                  context.go('/$route');
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: AppTheme.theme.disabledColor,
                ),
              )
            : const SizedBox.shrink(),
        ...textWidgets,
      ],
    );
  }
}
