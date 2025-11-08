import 'package:medgo/widgets/dynamic_form/info_painel_model.dart';

import 'validation_model.dart';

class ResponseForm {
  String? title;
  bool? isMinimized;
  bool? isDisabled;
  String? componentType;
  String? backendAttribute;
  String? inputType;
  List<String>? visibilityConditions;
  String? visibilityConditionOperator; // 'AND' or 'OR', default to 'AND'
  bool? multipleSelection;
  bool? flagged;
  dynamic prefilledValue;
  List<int>? prefilledIndexes;
  List<Options>? options;
  List<ResponseForm>? children;
  dynamic validations; // Adicionando a validação
  String? tooltip;
  bool? underline; // Variável para underline
  AvailabilityLabel? availabilityLabel;
  String? label;
  List<String>? references;
  InfoPainel? infoPainel;

  ResponseForm({
    this.title,
    this.isMinimized,
    this.isDisabled,
    this.componentType,
    this.backendAttribute,
    this.inputType,
    this.visibilityConditions,
    this.visibilityConditionOperator,
    this.multipleSelection,
    this.flagged,
    this.prefilledValue,
    this.prefilledIndexes,
    this.options,
    this.children,
    this.validations, // Incluindo validação no construtor
    this.tooltip,
    this.underline,
    this.availabilityLabel,
    this.label,
    this.references,
    this.infoPainel,
  });

  ResponseForm.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    isMinimized = json['isMinimized'];
    isDisabled = json['isDisabled'];
    componentType = json['componentType'];
    backendAttribute = json['backendAttribute'];
    inputType = json['inputType'];
    visibilityConditions = json['visibilityConditions'] != null
        ? List<String>.from(json['visibilityConditions'])
        : null;
    visibilityConditionOperator = json['visibilityConditionOperator'] ?? 'AND';
    multipleSelection = json['multipleSelection'];
    flagged = json['flagged'];
    tooltip = json['tooltip'];
    prefilledValue = json['prefilledValue'] ?? '';
    prefilledIndexes = json['prefilledIndexes'] != null
        ? List<int>.from(json['prefilledIndexes'])
        : null;
    options = json['options'] != null
        ? List<Options>.from(json['options'].map((v) => Options.fromJson(v)))
        : null;
    children = json['children'] != null
        ? List<ResponseForm>.from(
            json['children'].map((v) => ResponseForm.fromJson(v)))
        : [];
    validations = json['validations'] == null
        ? null
        : _parseValidations(
            json['validations'], json['inputType']); // Adicionando validações
    underline = json['underline'] ?? false;
    availabilityLabel = json['availabilityLabel'] != null
        ? AvailabilityLabel.fromJson(json['availabilityLabel'])
        : null;
    label = json['label']?.toString();
    references = json['references'] != null
        ? List<String>.from(json['references'])
        : null;
    infoPainel = json['infoPainel'] != null
        ? InfoPainel.fromJson(json['infoPainel'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['isMinimized'] = isMinimized;
    data['isDisabled'] = isDisabled;
    data['componentType'] = componentType;
    data['backendAttribute'] = backendAttribute;
    data['tooltip'] = tooltip;
    data['inputType'] = inputType;
    if (visibilityConditions != null) {
      data['visibilityConditions'] = visibilityConditions;
    }
    data['visibilityConditionOperator'] = visibilityConditionOperator;
    data['multipleSelection'] = multipleSelection;
    data['prefilledValue'] = prefilledValue;
    if (prefilledIndexes != null) {
      data['prefilledIndexes'] = prefilledIndexes;
    }
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    if (children != null) {
      data['children'] = children!.map((v) => v.toJson()).toList();
    }
    if (validations != null) {
      data['validations'] =
          validations.toJson(); // Adicionando validações no JSON
    }
    if (infoPainel != null) {
      data['infoPainel'] = infoPainel!.toJson();
    }

    return data;
  }

  // Função que mapeia as validações recebidas do backend
  dynamic _parseValidations(
      Map<String, dynamic>? validationsJson, String inputType) {
    if (validationsJson == null) return null;

    // Verifica se o inputType é numérico (int ou double)
    if (inputType == 'int' || inputType == 'double') {
      return NumberValidation.fromJson(
          validationsJson); // Validação para número (int ou double)
    }

    // Caso contrário, trata como validação de string
    return StringValidation.fromJson(validationsJson); // Validação para string
  }
}

class Options {
  String? label;
  dynamic value;

  Options({this.label, this.value});

  Options.fromJson(Map<String, dynamic> json) {
    label = json['label'].toString();
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['value'] = value;
    return data;
  }
}

class AvailabilityLabel {
  final bool value;
  final String label;

  AvailabilityLabel({
    required this.value,
    required this.label,
  });

  factory AvailabilityLabel.fromJson(Map<String, dynamic> json) {
    return AvailabilityLabel(
      value: json['value'] is bool
          ? json['value']
          : json['value'].toString().toLowerCase() == 'true',
      label: json['label'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'label': label,
    };
  }
}
