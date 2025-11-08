// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:medgo/data/providers/signin_service.dart';
import 'package:medgo/strings/strings.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/custom_toast.dart';
import 'package:medgo/widgets/news_widgets/buttons/primary_icon_button.dart';
import 'package:medgo/widgets/news_widgets/buttons/tertiary_icon_button.dart';
import 'package:medgo/widgets/news_widgets/email_input.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class ResetModal extends StatefulWidget {
  final String? email;
  const ResetModal({
    super.key,
    required this.email,
  });

  @override
  State<ResetModal> createState() => _ResetModalState();
}

class _ResetModalState extends State<ResetModal> {
  TextEditingController emailController = TextEditingController();
  bool _isEmailError = false;
  bool _isButtonDisabled = false;
  int _timeLeft = 60; // 60 segundos = 1 minuto
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.email != null) {
      emailController.text = widget.email!;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _isButtonDisabled = false;
          timer.cancel();
        }
      });
    });
  }

  recover() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      int statusCode = await recoverPassword(emailController.text);

      String mensagem;
      Color backgroundColor;
      IconData icon;
      startTimer();

      switch (statusCode) {
        case 204:
          mensagem =
              'Se o e-mail inserido estiver cadastrado, em breve você receberá um link para redefir sua senha!';
          backgroundColor = AppTheme.success;
          icon = PhosphorIcons.checkCircle(PhosphorIconsStyle.bold);
          await preferences.setString('emailReset', emailController.text);
          Navigator.pop(context);
          break;

        case 429:
          mensagem =
              'Você excedeu o número de tentativa, aguarde para tentar novamente!';
          backgroundColor = AppTheme.warning;
          icon = PhosphorIcons.warning(PhosphorIconsStyle.bold);
          Navigator.pop(context);
          break;

        default:
          mensagem =
              'Ocorreu um erro no serviço, por favor tente novamente mais tarde!';
          backgroundColor = AppTheme.error;
          icon = PhosphorIcons.xCircle(PhosphorIconsStyle.bold);
          Navigator.pop(context);
          break;
      }

      // Mostra o toast personalizado
      showCustomToast(context, mensagem, backgroundColor, icon);
    } catch (e) {
      showCustomToast(
        context,
        'Ocorreu um erro inesperado. Por favor, tente novamente.',
        AppTheme.error,
        PhosphorIcons.xCircle(PhosphorIconsStyle.bold),
      );
    }
  }

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
            },
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 4), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Center(
        child: Dialog(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          )),
          child: Container(
            width: 660,
            decoration: BoxDecoration(
              color: AppTheme.secondaryBackground,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Sombra mais suave
                  blurRadius: 30,
                  offset: const Offset(0, 5),
                  spreadRadius: 10,
                ),
              ],
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Recuperar senha',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          shadows: [
                            Shadow(
                              color: AppTheme.primary.withOpacity(0.3),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Informe seu e-mail para receber um código de redefinição de senha',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          shadows: [
                            Shadow(
                              color: AppTheme.primary.withOpacity(0.3),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'E-mail',
                            style: TextStyle(
                              color: AppTheme.secondaryText,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: EmailInputMedgo(
                              controller: emailController,
                              hintText: 'Digite seu e-mail',
                              onChanged: (value) {
                                bool hasError = value.isNotEmpty;
                                setState(() {
                                  _isEmailError = !hasError;
                                });
                              },
                              errorText: _isEmailError
                                  ? 'Email digitado inválido'
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PrimaryIconButtonMedGo(
                      leftIcon: PhosphorIcon(
                        PhosphorIcons.caretLeft(
                          PhosphorIconsStyle.bold,
                        ),
                        color: AppTheme.warning,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      title: Strings.voltar,
                    ),
                    const SizedBox(width: 8.0),
                    TertiaryIconButtonMedGo(
                      rightIcon: PhosphorIcon(
                        PhosphorIcons.paperPlaneRight(
                          PhosphorIconsStyle.bold,
                        ),
                        color: AppTheme.success,
                      ),
                      onTap: _isButtonDisabled
                          ? () {}
                          : () {
                              setState(() {
                                _isButtonDisabled = true;
                                _timeLeft = 60;
                              });
                              recover();
                            },
                      title: _isButtonDisabled
                          ? 'Aguarde ${_timeLeft}s'
                          : 'Enviar link',
                      isDisabled: _isButtonDisabled,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
