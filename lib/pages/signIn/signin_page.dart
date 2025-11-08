// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medgo/pages/signIn/widgets/reset_password_modal.dart';
import 'package:medgo/widgets/news_widgets/buttons/clickable_text.dart';
import 'package:medgo/widgets/news_widgets/buttons/tertiary_icon_button.dart';
import 'package:medgo/widgets/news_widgets/email_input.dart';
import 'package:medgo/widgets/news_widgets/password_input.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../themes/app_theme.dart';
import '../../data/providers/signin_service.dart';
import 'package:medgo/strings/strings.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key});

  @override
  State<SignInPage> createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late AnimationController _controller;
  bool isLoading = false;

  String textEmail = "";
  String textPassword = "";
  bool loginfail = false;
  bool emailEmpty = false;
  bool passwordEmpty = false;
  bool emailInvalid = false;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 750));
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  bool validateEmail(String email) {
    String pattern =
        r'''^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+''';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  void callLoginAfterEnter() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      hasAnimation();
      bool resp = await postLogin(textEmail, textPassword);
      if (resp) {
        // Salva as credenciais após login bem sucedido
        TextInput.finishAutofillContext(shouldSave: true);

        if (mounted) {
          context.go('/home');
        }
        hasAnimation();
        emailController.text = '';
        passwordController.text = '';

        loginfail = false;
      } else {
        setState(() {
          hasAnimation();
          loginfail = true;
        });
      }
    }
  }

  hasAnimation() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  _showEditPassword() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ResetModal(
          email: emailController.text.isNotEmpty ? emailController.text : null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            SvgPicture.asset(
              Strings.logoXGSvg,
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.height * 0.25,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Strings.title,
                  style: AppTheme.h2(
                    color: AppTheme.primaryText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              Strings.descriptionTitle,
              style: AppTheme.h5(
                color: AppTheme.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Form(
              key: _formKey,
              child: AutofillGroup(
                child: Column(
                  children: [
                    SizedBox(
                      width: 400,
                      child: EmailInputMedgo(
                        controller: emailController,
                        hintText: 'seuemail@exemplo.com',
                        labelText: 'Email',
                        enabled: !isLoading,
                        autofillHints: const [
                          AutofillHints.username,
                          AutofillHints.email
                        ],
                        errorText: emailEmpty
                            ? 'Email não pode estar vazio'
                            : emailInvalid
                                ? 'Formato de email inválido'
                                : loginfail
                                    ? 'Email ou senha incorretos'
                                    : null,
                        onChanged: (value) {
                          setState(() {
                            textEmail = value;
                            emailEmpty = false;
                            emailInvalid = false;
                            loginfail = false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 400,
                      child: PasswordInputMedgo(
                        controller: passwordController,
                        hintText: 'Inserir Senha',
                        labelText: 'Senha',
                        enabled: !isLoading,
                        autofillHints: const [AutofillHints.password],
                        errorText: passwordEmpty
                            ? 'Senha não pode estar vazia'
                            : loginfail
                                ? 'Email ou senha incorretos'
                                : null,
                        onChanged: (value) {
                          setState(() {
                            textPassword = value;
                            passwordEmpty = false;
                            loginfail = false;
                          });
                        },
                      ),
                    ),
                    loginfail
                        ? Container(
                            width: 400,
                            height: 40,
                            margin: const EdgeInsets.only(
                              top: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.errorContainer,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  PhosphorIcons.warningOctagon(),
                                  color: AppTheme.error,
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 4.0,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  'E-mail e/ou senha incorretos! Tente novamente.',
                                  style: AppTheme.h5(
                                    color: AppTheme.error,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                    Container(
                      width: 400,
                      margin: const EdgeInsets.only(top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ClickableTextMedgo(
                            text: Strings.forgotPasswordButtonTitle,
                            onTap: () {
                              _showEditPassword();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 400,
              child: TertiaryIconButtonMedGo(
                title: Strings.loginButtonTitle,
                leftIcon: Icon(
                  PhosphorIcons.signIn(
                    PhosphorIconsStyle.bold,
                  ),
                ),
                onTap: () {
                  callLoginAfterEnter();
                },
                isDisabled: isLoading,
              ),
            ),
            isLoading
                ? Lottie.asset(
                    'assets/animations/looping.json',
                    repeat: true,
                    animate: true,
                    width: 100,
                    height: 100,
                  )
                : Visibility(
                    visible: false,
                    child: Lottie.asset(
                      'assets/animations/looping.json',
                      repeat: false,
                      animate: false,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
