
import 'package:flutter/material.dart';
import 'package:medgo/strings/strings.dart';
import 'package:medgo/widgets/menu/menu_option.dart';

class Menu extends StatefulWidget {
  final List<MenuOption> items;

  const Menu({
    super.key,
    required this.items
  });
  
  @override
  State<StatefulWidget> createState() => MenuState();
}

class MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Container(alignment: Alignment.topLeft,
                     padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
                     child: Column(
                                children: [new Image.asset(Strings.logoImageName, width: 146, height: 40,),
                                            ...widget.items
                                          ],),);
  }
}