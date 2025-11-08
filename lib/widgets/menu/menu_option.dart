import 'package:flutter/material.dart';

enum MenuOptionStyle {
  initial,
  partial,
  completed,
}

class MenuOption extends StatefulWidget {

  final String title;
  final MenuOptionStyle style;

  const MenuOption({
    super.key, 
    required this.title, 
    required this.style
  });

  @override
  State<StatefulWidget> createState() => MenuOptionState();
}

class MenuOptionState extends State<MenuOption> {
  @override
  Widget build(BuildContext context) {
      return widget.style == MenuOptionStyle.partial ? 
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 24, 0, 0),
                                padding: const EdgeInsets.only(left: 4),
                                decoration: BoxDecoration(
                                  color: Color(0xFF004155),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF010039).withOpacity(.1),
                                      offset: const Offset(0, 0),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFF010039).withOpacity(.1),
                                        offset: const Offset(0, 0),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                              height: 40,
                                              width: 166,
                                              foregroundDecoration: BoxDecoration(
                                                border: Border.all(color: Colors.white, width: 1),
                                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                              ),
                                              clipBehavior: Clip.antiAlias,
                                              child: Container(
                                                      constraints: BoxConstraints.expand(),
                                                      color: Colors.white,
                                                      child: Row(
                                                        children: [
                                                        Expanded(child: TextButton(onPressed: (){}, 
                                                                                  child: Text(widget.title, 
                                                                                              style: TextStyle(color: Color(0xFF004155)),))),
                                                        Container(margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                                            child: SizedBox(
                                                                child: Tooltip(message: 'Informação',
                                                                              child: new Image.asset('assets/images/info@1x.png'),),
                                                                        width: 24, height: 24
                                                                  ),),
                                                      ],)),
                                                    ),
                                ),
                              ) : 
                                Container(
                                margin: EdgeInsets.fromLTRB(0, 24, 0, 0),
                                height: 40,
                                width: 166,
                                foregroundDecoration: BoxDecoration(
                                  border: Border.all(color: widget.style == MenuOptionStyle.completed ? Color(0xFF004155) : Color(0xFFB5B5B5), width: 1),
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Container(
                                  constraints: BoxConstraints.expand(),
                                  color: widget.style == MenuOptionStyle.completed ? Color(0xFF004155) : Colors.white,
                                  child: Row(
                                    children: [
                                    Expanded(child: TextButton(onPressed: (){}, 
                                                              child: Text(widget.title, 
                                                                            style: TextStyle(color: Color(0xFFB5B5B5)),))),
                                    Container(margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        child:  widget.style == MenuOptionStyle.completed ? 
                                            SizedBox(child: new Image.asset('assets/images/check@1x.png'),width: 24, height: 24,): SizedBox(
                                                                      child: new Image.asset('assets/images/info@1x.png'),width: 24, height: 24,)),
                                  ],)),
                                );
  }
}