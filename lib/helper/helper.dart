import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medgo/themes/app_theme.dart';

abstract class Helper {
  static String getData(String dataString) {
    DateTime data = DateTime.parse(dataString);
    DateFormat formatter = DateFormat('dd/MM/yyyy');

    return formatter.format(data);
  }

  static String calcularIdade(String dataString) {
    DateTime dataNascimento = DateTime.parse(dataString);
    DateTime dataAtual = DateTime.now();

    int idade = dataAtual.year - dataNascimento.year;

    if (dataAtual.month < dataNascimento.month ||
        (dataAtual.month == dataNascimento.month &&
            dataAtual.day < dataNascimento.day)) {
      idade--;
    }

    return idade.toString();
  }

  static String convertToISO8601(String date) {
    DateFormat inputFormat = DateFormat('dd/MM/yyyy');
    DateFormat outputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");

    DateTime parsedDate = inputFormat.parse(date);
    String formattedDate = outputFormat.format(parsedDate);

    return formattedDate;
  }

  static String convertToDate(String date) {
    if (date == 'N/A' || date == '') {
      return '';
    }
    DateFormat inputDateFormat;
    if (date.length == 10) {
      inputDateFormat = DateFormat("yyyy-MM-dd");
    } else {
      inputDateFormat = DateFormat("yyyy-MM-dd'T'HH");
    }
    final outputDateFormat = DateFormat("dd/MM/yyyy");

    final inputDate = inputDateFormat.parse(date);
    final formattedDate = outputDateFormat.format(inputDate);

    return formattedDate;
  }

  static String convertToDate2(String date) {
    final inputDateFormat = DateFormat("yyyy-MM-dd");
    final outputDateFormat = DateFormat("dd/MM/yyyy");

    final inputDate = inputDateFormat.parse(date);
    final formattedDate = outputDateFormat.format(inputDate);

    return formattedDate;
  }

  static String? convertToDateString(String inputDate) {
    final inputDateFormat = DateFormat("dd/MM/yyyy");
    final outputDateFormat = DateFormat("yyyy-MM-dd");

    if (inputDate != "") {
      try {
        final parsedDate = inputDateFormat.parse(inputDate);
        final formattedDate = outputDateFormat.format(parsedDate);

        return formattedDate;
      } catch (_) {
        return null;
      }
    } else {
      return null;
    }
  }

  static String formatDateNow() {
    DateTime now = DateTime.now();

    String formatteDia = DateFormat('d', 'pt_BR').format(now);
    String formatteMes = DateFormat('MMMM', 'pt_BR').format(now);
    String formatteaAno = DateFormat('y', 'pt_BR').format(now);

    return '$formatteDia de $formatteMes de $formatteaAno';
  }

  static String getEthnicity(String ethnicity) {
    switch (ethnicity) {
      case 'brown':
        return 'Pardo';
      case 'white':
        return 'Branco';
      case 'black':
        return 'Negro';
      case 'indigenous':
        return 'Indígena';
      case 'yellow':
        return 'Amarelo';
      default:
        return 'Outro';
    }
  }

  static String getRelationship(String relationship) {
    switch (relationship) {
      case 'father':
        return 'Pai';
      case 'mother':
        return 'Mãe';
      case 'uncle':
        return 'Tio/Tia';
      case 'godfather':
        return 'Padrinho';
      case 'family_friend':
        return 'Amigo';
      default:
        return 'Outro';
    }
  }

  // final List<String> pathElements = route.split('/');
  /// Exibe uma [SnackBar] na tela. Precisa passar uma [message]
  /// e um [context]. A duração é opcional.
  static void showSnackBar({
    required String message,
    required BuildContext context,
    int? duration,
    Color? backgroundColor,
  }) {
    final snackBar = SnackBar(
      backgroundColor: backgroundColor,
      content: Text(
        message,
        style: AppTheme.h6(
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
      duration: Duration(milliseconds: duration ?? 4000),
      action: SnackBarAction(
        label: 'Fechar',
        textColor: Colors.white,
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Verifica o StatusCode
  static bool verificaStatusCode({required int statusCode}) {
    if (statusCode >= 200 && statusCode <= 299) {
      return true;
    }
    return false;
  }
}
