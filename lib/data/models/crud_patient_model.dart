class CrudPatientModel {
  int id;
  String? nome;
  String? sexo;
  String? dataNasc;
  String? etnia;
  String? nomePai;
  String? nomeMae;

  CrudPatientModel({
    required this.id,
    this.nome,
    this.sexo,
    this.dataNasc,
    this.etnia,
    this.nomePai,
    this.nomeMae,
  });

  factory CrudPatientModel.fromJson(Map<String, dynamic> json) =>
      CrudPatientModel(
        id: json["id"],
        nome: json["email"],
        sexo: json["sexo"],
        etnia: json['etnia'],
        dataNasc: json["dataNasc"],
        nomePai: json["nomePai"],
        nomeMae: json["nomeMae"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nome": nome,
        "sexo": sexo,
        "dataNasc": dataNasc,
        "etnia": etnia,
        "nomePai": nomePai,
        "nomeMae": nomeMae,
      };
}
