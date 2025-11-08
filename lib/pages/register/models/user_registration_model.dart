class UserRegistrationModel {
  // Dados básicos de cadastro
  final String email;
  final String password;
  final String confirmPassword;
  final String? registerType; // 'Médico' | 'Estudante' | 'Assistente'

  // Dados profissionais
  final String nome;
  final String cpf;
  final String cns;
  final String uf;
  final String registroMedico;
  final String telefone;
  final String? gender; // 'Masculino' | 'Feminino'
  final String? dataNascimento;

  UserRegistrationModel({
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.registerType,
    required this.nome,
    required this.cpf,
    required this.cns,
    required this.uf,
    required this.registroMedico,
    required this.telefone,
    this.gender,
    this.dataNascimento,
  });

  // Construtor para criar um modelo vazio
  UserRegistrationModel.empty()
      : email = '',
        password = '',
        confirmPassword = '',
        registerType = null,
        nome = '',
        cpf = '',
        cns = '',
        uf = '',
        registroMedico = '',
        telefone = '',
        gender = null,
        dataNascimento = null;

  // Método copyWith para imutabilidade
  UserRegistrationModel copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    String? registerType,
    String? nome,
    String? cpf,
    String? cns,
    String? uf,
    String? registroMedico,
    String? telefone,
    String? gender,
    String? dataNascimento,
  }) {
    return UserRegistrationModel(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      registerType: registerType ?? this.registerType,
      nome: nome ?? this.nome,
      cpf: cpf ?? this.cpf,
      cns: cns ?? this.cns,
      uf: uf ?? this.uf,
      registroMedico: registroMedico ?? this.registroMedico,
      telefone: telefone ?? this.telefone,
      gender: gender ?? this.gender,
      dataNascimento: dataNascimento ?? this.dataNascimento,
    );
  }

  // Validações
  bool get isBasicDataValid =>
      email.isNotEmpty &&
      password.isNotEmpty &&
      confirmPassword.isNotEmpty &&
      registerType != null;

  bool get isProfessionalDataValid =>
      nome.isNotEmpty &&
      cpf.isNotEmpty &&
      uf.isNotEmpty &&
      registroMedico.isNotEmpty;

  bool get passwordsMatch => password == confirmPassword;

  bool get isValid =>
      isBasicDataValid && isProfessionalDataValid && passwordsMatch;

  @override
  String toString() {
    return 'UserRegistrationModel(email: $email, nome: $nome, registerType: $registerType)';
  }
}
