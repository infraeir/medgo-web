// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:medgo/data/providers/signin_service.dart';
import 'package:medgo/widgets/custom_toast.dart';
import 'package:medgo/widgets/news_widgets/buttons/tertiary_icon_button.dart';
import 'package:medgo/widgets/news_widgets/password_input.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../themes/app_theme.dart';
import 'package:medgo/strings/strings.dart';
import 'package:lottie/lottie.dart';

class ResetPasswordPage extends StatefulWidget {
  final String token;
  const ResetPasswordPage({Key? key, required this.token});

  @override
  State<ResetPasswordPage> createState() => ResetPasswordPageState();
}

class ResetPasswordPageState extends State<ResetPasswordPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordTwoController = TextEditingController();
  late AnimationController _controller;
  bool isLoading = false;

  String textEmail = "";
  String textPassword = "";
  String textTwoPassword = "";
  bool loginfail = false;
  bool passwordTwoEmpty = false;
  bool passwordEmpty = false;
  bool emailInvalid = false;

  bool success = false;
  String feedbackMessage = 'Senha alterada com sucesso!';

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    getEmail();
    super.initState();
  }

  getEmail() async {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);

    textEmail = decodedToken['email'] ?? '';
  }

  @override
  void dispose() {
    passwordController.dispose();
    passwordTwoController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void callResetAfterEnter() async {
    setState(() {
      passwordEmpty = passwordController.text.isEmpty;
      passwordTwoEmpty = passwordTwoController.text.isEmpty;
      loginfail = false;
    });

    if (passwordController.text != passwordTwoController.text) {
      showCustomToast(
        context,
        'As senhas não coincidem',
        AppTheme.error,
        PhosphorIcons.xCircle(PhosphorIconsStyle.bold),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      hasAnimation();
      final response =
          await resetPassword(widget.token, passwordController.text);
      hasAnimation();

      if (response.success) {
        showCustomToast(
          context,
          'Senha alterada com sucesso!',
          AppTheme.success,
          PhosphorIcons.checkCircle(PhosphorIconsStyle.bold),
        );

        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) context.go('/signin');
        });
      } else {
        showCustomToast(
          context,
          response.message,
          AppTheme.error,
          PhosphorIcons.xCircle(PhosphorIconsStyle.bold),
        );
      }
    }
  }

  hasAnimation() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => context.go('/'),
                child: SvgPicture.asset(
                  Strings.logoXGSvg,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  textEmail,
                  style: AppTheme.h3(
                    color: AppTheme.primaryText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Você está redefinindo sua senha',
              style: AppTheme.h5(
                color: AppTheme.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 50),
            Form(
              key: _formKey,
              child: AutofillGroup(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 400,
                      child: PasswordInputMedgo(
                        controller: passwordController,
                        hintText: 'Inserir senha',
                        labelText: 'Nova Senha',
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
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 400,
                      child: PasswordInputMedgo(
                        controller: passwordTwoController,
                        hintText: 'Inserir senha',
                        labelText: 'Redigite a nova senha',
                        enabled: !isLoading,
                        autofillHints: const [AutofillHints.password],
                        errorText: passwordTwoEmpty
                            ? 'Senha não pode estar vazia'
                            : loginfail
                                ? 'Email ou senha incorretos'
                                : null,
                        onChanged: (value) {
                          setState(() {
                            textTwoPassword = value;
                            passwordTwoEmpty = false;
                            loginfail = false;
                          });
                        },
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
                title: 'Redefinir a senha',
                leftIcon: Icon(
                  PhosphorIcons.arrowCounterClockwise(
                    PhosphorIconsStyle.bold,
                  ),
                  color: AppTheme.error,
                ),
                onTap: () {
                  callResetAfterEnter();
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

// Adicione o método showCustomToast (se não estiver em um arquivo separado)
void showCustomToast(BuildContext context, String message,
    Color backgroundColor, IconData icon) {
  OverlayState? overlayState = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50,
      left: 50,
      right: 50,
      child: Center(
        child: CustomToast(
          message: message,
          backgroundColor: backgroundColor,
          icon: icon,
          closeCallback: () {
            overlayEntry.remove();
          }, // Callback para fechar o toast
        ),
      ),
    ),
  );

  overlayState.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 8), () {
    overlayEntry.remove();
  });
}
