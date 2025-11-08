import 'package:flutter/material.dart';
import 'package:medgo/strings/strings.dart';
import 'package:medgo/themes/app_theme.dart';

import '../button/button.dart';

class InputSexo extends StatefulWidget {
  final String sexo;
  final Function(String sexo) alteraSexo;
  const InputSexo({super.key, required this.sexo, required this.alteraSexo});

  @override
  State<InputSexo> createState() => _InputSexoState();
}

class _InputSexoState extends State<InputSexo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      height: 52,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.theme.primaryColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 8.0,
            offset: Offset(2.0, 2.0),
            spreadRadius: 0.1,
            blurStyle: BlurStyle.normal,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${Strings.sexo}:",
            style: AppTheme.h5(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              ButtonPersonalizado(
                onClick: () {
                  widget.alteraSexo('male');
                },
                title: Strings.masculino,
                selected: widget.sexo == 'male' ? true : false,
              ),
              const SizedBox(
                width: 4,
              ),
              ButtonPersonalizado(
                onClick: () {
                  widget.alteraSexo('female');
                },
                title: 'Não Informado',
                selected: widget.sexo == 'female' ? true : false,
              ),
              const SizedBox(
                width: 4,
              ),
              ButtonPersonalizado(
                onClick: () {
                  widget.alteraSexo('other');
                },
                title: 'Feminino',
                selected: widget.sexo == 'other' ? true : false,
              ),
            ],
          )
        ],
      ),
    );
  }
}
