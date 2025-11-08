// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/short_text_input.dart';
import 'package:medgo/widgets/news_widgets/input_chip.dart';
import 'package:medgo/widgets/news_widgets/cep_input.dart';
import 'package:medgo/widgets/news_widgets/uf_input.dart';
import 'package:medgo/widgets/news_widgets/phone_input.dart';
import 'package:medgo/widgets/news_widgets/email_input.dart';
import 'package:medgo/widgets/news_widgets/buttons/primary_icon_button.dart';
import 'package:medgo/pages/register/controller/register_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LocalAtendimentoFormWidget extends StatelessWidget {
  final RegisterController controller;
  final int? index; // null para novo local, índice para edição
  final VoidCallback? onCancel;
  final VoidCallback? onSave;

  const LocalAtendimentoFormWidget({
    super.key,
    required this.controller,
    this.index,
    this.onCancel,
    this.onSave,
  });

  String get formKey => index != null ? 'edit_$index' : 'new';

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final controllers = controller.getFormControllers(formKey);
        final selectedContexto = controller.getTempContext(formKey);

        // Se os controllers não existem, não renderiza nada
        if (controllers.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              color: AppTheme.accent1.withOpacity(0.3),
              thickness: 1,
            ),
            _buildIdentificacaoSection(controllers, selectedContexto),
            const SizedBox(height: 24),
            _buildEnderecoSection(controllers),
            const SizedBox(height: 24),
            _buildContatoSection(controllers),
            const SizedBox(height: 16),
            _buildActionButtons(context, controllers, selectedContexto),
            Divider(
              color: AppTheme.accent1.withOpacity(0.3),
              thickness: 1,
            ),
          ],
        );
      },
    );
  }

  Widget _buildIdentificacaoSection(
      Map<String, TextEditingController> controllers,
      String? selectedContexto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Identificação',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          spacing: 8.0,
          children: [
            SizedBox(
              width: 400,
              child: ShortTextInputMedgo(
                controller: controllers['nome']!,
                labelText: 'Nome do local de atendimento',
                hintText: 'Ex: Hospital São Lucas',
                onChanged: (value) {},
                isRequired: true,
              ),
            ),
            SizedBox(
              width: 200,
              child: ShortTextInputMedgo(
                controller: controllers['cnes']!,
                labelText: 'CNES',
                hintText: '0000000',
                onChanged: (value) {},
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(7),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        RichText(
          text: const TextSpan(
            text: 'Contexto de atendimento',
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
            _buildContextChip('Ambulatorial Privado', selectedContexto),
            _buildContextChip('Ambulatorial Público', selectedContexto),
            _buildContextChip('Hospitalar Público', selectedContexto),
            _buildContextChip('Hospitalar Privado', selectedContexto),
            _buildContextChip('Atendimento Domiciliar', selectedContexto),
            _buildContextChip('Telemedicina', selectedContexto),
          ],
        ),
      ],
    );
  }

  Widget _buildContextChip(String title, String? selectedContexto) {
    return InputChipMedgo(
      title: title,
      selectedChip: selectedContexto == title,
      onSelected: (selected) {
        controller.updateTempContext(formKey, selected ? title : null);
      },
    );
  }

  Widget _buildEnderecoSection(Map<String, TextEditingController> controllers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Endereço local',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          spacing: 8.0,
          children: [
            SizedBox(
              width: 250,
              child: CepInputMedgo(
                controller: controllers['cep']!,
                labelText: 'CEP',
                onChanged: (value) {},
                isRequired: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          spacing: 8.0,
          children: [
            SizedBox(
              width: 350,
              child: ShortTextInputMedgo(
                controller: controllers['logradouro']!,
                labelText: 'Logradouro',
                hintText: 'Ex: Rua das Flores',
                onChanged: (value) {},
              ),
            ),
            SizedBox(
              width: 100,
              child: ShortTextInputMedgo(
                controller: controllers['numero']!,
                labelText: 'Número',
                hintText: '123',
                onChanged: (value) {},
              ),
            ),
            SizedBox(
              width: 75,
              child: UfInputMedgo(
                controller: controllers['uf']!,
                labelText: 'UF',
                onChanged: (value) {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          spacing: 8.0,
          children: [
            SizedBox(
              width: 250,
              child: ShortTextInputMedgo(
                controller: controllers['complemento']!,
                labelText: 'Complemento',
                hintText: 'Ex: Apto 101',
                onChanged: (value) {},
              ),
            ),
            SizedBox(
              width: 250,
              child: ShortTextInputMedgo(
                controller: controllers['bairro']!,
                labelText: 'Bairro',
                hintText: 'Ex: Centro',
                onChanged: (value) {},
              ),
            ),
            SizedBox(
              width: 250,
              child: ShortTextInputMedgo(
                controller: controllers['cidade']!,
                labelText: 'Cidade',
                hintText: 'Ex: São Paulo',
                onChanged: (value) {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContatoSection(Map<String, TextEditingController> controllers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contato',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          spacing: 8.0,
          children: [
            SizedBox(
              width: 250,
              child: PhoneInputMedgo(
                controller: controllers['telefone']!,
                labelText: 'Telefone',
                onChanged: (value) {},
              ),
            ),
            SizedBox(
              width: 350,
              child: EmailInputMedgo(
                controller: controllers['email']!,
                labelText: 'Email',
                onChanged: (value) {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(
      BuildContext context,
      Map<String, TextEditingController> controllers,
      String? selectedContexto) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      spacing: 8.0,
      children: [
        PrimaryIconButtonMedGo(
          leftIcon: Icon(
            size: 22,
            color: AppTheme.error,
            PhosphorIcons.trash(PhosphorIconsStyle.regular),
          ),
          onTap: () {
            if (index != null) {
              controller.cancelEditLocal(index!);
            } else {
              controller.hideNewLocalForm();
            }
            onCancel?.call();
          },
        ),
        PrimaryIconButtonMedGo(
          leftIcon: Icon(
            size: 22,
            color: AppTheme.success,
            PhosphorIcons.floppyDisk(PhosphorIconsStyle.regular),
          ),
          onTap: () {
            final success = controller.saveLocal(formKey, index);
            if (success) {
              onSave?.call();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Local de atendimento salvo!')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Preencha os campos obrigatórios'),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
