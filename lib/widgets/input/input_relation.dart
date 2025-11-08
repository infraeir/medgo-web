import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';

import '../button/button.dart';

class InputRelation extends StatefulWidget {
  const InputRelation({super.key});

  @override
  State<InputRelation> createState() => InputRelationState();
}

class InputRelationState extends State<InputRelation> {
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
            "Relação",
            style: AppTheme.h5(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              ButtonPersonalizado(
                onClick: () {},
                title: 'Pai',
              ),
              SizedBox(
                width: 4,
              ),
              ButtonPersonalizado(
                onClick: () {},
                title: 'Mãe',
              ),
              SizedBox(
                width: 4,
              ),
              ButtonPersonalizado(
                onClick: () {},
                title: 'Outro',
              ),
            ],
          )
        ],
      ),
    );
  }
}
