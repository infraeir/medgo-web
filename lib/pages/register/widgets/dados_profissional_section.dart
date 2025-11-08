import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/short_text_input.dart';
import 'package:medgo/widgets/news_widgets/cpf_input.dart';
import 'package:medgo/widgets/news_widgets/cns_input.dart';
import 'package:medgo/widgets/news_widgets/uf_input.dart';
import 'package:medgo/widgets/news_widgets/registro_medico_input.dart';
import 'package:medgo/widgets/news_widgets/phone_input.dart';
import 'package:medgo/widgets/news_widgets/date_input.dart';
import 'package:medgo/widgets/news_widgets/input_chip.dart';
import 'package:medgo/pages/register/controller/register_controller.dart';

class DadosProfissionalSection extends StatelessWidget {
  final RegisterController controller;

  const DadosProfissionalSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dados profissional',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 8.0,
                    children: [
                      SizedBox(
                        width: 75,
                        child: UfInputMedgo(
                          controller: controller.ufController,
                          labelText: 'UF',
                          onChanged: controller.updateUf,
                          isRequired: true,
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: RegistroMedicoInputMedgo(
                          controller: controller.registroMedicoController,
                          labelText: 'Nº do Registro (CRM)',
                          onChanged: controller.updateRegistroMedico,
                          isRequired: true,
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: CpfInputMedgo(
                          controller: controller.cpfController,
                          labelText: 'CPF',
                          onChanged: controller.updateCpf,
                          isRequired: true,
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: CnsInputMedgo(
                          controller: controller.cnsController,
                          labelText: 'CNS',
                          onChanged: controller.updateCns,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 800,
                    child: ShortTextInputMedgo(
                      controller: controller.nameController,
                      hintText: 'Digite seu nome',
                      labelText: 'Nome',
                      onChanged: controller.updateName,
                      isRequired: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    spacing: 8.0,
                    children: [
                      SizedBox(
                        width: 250,
                        child: PhoneInputMedgo(
                          controller: controller.phoneController,
                          labelText: 'Telefone',
                          onChanged: controller.updatePhone,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 250,
                            child: DateInputMedgo(
                              labelText: 'Data de nascimento',
                              hintText: '01/01/1990',
                              onChanged: (value) {
                                // controller.updateDataNascimento pode ser implementado
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: 'Sexo',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.secondaryText,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Wrap(
                        spacing: 8,
                        children: [
                          InputChipMedgo(
                            title: 'Masculino',
                            selectedChip:
                                controller.userData.gender == 'Masculino',
                            onSelected: (selected) {
                              controller
                                  .updateGender(selected ? 'Masculino' : null);
                            },
                          ),
                          InputChipMedgo(
                            title: 'Feminino',
                            selectedChip:
                                controller.userData.gender == 'Feminino',
                            onSelected: (selected) {
                              controller
                                  .updateGender(selected ? 'Feminino' : null);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
