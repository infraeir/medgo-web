enum PrescriptionType {
  /// Prescrição sem paciente selecionado
  /// Vai aparecer o ícone de selecionar paciente à esquerda do título 'Prescrição', mas não é obrigatório selecionar para começar a prescrever, a pessoa pode prescrever selecionando medicamentos no select à vontade
  /// Na parte de impressão não precisa aparecer o nome do paciente e nem as informações que ele não tem
  /// Não haverá indicações
  /// Poderá TROCAR e EDITAR o paciente a qualquer momento
  withoutPatient,

  /// Prescrição sem paciente calculadora
  /// Não haverá paciente selecionado e nem terá essa opção
  /// Só haverá indicações, não terá o modal para selecionar medicações
  /// Na parte de impressão não precisa aparecer o nome do paciente e nem as informações que ele não tem
  /// Não poderá TROCAR e EDITAR o paciente pois não vai existir paciente
  withPatientDuringCalculator,

  /// Prescrição com paciente durante uma consulta
  /// Haverá a lista de indicações e o paciente já estará selecionado
  /// Na parte de impressão precisa aparecer o nome do paciente e as informações que ele tem
  /// Poderá EDITAR o paciente, mas não poderá TROCAR o paciente, pois já está vinculada à consulta
  withPatientDuringConsultation,

  /// Prescrição onde é necessário selecionar um paciente
  /// Obrigatoriamente só aparecerá o select/dropdown de medicações após selecionar o paciente (Deve ser criado um select de pacientes com o comportamento do select de medicações)
  /// Não haverá indicações
  /// Poderá TROCAR e EDITAR o paciente
  withoutPatientNeedSelection,

  /// Prescrição com paciente mas fora de uma consulta específica
  /// Ao selecionar o paciente ele já vai abrir com ele selecionado, não haverá indicações
  /// Poderá EDITAR o paciente
  withPatientOutsideConsultation,
}

extension PrescriptionTypeExtension on PrescriptionType {
  bool get hasPatient {
    return this == PrescriptionType.withPatientDuringConsultation ||
        this == PrescriptionType.withPatientOutsideConsultation;
  }

  bool get isDuringConsultation {
    return this == PrescriptionType.withPatientDuringConsultation;
  }

  bool get needsPatientSelection {
    return this == PrescriptionType.withoutPatient;
  }

  bool get isWithoutPatient {
    return this == PrescriptionType.withoutPatient ||
        this == PrescriptionType.withoutPatientNeedSelection;
  }
}
