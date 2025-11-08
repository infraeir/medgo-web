import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/buttons/tertiary_icon_button.dart';
import 'package:medgo/widgets/news_widgets/local_atendimento_card.dart';
import 'package:medgo/pages/register/controller/register_controller.dart';
import 'package:medgo/pages/register/widgets/local_atendimento_form_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LocalAtendimentoSection extends StatelessWidget {
  final RegisterController controller;

  const LocalAtendimentoSection({
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
            const Row(
              children: [
                Text(
                  'Local de atendimento',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 32.0, right: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.locaisAtendimento.isEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'O local de atendimento serve para ajudar a preencher o receituário e ajudar a nossa IA a fazer sugestões baseado no contexto de atendimento, você pode cadastrar múltiplos locais.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.secondaryText,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TertiaryIconButtonMedGo(
                          title: 'Cadastrar local de atendimento',
                          leftIcon: Icon(
                            PhosphorIcons.plusCircle(
                                PhosphorIconsStyle.regular),
                          ),
                          onTap: controller.showNewLocalForm,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  const SizedBox(height: 24),
                  ..._buildLocaisAtendimentoContent(context),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildLocaisAtendimentoContent(BuildContext context) {
    List<Widget> content = [];

    // Adiciona os cards dos locais salvos
    for (int i = 0; i < controller.locaisAtendimento.length; i++) {
      // Se está editando este local, mostra o formulário
      if (controller.editingLocalIndex == i) {
        content.add(
          LocalAtendimentoFormWidget(
            controller: controller,
            index: i,
            onCancel: () {
              // Callback adicional se necessário
            },
            onSave: () {
              // Callback adicional se necessário
            },
          ),
        );
        content.add(const SizedBox(height: 16));
      } else {
        // Caso contrário, mostra o card
        content.add(
          LocalAtendimentoCard(
            localData: controller.locaisAtendimento[i].toMap(),
            onEdit: () => controller.editLocal(i),
            onDelete: () {
              controller.deleteLocal(i);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Local de atendimento excluído!')),
              );
            },
          ),
        );
        content.add(const SizedBox(height: 16));
      }
    }

    // Adiciona o formulário novo se estiver visível
    if (controller.showNovoLocalForm) {
      content.add(
        LocalAtendimentoFormWidget(
          controller: controller,
          onCancel: () {
            // Callback adicional se necessário
          },
          onSave: () {
            // Callback adicional se necessário
          },
        ),
      );
      content.add(const SizedBox(height: 16));
    }

    // Botão para adicionar outro local (só aparece se não estiver mostrando formulário)
    if (!controller.showNovoLocalForm &&
        controller.editingLocalIndex == null &&
        controller.locaisAtendimento.isNotEmpty) {
      content.add(
        TertiaryIconButtonMedGo(
          title: 'Cadastrar outro local de atendimento',
          leftIcon: Icon(
            PhosphorIcons.plusCircle(PhosphorIconsStyle.regular),
          ),
          onTap: controller.showNewLocalForm,
        ),
      );
    }

    return content;
  }
}
