import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/button/toggle_primary_button.dart';
import 'package:medgo/widgets/news_widgets/buttons/clickable_text.dart';
import 'package:medgo/widgets/news_widgets/buttons/primary_icon_button.dart';
import 'package:medgo/widgets/news_widgets/buttons/primary_text_button.dart';
import 'package:medgo/widgets/news_widgets/buttons/secondary_icon_button.dart';
import 'package:medgo/widgets/news_widgets/buttons/secondary_text_button.dart';
import 'package:medgo/widgets/news_widgets/buttons/tertiary_icon_button.dart';
import 'package:medgo/widgets/news_widgets/buttons/tertiary_text_button.dart';
import 'package:medgo/widgets/news_widgets/icon_button.dart';
import 'package:medgo/widgets/news_widgets/count_input/count_input.dart';
import 'package:medgo/widgets/news_widgets/count_input/count_input_controller.dart';
import 'package:medgo/widgets/news_widgets/email_input.dart';
import 'package:medgo/widgets/news_widgets/input_chip.dart';
import 'package:medgo/widgets/news_widgets/input_icon_chip.dart';
import 'package:medgo/widgets/news_widgets/long_text_input.dart';
import 'package:medgo/widgets/news_widgets/password_input.dart';
import 'package:medgo/widgets/news_widgets/short_text_input.dart';
import 'package:medgo/widgets/news_widgets/toggable_icon.dart';
import 'package:medgo/widgets/news_widgets/search_select.dart';
import 'package:medgo/widgets/news_widgets/multi_select_chip.dart';
import 'package:medgo/widgets/news_widgets/date_input.dart';
import 'package:medgo/widgets/news_widgets/uf_input.dart';
import 'package:medgo/widgets/news_widgets/registro_medico_input.dart';
import 'package:medgo/widgets/news_widgets/cpf_input.dart';
import 'package:medgo/widgets/news_widgets/cns_input.dart';
import 'package:medgo/widgets/news_widgets/phone_input.dart';
import 'package:medgo/widgets/news_widgets/cep_input.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BibliotecaPage extends StatefulWidget {
  const BibliotecaPage({super.key});

  @override
  State<BibliotecaPage> createState() => _BibliotecaPageState();
}

class _BibliotecaPageState extends State<BibliotecaPage> {
  bool _showError = false;
  final CountInputController controllerQtd = CountInputController(0);
  final CountInputController controllerQtdDisabled = CountInputController(0);
  final TextEditingController controllerLongText = TextEditingController();

  final selectedChip = ValueNotifier<bool>(false);
  final selecteIcondChip = ValueNotifier<bool>(false);

  final selectedTogglable = ValueNotifier<bool>(false);
  final selectedTogglableDisabled = ValueNotifier<bool>(false);

  List<String> selectedMultiChipIds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 32.0),
                  child: Text(
                    'Biblioteca de componentes',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ),
              // Layout de duas colunas
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Coluna da esquerda
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Inputs de Texto
                        _buildSectionTitle('Short Text Inputs'),
                        const SizedBox(height: 16),
                        _buildInputGroup(
                          children: [
                            const ShortTextInputMedgo(hintText: "Default"),
                            const SizedBox(height: 16),
                            const ShortTextInputMedgo(
                                hintText: "Disabled", enabled: false),
                            const SizedBox(height: 16),
                            const ShortTextInputMedgo(
                              hintText: "Error",
                              errorText: "Campo inválido",
                            ),
                            const SizedBox(height: 16),
                            const ShortTextInputMedgo(
                              hintText: "Com Prefixo",
                              prefixIcon: PhosphorIconsRegular.user,
                            ),
                            const SizedBox(height: 16),
                            EmailInputMedgo(
                              onChanged: (email) {
                                print('E-mail digitado: $email');
                              },
                            ),
                            const SizedBox(height: 16),
                            PasswordInputMedgo(
                              errorText:
                                  _showError ? 'Senha muito curta' : null,
                              onChanged: (value) {
                                setState(() {
                                  _showError = value.length < 6;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            DateInputMedgo(
                              labelText: 'Data de Nascimento',
                              onDateChanged: (date) {
                                if (date != null) {
                                  print(
                                      'Data válida selecionada: ${date.day}/${date.month}/${date.year}');
                                } else {
                                  print('Data inválida');
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            UfInputMedgo(
                              labelText: 'UF',
                              onChanged: (value) {
                                print('UF digitada: $value');
                              },
                            ),
                            const SizedBox(height: 16),
                            RegistroMedicoInputMedgo(
                              labelText: 'Nº do Registro (CRM)',
                              onChanged: (value) {
                                print('Registro: $value');
                              },
                            ),
                            const SizedBox(height: 16),
                            CpfInputMedgo(
                              labelText: 'CPF',
                              onChanged: (value) {
                                print('CPF: $value');
                              },
                            ),
                            const SizedBox(height: 16),
                            CnsInputMedgo(
                              labelText: 'CNS',
                              onChanged: (value) {
                                print('CNS: $value');
                              },
                            ),
                            const SizedBox(height: 16),
                            PhoneInputMedgo(
                              labelText: 'Celular',
                              onChanged: (value) {
                                print('Celular: $value');
                              },
                            ),
                            const SizedBox(height: 16),
                            CepInputMedgo(
                              labelText: 'CEP',
                              onChanged: (value) {
                                print('CEP: $value');
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Search Select
                        _buildSectionTitle('Search Select'),
                        const SizedBox(height: 16),
                        _buildInputGroup(
                          children: [
                            SearchSelectMedgo<String>(
                              items: const [
                                'Paracetamol 500mg',
                                'Ibuprofeno 600mg',
                                'Dipirona 500mg',
                                'Amoxicilina 500mg',
                                'Azitromicina 500mg',
                                'Omeprazol 20mg',
                                'Losartana 50mg',
                                'Sinvastatina 20mg',
                                'Metformina 850mg',
                                'Enalapril 10mg',
                              ],
                              hintText: "Procurar",
                              itemLabel: (item) => item,
                              onChanged: (value) {
                                print('Medicamento selecionado: $value');
                              },
                              floatingButtonTitle: 'Cadastrar nova medicação',
                              floatingButtonIcon: Icon(
                                size: 18.0,
                                PhosphorIcons.plusCircle(
                                  PhosphorIconsStyle.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SearchSelectMedgo<Map<String, String>>(
                              items: const [
                                {
                                  'id': '1',
                                  'name': 'Paracetamol',
                                  'dose': '500mg'
                                },
                                {
                                  'id': '11',
                                  'name': 'Paracetamol teste do Pedro',
                                  'dose': '500mg'
                                },
                                {
                                  'id': '11',
                                  'name': 'Paracetamol Cocaina do Pedro',
                                  'dose': '500mg'
                                },
                                {
                                  'id': '2',
                                  'name': 'Ibuprofeno',
                                  'dose': '600mg'
                                },
                                {
                                  'id': '3',
                                  'name': 'Dipirona',
                                  'dose': '500mg'
                                },
                                {
                                  'id': '4',
                                  'name': 'Amoxicilina',
                                  'dose': '500mg'
                                },
                              ],
                              hintText: "Procurar",
                              itemLabel: (item) =>
                                  '${item['name']} - ${item['dose']}',
                              onChanged: (value) {
                                if (value != null) {
                                  print(
                                      'Selecionado: ${value['name']} - ${value['dose']}');
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Text Buttons
                        _buildSectionTitle('Text Buttons'),
                        const SizedBox(height: 16),
                        _buildInputGroup(
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Primary Text Button',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    PrimaryTextButtonMedGo(
                                      title: "Botão",
                                      onTap: () {},
                                    ),
                                    const SizedBox(height: 8),
                                    PrimaryTextButtonMedGo(
                                      isDisabled: true,
                                      title: "Botão",
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 32),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Secondary Text Button',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    SecondaryTextButtonMedGo(
                                      title: "Botão",
                                      onTap: () {},
                                    ),
                                    const SizedBox(height: 8),
                                    SecondaryTextButtonMedGo(
                                      isDisabled: true,
                                      title: "Botão",
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tertiary Text Button',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TertiaryTextButtonMedGo(
                                  title: "Botão",
                                  onTap: () {},
                                ),
                                const SizedBox(height: 8),
                                TertiaryTextButtonMedGo(
                                  isDisabled: true,
                                  title: "Botão",
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Icon Buttons
                        _buildSectionTitle('Icon Buttons'),
                        const SizedBox(height: 16),
                        _buildInputGroup(
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Primary Icon Button',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    PrimaryIconButtonMedGo(
                                      title: 'Botão com Ícones',
                                      onTap: () {},
                                      leftIcon: Icon(
                                        PhosphorIcons.placeholder(
                                          PhosphorIconsStyle.bold,
                                        ),
                                      ),
                                      rightIcon: Icon(
                                        PhosphorIcons.placeholder(
                                          PhosphorIconsStyle.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    PrimaryIconButtonMedGo(
                                      title: 'Botão com Ícone',
                                      onTap: () {},
                                      leftIcon: Icon(
                                        PhosphorIcons.placeholder(
                                          PhosphorIconsStyle.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    PrimaryIconButtonMedGo(
                                      title: 'Botão com Ícone',
                                      onTap: () {},
                                      rightIcon: Icon(
                                        PhosphorIcons.placeholder(
                                          PhosphorIconsStyle.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    PrimaryIconButtonMedGo(
                                      title: 'Botão com Ícone',
                                      isDisabled: true,
                                      onTap: () {},
                                      rightIcon: Icon(
                                        PhosphorIcons.placeholder(
                                          PhosphorIconsStyle.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    PrimaryIconButtonMedGo(
                                      onTap: () {},
                                      rightIcon: Icon(
                                        PhosphorIcons.placeholder(
                                          PhosphorIconsStyle.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 32,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Secondary Icon Button',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    SecondaryIconButtonMedGo(
                                      title: 'Botão com Ícones',
                                      onTap: () {},
                                      leftIcon: Icon(
                                        PhosphorIcons.placeholder(
                                          PhosphorIconsStyle.bold,
                                        ),
                                      ),
                                      rightIcon: Icon(
                                        PhosphorIcons.placeholder(
                                          PhosphorIconsStyle.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    SecondaryIconButtonMedGo(
                                      title: 'Botão com Ícone',
                                      onTap: () {},
                                      leftIcon: Icon(
                                        PhosphorIcons.placeholder(
                                          PhosphorIconsStyle.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    SecondaryIconButtonMedGo(
                                      title: 'Botão com Ícone',
                                      onTap: () {},
                                      rightIcon: Icon(
                                        PhosphorIcons.placeholder(
                                          PhosphorIconsStyle.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    PrimaryIconButtonMedGo(
                                      title: 'Botão com Ícone',
                                      isDisabled: true,
                                      onTap: () {},
                                      rightIcon: Icon(
                                        PhosphorIcons.placeholder(
                                          PhosphorIconsStyle.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    PrimaryIconButtonMedGo(
                                      onTap: () {},
                                      rightIcon: Icon(
                                        PhosphorIcons.placeholder(
                                          PhosphorIconsStyle.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tertiary Icon Button',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TertiaryIconButtonMedGo(
                                  title: 'Botão com Ícones',
                                  onTap: () {},
                                  leftIcon: Icon(
                                    PhosphorIcons.placeholder(
                                      PhosphorIconsStyle.bold,
                                    ),
                                  ),
                                  rightIcon: Icon(
                                    PhosphorIcons.placeholder(
                                      PhosphorIconsStyle.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TertiaryIconButtonMedGo(
                                  title: 'Botão com Ícone',
                                  onTap: () {},
                                  leftIcon: Icon(
                                    PhosphorIcons.placeholder(
                                      PhosphorIconsStyle.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TertiaryIconButtonMedGo(
                                  title: 'Botão com Ícone',
                                  onTap: () {},
                                  rightIcon: Icon(
                                    PhosphorIcons.placeholder(
                                      PhosphorIconsStyle.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TertiaryIconButtonMedGo(
                                  title: 'Botão com Ícone',
                                  isDisabled: true,
                                  onTap: () {},
                                  rightIcon: Icon(
                                    PhosphorIcons.placeholder(
                                      PhosphorIconsStyle.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TertiaryIconButtonMedGo(
                                  onTap: () {},
                                  rightIcon: Icon(
                                    PhosphorIcons.placeholder(
                                      PhosphorIconsStyle.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),
                  // Coluna da direita
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Chips
                        _buildSectionTitle('Chips'),
                        const SizedBox(height: 16),
                        _buildInputGroup(
                          children: [
                            InputChipMedgo(
                              selectedChip: selectedChip.value,
                              onSelected: (selected) {
                                print('Chip selecionado: $selected');
                                selectedChip.value = selected;
                                setState(() {});
                              },
                              title: 'Example Chip',
                            ),
                            const SizedBox(height: 16),
                            InputIconChipMedgo(
                              icon: Icon(
                                PhosphorIcons.person(),
                                color: AppTheme.salmon,
                                shadows: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 4.0,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                size: 16,
                              ),
                              selectedChip: selecteIcondChip.value,
                              onSelected: (selected) {
                                print('Chip selecionado: $selected');
                                selecteIcondChip.value = selected;
                                setState(() {});
                              },
                              title: 'Chip com Ícone',
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Multi Select Chips
                        _buildSectionTitle('Multi Select Chips'),
                        const SizedBox(height: 16),
                        _buildInputGroup(
                          children: [
                            MultiSelectChipMedgo(
                              items: const [
                                {'id': '1', 'title': 'Cardiologia'},
                                {'id': '2', 'title': 'Pediatria'},
                                {'id': '3', 'title': 'Neurologia'},
                                {'id': '4', 'title': 'Ortopedia'},
                                {'id': '5', 'title': 'Dermatologia'},
                                {'id': '6', 'title': 'Oftalmologia'},
                              ],
                              selectedIds: selectedMultiChipIds,
                              onSelectionChanged: (selectedIds) {
                                setState(() {
                                  selectedMultiChipIds = selectedIds;
                                });
                                print('IDs selecionados: $selectedIds');
                              },
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Selecionados: ${selectedMultiChipIds.isEmpty ? "Nenhum" : selectedMultiChipIds.join(", ")}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.secondaryText,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Count Inputs
                        _buildSectionTitle('Count Inputs'),
                        const SizedBox(height: 16),
                        _buildInputGroup(
                          children: [
                            CountInputMedgo(
                              controller: controllerQtd,
                              onChanged: (value) {},
                            ),
                            const SizedBox(height: 16),
                            CountInputMedgo(
                              controller: controllerQtdDisabled,
                              onChanged: (value) {},
                              disabled: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Long Text Inputs
                        _buildSectionTitle('Long Text Inputs'),
                        const SizedBox(height: 16),
                        _buildInputGroup(
                          children: [
                            LongTextInputMedgo(
                              controller: controllerLongText,
                              hintText: 'Digite sua mensagem...',
                              minLines: 4,
                              maxLines: null,
                              onChanged: (value) {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Clickable Icon
                        _buildSectionTitle('Clickable Icon'),
                        const SizedBox(height: 16),
                        _buildInputGroup(
                          children: [
                            CustomIconButtonMedGo(
                              icon: Icon(
                                PhosphorIconsBold.placeholder,
                                size: 30,
                                color: AppTheme.primary,
                                shadows: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 2.0,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                print('Ícone clicado!');
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomIconButtonMedGo(
                              disabled: true,
                              icon: Icon(
                                PhosphorIconsBold.placeholder,
                                size: 30,
                                color: AppTheme.secondaryText,
                                shadows: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 2.0,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                print('Ícone clicado!');
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Togglable Icon
                        _buildSectionTitle('Togglable Icon'),
                        const SizedBox(height: 16),
                        _buildInputGroup(
                          children: [
                            ToggleIconButtonMedgo(
                              isSelected: selectedTogglable.value,
                              onToggle: (selected) {
                                setState(() {
                                  selectedTogglable.value = selected;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            ToggleIconButtonMedgo(
                              isSelected: selectedTogglableDisabled.value,
                              onToggle: (selected) {},
                              disabled: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // SwitchBar
                        _buildSectionTitle('SwitchBar'),
                        const SizedBox(height: 16),
                        _buildInputGroup(
                          children: [
                            SwitchBarMedGo(
                              options: [
                                SwitchBarOption(
                                  name: 'Opção 1',
                                  id: 'option1',
                                  icon: PhosphorIcons.placeholder(),
                                ),
                                SwitchBarOption(
                                  name: 'Opção 2',
                                  id: 'option2',
                                  icon: PhosphorIcons.placeholder(),
                                ),
                              ],
                              selectedId: 'option1',
                              onPressed: (id) {
                                print('Selecionado: $id');
                              },
                            ),
                            const SizedBox(height: 16),
                            SwitchBarMedGo(
                              options: [
                                SwitchBarOption(
                                  name: 'Opção 1',
                                  id: 'option1',
                                  icon: PhosphorIcons.placeholder(),
                                ),
                                SwitchBarOption(
                                  name: 'Opção 2',
                                  id: 'option2',
                                  icon: PhosphorIcons.placeholder(),
                                ),
                              ],
                              selectedId: 'option1',
                              isDisabled: true,
                              onPressed: (id) {
                                print('Selecionado: $id');
                              },
                            ),
                            const SizedBox(height: 16),
                            // Exemplo com múltiplas opções e ícones em lados diferentes
                            SwitchBarMedGo(
                              options: [
                                SwitchBarOption(
                                  name: 'Início',
                                  id: 'home',
                                  icon: PhosphorIcons.house(),
                                  iconOnRight: false, // Ícone à esquerda
                                ),
                                SwitchBarOption(
                                  name: 'Perfil',
                                  id: 'profile',
                                  icon: PhosphorIcons.user(),
                                  iconOnRight: true, // Ícone à direita
                                ),
                                SwitchBarOption(
                                  name: 'Config',
                                  id: 'settings',
                                  icon: PhosphorIcons.gear(),
                                  iconOnRight: false, // Ícone à esquerda
                                ),
                                SwitchBarOption(
                                  name: 'Ajuda',
                                  id: 'help',
                                  icon: PhosphorIcons.question(),
                                  iconOnRight: true, // Ícone à direita
                                ),
                              ],
                              selectedId: 'home',
                              onPressed: (id) {
                                print('Múltiplas opções - Selecionado: $id');
                              },
                            ),
                            const SizedBox(height: 16),
                            // Exemplo com ícones apenas à direita
                            SwitchBarMedGo(
                              options: [
                                SwitchBarOption(
                                  name: 'Download',
                                  id: 'download',
                                  icon: PhosphorIcons.downloadSimple(),
                                  iconOnRight: true,
                                ),
                                SwitchBarOption(
                                  name: 'Upload',
                                  id: 'upload',
                                  icon: PhosphorIcons.uploadSimple(),
                                  iconOnRight: true,
                                ),
                                SwitchBarOption(
                                  name: 'Sem Ícone',
                                  id: 'no_icon',
                                  // Sem ícone
                                ),
                              ],
                              selectedId: 'download',
                              onPressed: (id) {
                                print('Ícones à direita - Selecionado: $id');
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Clickable Text
                        _buildSectionTitle('Clickable Text'),
                        const SizedBox(height: 16),
                        _buildInputGroup(
                          children: [
                            ClickableTextMedgo(
                              text: 'Texto',
                              onTap: () {
                                print('Clicado!');
                              },
                              isDisabled: false,
                            ),
                            const SizedBox(height: 16),
                            ClickableTextMedgo(
                              text: 'Texto',
                              onTap: () {
                                print('Clicado!');
                              },
                              isDisabled: true,
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppTheme.primary,
      ),
    );
  }

  Widget _buildInputGroup({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
