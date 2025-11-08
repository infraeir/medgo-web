import 'package:flutter/material.dart';
import 'package:medgo/helper/helper.dart';
import 'package:medgo/data/models/patients_model.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/icon_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HeaderPaciente extends StatefulWidget {
  final PatientsModel? patient;
  final VoidCallback onPressed;
  const HeaderPaciente({super.key, this.patient, required this.onPressed});

  @override
  State<HeaderPaciente> createState() => _HeaderPacienteState();
}

class _HeaderPacienteState extends State<HeaderPaciente> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 4, right: 10, left: 10, top: 10),
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.lightBackground,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.patient?.gender == 'female'
                        ? Icon(
                            PhosphorIcons.genderFemale(
                              PhosphorIconsStyle.bold,
                            ),
                            size: 30,
                            color: Color(0xffAD00B1),
                          )
                        : Icon(
                            PhosphorIcons.genderMale(
                              PhosphorIconsStyle.bold,
                            ),
                            size: 30,
                            color: Color.fromARGB(255, 0, 150, 177),
                          ),
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  // <-- Adicione aqui para o conteúdo textual
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          const Text(
                            "Nome: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primary,
                            ),
                          ),
                          Text(widget.patient?.name ?? ''),
                          const SizedBox(width: 14),
                          const Text(
                            "Idade: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primary,
                            ),
                          ),
                          Text(widget.patient?.age ?? ''),
                          Text(
                            '(DN: ${Helper.convertToDate(widget.patient?.dateOfBirth ?? '')})',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "Etnia: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primary,
                            ),
                          ),
                          Text(Helper.getEthnicity(
                              widget.patient?.ethnicity ?? '')),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconButtonMedGo(
                onPressed: widget.onPressed,
                icon: Icon(
                  PhosphorIcons.pencilSimple(
                    PhosphorIconsStyle.bold,
                  ),
                  size: 30,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
