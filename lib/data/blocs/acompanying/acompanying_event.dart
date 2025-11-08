abstract class CompanionEvent {}

class PostCompanion extends CompanionEvent {
  final String idPatient;
  final String name;
  final String gender;
  final String relationship;
  final String? relationshipAddInfo;

  PostCompanion({
    required this.idPatient,
    required this.name,
    required this.gender,
    required this.relationship,
    required this.relationshipAddInfo,
  });
}

class PostExtraCompanion extends CompanionEvent {
  final String consultationsID;
  final String name;
  final String gender;
  final String relationship;
  final String relationshipAddInfo;

  PostExtraCompanion({
    required this.consultationsID,
    required this.name,
    required this.gender,
    required this.relationship,
    required this.relationshipAddInfo,
  });
}

class PutCompanion extends CompanionEvent {
  final String idCompanion;
  final String idPatient;
  final String name;
  final String gender;
  final String relationship;
  final String relationshipAddInfo;

  PutCompanion({
    required this.idCompanion,
    required this.idPatient,
    required this.name,
    required this.gender,
    required this.relationship,
    required this.relationshipAddInfo,
  });
}

class PatchtExtraCompanion extends CompanionEvent {
  final String consultationsID;
  final String companionID;

  PatchtExtraCompanion({
    required this.consultationsID,
    required this.companionID,
  });
}

class DeleteCompanion extends CompanionEvent {
  final String companionID;

  DeleteCompanion({
    required this.companionID,
  });
}

class DeleteExtraCompanion extends CompanionEvent {
  final String consultationsID;
  final String companionID;

  DeleteExtraCompanion({
    required this.consultationsID,
    required this.companionID,
  });
}
