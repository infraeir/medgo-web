import 'package:flutter/material.dart';

class ButtonPrimary extends StatefulWidget {
  final String title;
  final VoidCallback onClick;
  const ButtonPrimary({
    super.key,
    required this.title,
    required this.onClick,
  });

  @override
  State<ButtonPrimary> createState() => ButtonPrimaryState();
}

class ButtonPrimaryState extends State<ButtonPrimary> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: SizedBox(
        width: double.maxFinite,
        height: 38,
        child: TextButton(
          onPressed: () {
            widget.onClick();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF4D616C),
            textStyle: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.normal),
            side: BorderSide(width: 1.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          child: Text(widget.title),
        ),
      ),
    );
  }
}
