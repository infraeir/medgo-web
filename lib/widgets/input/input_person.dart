import 'package:flutter/material.dart';
import 'package:medgo/widgets/button/button_edit.dart';
import 'package:medgo/widgets/container/container_nao_verificado.dart';
import 'package:medgo/themes/app_theme.dart';

class InputPerson extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final bool enabled;
  const InputPerson({
    super.key,
    required this.title,
    required this.controller,
    required this.enabled,
  });

  @override
  State<InputPerson> createState() => _InputPersonState();
}

class _InputPersonState extends State<InputPerson> {
  var isEnabled = false;

  @override
  void initState() {
    super.initState();
    isEnabled = widget.enabled;
  }

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
        children: [
          SizedBox(
            width: 300,
            child: Text(
              "${widget.title}:",
              style: AppTheme.h5(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: TextFormField(
                enabled: !isEnabled,
                controller: widget.controller,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  fillColor: AppTheme.theme.primaryColorDark,
                  filled: true,
                  hintText: "Digite aqui...",
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.redAccent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ), // Define o raio do círculo da borda
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          widget.enabled
              ? ButtonEdit(
                  onlyIcon: true,
                  onClick: () {
                    setState(() {
                      isEnabled = !isEnabled;
                    });
                  })
              : NaoVerificadoContainer(onClick: () {})
        ],
      ),
    );
  }
}
