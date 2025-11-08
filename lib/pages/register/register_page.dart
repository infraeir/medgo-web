// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medgo/strings/strings.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/buttons/clickable_text.dart';
import 'package:medgo/widgets/news_widgets/password_input.dart';
import 'package:medgo/widgets/news_widgets/buttons/tertiary_icon_button.dart';
import 'package:medgo/pages/register/controller/register_controller.dart';
import 'package:medgo/pages/register/widgets/cadastro_section.dart';
import 'package:medgo/pages/register/widgets/dados_profissional_section.dart';
import 'package:medgo/pages/register/widgets/local_atendimento_section.dart';
import 'package:medgo/widgets/scrollbar/custom_scroll_bar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class RegisterPageMedGo extends StatefulWidget {
  const RegisterPageMedGo({super.key});

  @override
  State<RegisterPageMedGo> createState() => _RegisterPageMedGoState();
}

class _RegisterPageMedGoState extends State<RegisterPageMedGo> {
  late final RegisterController _controller;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = RegisterController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Conteúdo principal com scroll personalizado
          CustomScrollbar(
            trackMargin: const EdgeInsets.only(top: 150),
            controller: _scrollController,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: false,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListView(
                  controller: _scrollController,
                  padding: EdgeInsets.zero,
                  children: [
                    // Espaço para o header flutuante
                    const SizedBox(height: 120),
                    _buildAccessCodeSection(),
                    const SizedBox(height: 16),
                    _buildDivider(),
                    const SizedBox(height: 12),
                    _buildCadastroSection(),
                    const SizedBox(height: 12),
                    _buildDivider(),
                    const SizedBox(height: 12),
                    _buildDadosProfissionalSection(),
                    const SizedBox(height: 12),
                    _buildDivider(),
                    const SizedBox(height: 12),
                    _buildLocalAtendimentoSection(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
          // Header flutuante com blur e gradient
          _buildFloatingHeader(),
          // Floating Action Button
          _buildFloatingActionButton(),
        ],
      ),
    );
  }

  Widget _buildFloatingHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(1),
                  Colors.white.withOpacity(0.7),
                  Colors.white.withOpacity(0.0),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: SafeArea(
              child: _buildHeader(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          Strings.logoXGSvg,
          height: 70,
          width: 70,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 16),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Seja bem-vindo à MedGo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Faça seu cadastro para poder acessar!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAccessCodeSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 600,
              child: PasswordInputMedgo(
                controller: _controller.accessCodeController,
                hintText: 'Inserir código',
                labelText: 'Código de acesso',
                autofillHints: const [AutofillHints.password],
                onChanged: (value) {},
                isRequired: true,
              ),
            ),
          ],
        ),
        Container(
          width: 500,
          margin: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ClickableTextMedgo(
                text:
                    'Não tem código de cadastro? Clique aqui para entrar na fila de espera.',
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: AppTheme.accent1.withOpacity(0.3),
      thickness: 1,
      indent: 10,
      endIndent: 10,
    );
  }

  Widget _buildCadastroSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CadastroSection(controller: _controller),
        ],
      ),
    );
  }

  Widget _buildDadosProfissionalSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DadosProfissionalSection(controller: _controller),
        ],
      ),
    );
  }

  Widget _buildLocalAtendimentoSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: LocalAtendimentoSection(controller: _controller),
    );
  }

  Widget _buildFloatingActionButton() {
    return Positioned(
      right: 24,
      bottom: 24,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return TertiaryIconButtonMedGo(
            title: 'Cadastrar',
            rightIcon: Icon(
              PhosphorIcons.userCirclePlus(
                PhosphorIconsStyle.regular,
              ),
            ),
            onTap: () {
              if (_controller.isFormValid()) {
                _controller.submitRegistration();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cadastro realizado com sucesso!'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Preencha todos os campos obrigatórios'),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
