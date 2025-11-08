import 'package:flutter/material.dart';
import 'package:medgo/pages/register/models/user_registration_model.dart';
import 'package:medgo/pages/register/models/local_atendimento_model.dart';

class RegisterController extends ChangeNotifier {
  // Models de dados
  UserRegistrationModel _userData = UserRegistrationModel.empty();
  UserRegistrationModel get userData => _userData;

  List<LocalAtendimentoModel> _locaisAtendimento = [];
  List<LocalAtendimentoModel> get locaisAtendimento => _locaisAtendimento;

  // Controllers de texto - Dados básicos
  final TextEditingController _accessCodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Controllers de texto - Dados profissionais
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _cnsController = TextEditingController();
  final TextEditingController _ufController = TextEditingController();
  final TextEditingController _registroMedicoController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Getters para os controllers
  TextEditingController get accessCodeController => _accessCodeController;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get confirmPasswordController =>
      _confirmPasswordController;
  TextEditingController get nameController => _nameController;
  TextEditingController get cpfController => _cpfController;
  TextEditingController get cnsController => _cnsController;
  TextEditingController get ufController => _ufController;
  TextEditingController get registroMedicoController =>
      _registroMedicoController;
  TextEditingController get phoneController => _phoneController;

  // Estado dos locais de atendimento
  bool _showNovoLocalForm = false;
  bool get showNovoLocalForm => _showNovoLocalForm;

  int? _editingLocalIndex;
  int? get editingLocalIndex => _editingLocalIndex;

  // Controllers para os formulários de locais de atendimento
  Map<String, Map<String, TextEditingController>> _formControllers = {};
  Map<String, TextEditingController> getFormControllers(String formKey) {
    return _formControllers[formKey] ?? {};
  }

  // Contexto temporário do formulário sendo editado
  Map<String, String?> _tempContextos = {};
  String? getTempContext(String formKey) => _tempContextos[formKey];

  @override
  void dispose() {
    // Dispose dos controllers principais
    _accessCodeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _cpfController.dispose();
    _cnsController.dispose();
    _ufController.dispose();
    _registroMedicoController.dispose();
    _phoneController.dispose();

    // Dispose dos controllers dos formulários de locais
    for (var controllers in _formControllers.values) {
      for (var controller in controllers.values) {
        controller.dispose();
      }
    }

    super.dispose();
  }

  // Métodos de atualização dos dados básicos
  void updateEmail(String email) {
    _userData = _userData.copyWith(email: email);
    notifyListeners();
  }

  void updatePassword(String password) {
    _userData = _userData.copyWith(password: password);
    notifyListeners();
  }

  void updateConfirmPassword(String confirmPassword) {
    _userData = _userData.copyWith(confirmPassword: confirmPassword);
    notifyListeners();
  }

  void updateRegisterType(String? registerType) {
    _userData = _userData.copyWith(registerType: registerType);
    notifyListeners();
  }

  // Métodos de atualização dos dados profissionais
  void updateName(String name) {
    _userData = _userData.copyWith(nome: name);
    notifyListeners();
  }

  void updateCpf(String cpf) {
    _userData = _userData.copyWith(cpf: cpf);
    notifyListeners();
  }

  void updateCns(String cns) {
    _userData = _userData.copyWith(cns: cns);
    notifyListeners();
  }

  void updateUf(String uf) {
    _userData = _userData.copyWith(uf: uf);
    notifyListeners();
  }

  void updateRegistroMedico(String registroMedico) {
    _userData = _userData.copyWith(registroMedico: registroMedico);
    notifyListeners();
  }

  void updatePhone(String phone) {
    _userData = _userData.copyWith(telefone: phone);
    notifyListeners();
  }

  void updateGender(String? gender) {
    _userData = _userData.copyWith(gender: gender);
    notifyListeners();
  }

  // Métodos para gerenciar locais de atendimento
  void showNewLocalForm() {
    _showNovoLocalForm = true;
    _editingLocalIndex = null;
    _tempContextos['new'] = null;
    _initializeFormControllers('new', null);
    notifyListeners();
  }

  void hideNewLocalForm() {
    _showNovoLocalForm = false;
    _clearFormControllers('new');
    notifyListeners();
  }

  void editLocal(int index) {
    _editingLocalIndex = index;
    _showNovoLocalForm = false;
    final formKey = 'edit_$index';
    _tempContextos[formKey] = _locaisAtendimento[index].contexto;
    _initializeFormControllers(formKey, _locaisAtendimento[index].toMap());
    notifyListeners();
  }

  void cancelEditLocal(int index) {
    _editingLocalIndex = null;
    final formKey = 'edit_$index';
    _tempContextos.remove(formKey);
    _clearFormControllers(formKey);
    notifyListeners();
  }

  void deleteLocal(int index) {
    _locaisAtendimento.removeAt(index);
    if (_editingLocalIndex == index) {
      _editingLocalIndex = null;
    }
    notifyListeners();
  }

  void updateTempContext(String formKey, String? context) {
    _tempContextos[formKey] = context;
    notifyListeners();
  }

  void _initializeFormControllers(
      String formKey, Map<String, dynamic>? localData) {
    if (!_formControllers.containsKey(formKey)) {
      _formControllers[formKey] = {
        'nome': TextEditingController(text: localData?['nome'] ?? ''),
        'cnes': TextEditingController(text: localData?['cnes'] ?? ''),
        'cep': TextEditingController(text: localData?['cep'] ?? ''),
        'logradouro':
            TextEditingController(text: localData?['logradouro'] ?? ''),
        'numero': TextEditingController(text: localData?['numero'] ?? ''),
        'uf': TextEditingController(text: localData?['uf'] ?? ''),
        'complemento':
            TextEditingController(text: localData?['complemento'] ?? ''),
        'bairro': TextEditingController(text: localData?['bairro'] ?? ''),
        'cidade': TextEditingController(text: localData?['cidade'] ?? ''),
        'telefone': TextEditingController(text: localData?['telefone'] ?? ''),
        'email': TextEditingController(text: localData?['email'] ?? ''),
      };
    }
  }

  void _clearFormControllers(String formKey) {
    if (_formControllers.containsKey(formKey)) {
      for (var controller in _formControllers[formKey]!.values) {
        controller.dispose();
      }
      _formControllers.remove(formKey);
    }
  }

  // Salvar local de atendimento
  bool saveLocal(String formKey, int? index) {
    final controllers = _formControllers[formKey];
    final selectedContext = _tempContextos[formKey];

    if (controllers == null || selectedContext == null) return false;

    // Validação básica
    if (controllers['nome']!.text.isEmpty ||
        selectedContext.isEmpty ||
        controllers['cep']!.text.isEmpty) {
      return false;
    }

    final localData = LocalAtendimentoModel(
      nome: controllers['nome']!.text,
      cnes: controllers['cnes']!.text,
      contexto: selectedContext,
      cep: controllers['cep']!.text,
      logradouro: controllers['logradouro']!.text,
      numero: controllers['numero']!.text,
      uf: controllers['uf']!.text,
      complemento: controllers['complemento']!.text,
      bairro: controllers['bairro']!.text,
      cidade: controllers['cidade']!.text,
      telefone: controllers['telefone']!.text,
      email: controllers['email']!.text,
    );

    if (index != null) {
      // Atualizando local existente
      _locaisAtendimento[index] = localData;
      _editingLocalIndex = null;
    } else {
      // Adicionando novo local
      _locaisAtendimento.add(localData);
      _showNovoLocalForm = false;
    }

    _tempContextos.remove(formKey);
    // Usar callback para limpar controllers após o frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clearFormControllers(formKey);
    });

    notifyListeners();
    return true;
  }

  // Validação geral do formulário
  bool validateBasicData() {
    return _userData.isBasicDataValid;
  }

  bool validateProfessionalData() {
    return _userData.isProfessionalDataValid;
  }

  bool validatePasswords() {
    return _userData.passwordsMatch;
  }

  bool isFormValid() {
    return _userData.isValid && _locaisAtendimento.isNotEmpty;
  }

  // Método para submeter o registro
  void submitRegistration() {
    if (isFormValid()) {
      // TODO: Implementar lógica de submissão
      print('Dados do usuário: $_userData');
      print('Locais de atendimento: $_locaisAtendimento');
    }
  }
}
