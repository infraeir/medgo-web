import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/email_input.dart';
import 'package:medgo/widgets/news_widgets/password_input.dart';
import 'package:medgo/widgets/news_widgets/input_chip.dart';
import 'package:medgo/pages/register/controller/register_controller.dart';

class CadastroSection extends StatelessWidget {
  final RegisterController controller;

  const CadastroSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return SizedBox(
          width: 600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cadastro',
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
                    // Email
                    EmailInputMedgo(
                      controller: controller.emailController,
                      onChanged: controller.updateEmail,
                      labelText: 'Email',
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),
                    // Senha
                    PasswordInputMedgo(
                      controller: controller.passwordController,
                      hintText: 'Inserir senha',
                      labelText: 'Nova Senha',
                      autofillHints: const [AutofillHints.newPassword],
                      onChanged: controller.updatePassword,
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),
                    // Redigite sua senha
                    PasswordInputMedgo(
                      controller: controller.confirmPasswordController,
                      hintText: 'Inserir senha',
                      labelText: 'Redigite a nova senha',
                      autofillHints: const [AutofillHints.newPassword],
                      onChanged: controller.updateConfirmPassword,
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: const TextSpan(
                        text: 'Tipo de cadastro',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.secondaryText,
                        ),
                        children: [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(
                              color: AppTheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        InputChipMedgo(
                          title: 'Médico',
                          selectedChip:
                              controller.userData.registerType == 'Médico',
                          onSelected: (selected) {
                            controller
                                .updateRegisterType(selected ? 'Médico' : null);
                          },
                        ),
                        InputChipMedgo(
                          title: 'Estudante',
                          selectedChip:
                              controller.userData.registerType == 'Estudante',
                          onSelected: (selected) {
                            controller.updateRegisterType(
                                selected ? 'Estudante' : null);
                          },
                        ),
                        InputChipMedgo(
                          title: 'Assistente',
                          selectedChip:
                              controller.userData.registerType == 'Assistente',
                          onSelected: (selected) {
                            controller.updateRegisterType(
                                selected ? 'Assistente' : null);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
