class ConsultationSocketModel {
  final String consultationId;
  final List<DiagnosisSocketModel>? suggestions;
  final List<DiagnosisSocketModel>? hypotheses;
  final List<DiagnosisSocketModel>? confirmed;

  ConsultationSocketModel(
      {required this.consultationId,
      this.suggestions,
      this.hypotheses,
      this.confirmed});

  factory ConsultationSocketModel.fromJson(Map<String, dynamic> json) {
    var suggestionsFromJson = json['suggestions'];
    List<DiagnosisSocketModel>? suggestionsList;

    var hypothesesFromJson = json['hypotheses'];
    List<DiagnosisSocketModel>? hypothesesList;

    var confirmedFromJson = json['confirmed'];
    List<DiagnosisSocketModel>? confirmedList;

    if (suggestionsFromJson != null) {
      suggestionsList = (suggestionsFromJson as List)
          .map(
              (suggestionJson) => DiagnosisSocketModel.fromJson(suggestionJson))
          .toList();
    }

    if (hypothesesFromJson != null) {
      hypothesesList = (hypothesesFromJson as List)
          .map((hypotheseJson) => DiagnosisSocketModel.fromJson(hypotheseJson))
          .toList();
    }

    if (confirmedFromJson != null) {
      confirmedList = (confirmedFromJson as List)
          .map((confirmedJson) => DiagnosisSocketModel.fromJson(confirmedJson))
          .toList();
    }

    return ConsultationSocketModel(
        consultationId: json['consultationId'] ?? json['calculatorId'],
        suggestions: suggestionsList,
        hypotheses: hypothesesList,
        confirmed: confirmedList);
  }
}

class DiagnosisSocketModel {
  final String? id;
  final String? title;
  final List<CriteriaSocketModel>? criteria;
  final List<ConductsSocketModel>? conducts;

  DiagnosisSocketModel({
    required this.id,
    required this.title,
    required this.criteria,
    required this.conducts,
  });

  factory DiagnosisSocketModel.fromJson(Map<String, dynamic> json) {
    var criteriaFromJson = json['criteria'];
    var conductFromJson = json['conducts'];
    List<CriteriaSocketModel>? criteriaList;
    List<ConductsSocketModel>? conductList;

    if (criteriaFromJson != null) {
      if (criteriaFromJson.isNotEmpty) {
        criteriaList = (criteriaFromJson as List)
            .map((criteriaJson) => CriteriaSocketModel.fromJson(criteriaJson))
            .toList();
      }
    }

    if (conductFromJson != null) {
      if (conductFromJson.isNotEmpty) {
        conductList = (conductFromJson as List)
            .map((conductJson) => ConductsSocketModel.fromJson(conductJson))
            .toList();
      }
    }

    return DiagnosisSocketModel(
      id: json['id'],
      title: json['title'],
      criteria: criteriaList,
      conducts: conductList,
    );
  }
}

class CriteriaSocketModel {
  final String? reason;
  final bool? editable;

  CriteriaSocketModel({required this.reason, required this.editable});

  factory CriteriaSocketModel.fromJson(Map<String, dynamic> json) {
    return CriteriaSocketModel(
      reason: json['reason'],
      editable: json['editable'],
    );
  }
}

class ConductsSocketModel {
  final String? age;
  final String? dose;
  final String? id;
  final String? name;
  final String? originType;
  final bool? accepted;

  ConductsSocketModel({
    required this.age,
    required this.accepted,
    required this.dose,
    required this.id,
    required this.name,
    required this.originType,
  });

  factory ConductsSocketModel.fromJson(Map<String, dynamic> json) {
    return ConductsSocketModel(
      age: json['age'],
      accepted: json['accepted'],
      dose: json['dose'],
      id: json['id'],
      name: json['name'],
      originType: json['originType'],
    );
  }
}
