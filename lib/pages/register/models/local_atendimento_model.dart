class LocalAtendimentoModel {
  final String nome;
  final String cnes;
  final String contexto;
  final String cep;
  final String logradouro;
  final String numero;
  final String uf;
  final String complemento;
  final String bairro;
  final String cidade;
  final String telefone;
  final String email;

  LocalAtendimentoModel({
    required this.nome,
    required this.cnes,
    required this.contexto,
    required this.cep,
    required this.logradouro,
    required this.numero,
    required this.uf,
    required this.complemento,
    required this.bairro,
    required this.cidade,
    required this.telefone,
    required this.email,
  });

  // Construtor para criar um modelo vazio
  LocalAtendimentoModel.empty()
      : nome = '',
        cnes = '',
        contexto = '',
        cep = '',
        logradouro = '',
        numero = '',
        uf = '',
        complemento = '',
        bairro = '',
        cidade = '',
        telefone = '',
        email = '';

  // Construtor a partir de Map
  factory LocalAtendimentoModel.fromMap(Map<String, dynamic> map) {
    return LocalAtendimentoModel(
      nome: map['nome'] ?? '',
      cnes: map['cnes'] ?? '',
      contexto: map['contexto'] ?? '',
      cep: map['cep'] ?? '',
      logradouro: map['logradouro'] ?? '',
      numero: map['numero'] ?? '',
      uf: map['uf'] ?? '',
      complemento: map['complemento'] ?? '',
      bairro: map['bairro'] ?? '',
      cidade: map['cidade'] ?? '',
      telefone: map['telefone'] ?? '',
      email: map['email'] ?? '',
    );
  }

  // Converter para Map
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'cnes': cnes,
      'contexto': contexto,
      'cep': cep,
      'logradouro': logradouro,
      'numero': numero,
      'uf': uf,
      'complemento': complemento,
      'bairro': bairro,
      'cidade': cidade,
      'telefone': telefone,
      'email': email,
    };
  }

  // Método para validação
  bool isValid() {
    return nome.isNotEmpty && contexto.isNotEmpty && cep.isNotEmpty;
  }

  // Método copyWith para imutabilidade
  LocalAtendimentoModel copyWith({
    String? nome,
    String? cnes,
    String? contexto,
    String? cep,
    String? logradouro,
    String? numero,
    String? uf,
    String? complemento,
    String? bairro,
    String? cidade,
    String? telefone,
    String? email,
  }) {
    return LocalAtendimentoModel(
      nome: nome ?? this.nome,
      cnes: cnes ?? this.cnes,
      contexto: contexto ?? this.contexto,
      cep: cep ?? this.cep,
      logradouro: logradouro ?? this.logradouro,
      numero: numero ?? this.numero,
      uf: uf ?? this.uf,
      complemento: complemento ?? this.complemento,
      bairro: bairro ?? this.bairro,
      cidade: cidade ?? this.cidade,
      telefone: telefone ?? this.telefone,
      email: email ?? this.email,
    );
  }

  @override
  String toString() {
    return 'LocalAtendimentoModel(nome: $nome, contexto: $contexto, cidade: $cidade)';
  }
}
