import 'package:medgo/widgets/dynamic_form/validation_model.dart';

mixin ValidationMixin {
  String? validateField(String? value, BaseValidation validations) {
    Map<String, dynamic> validationMap = validations.toMap();

    // Se o valor for nulo ou vazio, retorna nulo imediatamente
    if (value == null || value.isEmpty) {
      return null;
    }

    // Validações de comprimento
    if (validationMap['minLength'] != null &&
        value.length < validationMap['minLength']) {
      return validationMap['minLengthErrorMessage'] ??
          'Mínimo de ${validationMap['minLength']} caracteres';
    }

    if (validationMap['maxLength'] != null &&
        value.length > validationMap['maxLength']) {
      return validationMap['maxLengthErrorMessage'] ??
          'Máximo de ${validationMap['maxLength']} caracteres';
    }

    // Validações numéricas
    String valueToParse = value.replaceAll(',', '.');
    double numValue = double.tryParse(valueToParse) ?? 0;

    if (validationMap['min'] != null && numValue < validationMap['min']) {
      return validationMap['minErrorMessage'] ??
          'Valor mínimo é ${validationMap['min']}';
    }

    if (validationMap['max'] != null && numValue > validationMap['max']) {
      return validationMap['maxErrorMessage'] ??
          'Valor máximo é ${validationMap['max']}';
    }

    // Validação de regex
    if (validationMap['regex'] != null) {
      RegExp regex = RegExp(validationMap['regex']);
      if (!regex.hasMatch(value)) {
        return validationMap['regexErrorMessage'] ?? 'Formato inválido';
      }
    }

    return null;
  }
}
