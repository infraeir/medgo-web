abstract class BaseValidation {
  bool? required;
  String? requiredErrorMessage;

  BaseValidation({this.required, this.requiredErrorMessage});

  Map<String, dynamic> toMap();
}

class StringValidation extends BaseValidation {
  String? regex;
  String? regexErrorMessage;
  int? minLength;
  String? minLengthErrorMessage;
  int? maxLength;
  String? maxLengthErrorMessage;

  StringValidation({
    bool? required,
    String? requiredErrorMessage,
    this.regex,
    this.regexErrorMessage,
    this.minLength,
    this.minLengthErrorMessage,
    this.maxLength,
    this.maxLengthErrorMessage,
  }) : super(required: required, requiredErrorMessage: requiredErrorMessage);

  factory StringValidation.fromJson(Map<String, dynamic> json) {
    return StringValidation(
      required: json['required'],
      requiredErrorMessage: json['requiredErrorMessage'],
      regex: json['regex'],
      regexErrorMessage: json['regexErrorMessage'],
      minLength: json['minLength'],
      minLengthErrorMessage: json['minLengthErrorMessage'],
      maxLength: json['maxLength'],
      maxLengthErrorMessage: json['maxLengthErrorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'required': required,
      'requiredErrorMessage': requiredErrorMessage,
      'regex': regex,
      'regexErrorMessage': regexErrorMessage,
      'minLength': minLength,
      'minLengthErrorMessage': minLengthErrorMessage,
      'maxLength': maxLength,
      'maxLengthErrorMessage': maxLengthErrorMessage,
    };
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'required': required,
      'requiredErrorMessage': requiredErrorMessage,
      'regex': regex,
      'regexErrorMessage': regexErrorMessage,
      'minLength': minLength,
      'minLengthErrorMessage': minLengthErrorMessage,
      'maxLength': maxLength,
      'maxLengthErrorMessage': maxLengthErrorMessage,
    };
  }

  String? validate(String? value) {
    if (required == true && (value == null || value.isEmpty)) {
      return requiredErrorMessage ?? 'Este campo é obrigatório';
    }

    if (regex != null && value != null && !RegExp(regex!).hasMatch(value)) {
      return regexErrorMessage ?? 'Formato inválido';
    }

    if (minLength != null && value != null && value.length < minLength!) {
      return minLengthErrorMessage ??
          'O texto deve ter pelo menos $minLength caracteres';
    }

    if (maxLength != null && value != null && value.length > maxLength!) {
      return maxLengthErrorMessage ??
          'O texto deve ter no máximo $maxLength caracteres';
    }

    return null; // Nenhum erro
  }
}

class NumberValidation extends BaseValidation {
  double? min;
  String? minErrorMessage;
  double? max;
  String? maxErrorMessage;

  NumberValidation({
    bool? required,
    String? requiredErrorMessage,
    this.min,
    this.minErrorMessage,
    this.max,
    this.maxErrorMessage,
  }) : super(required: required, requiredErrorMessage: requiredErrorMessage);

  factory NumberValidation.fromJson(Map<String, dynamic> json) {
    return NumberValidation(
      required: json['required'],
      requiredErrorMessage: json['requiredErrorMessage'],
      min: json['min'] * 1.0,
      minErrorMessage: json['minErrorMessage'],
      max: json['max'] * 1.0,
      maxErrorMessage: json['maxErrorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'required': required,
      'requiredErrorMessage': requiredErrorMessage,
      'min': min,
      'minErrorMessage': minErrorMessage,
      'max': max,
      'maxErrorMessage': maxErrorMessage,
    };
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'required': required,
      'requiredErrorMessage': requiredErrorMessage,
      'min': min,
      'minErrorMessage': minErrorMessage,
      'max': max,
      'maxErrorMessage': maxErrorMessage,
    };
  }

  String? validate(int? value) {
    if (required == true && value == null) {
      return requiredErrorMessage ?? 'Este campo é obrigatório';
    }

    if (min != null && value != null && value < min!) {
      return minErrorMessage ?? 'O valor não pode ser menor que $min';
    }

    if (max != null && value != null && value > max!) {
      return maxErrorMessage ?? 'O valor não pode ser maior que $max';
    }

    return null; // Nenhum erro
  }
}
