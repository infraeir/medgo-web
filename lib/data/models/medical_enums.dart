/// Modelo para representar um item de enum médico
class MedicalEnumItem {
  final String code;
  final String display;

  const MedicalEnumItem({
    required this.code,
    required this.display,
  });

  factory MedicalEnumItem.fromJson(Map<String, dynamic> json) {
    return MedicalEnumItem(
      code: json['code'] as String,
      display: json['display'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'display': display,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MedicalEnumItem &&
        other.code == code &&
        other.display == display;
  }

  @override
  int get hashCode => code.hashCode ^ display.hashCode;

  @override
  String toString() => 'MedicalEnumItem(code: $code, display: $display)';
}

/// Enumeração dos tipos de dados médicos disponíveis
enum MedicalEnumType {
  administrationTypes,
  drugAdministrationRoutes,
  bases,
  ucumUnits,
  dispensationUnits,
}

/// Classe para gerenciar todos os enums médicos
class MedicalEnums {
  // Mapas estáticos para acesso rápido por código
  static final Map<String, MedicalEnumItem> _administrationTypesMap = {};
  static final Map<String, MedicalEnumItem> _drugAdministrationRoutesMap = {};
  static final Map<String, MedicalEnumItem> _basesMap = {};
  static final Map<String, MedicalEnumItem> _ucumUnitsMap = {};
  static final Map<String, MedicalEnumItem> _dispensationUnitsMap = {};

  // Listas completas para exibição
  static final List<MedicalEnumItem> _administrationTypes = [];
  static final List<MedicalEnumItem> _drugAdministrationRoutes = [];
  static final List<MedicalEnumItem> _bases = [];
  static final List<MedicalEnumItem> _ucumUnits = [];
  static final List<MedicalEnumItem> _dispensationUnits = [];

  static bool _isInitialized = false;
  static bool _isInitializing = false;

  /// Inicializa todos os dados médicos de forma assíncrona
  static Future<void> initializeAsync() async {
    if (_isInitialized || _isInitializing) return;

    _isInitializing = true;

    // Usar microtasks para não bloquear a UI
    await Future.microtask(() => _initializeAdministrationTypes());
    await Future.microtask(() => _initializeDrugAdministrationRoutes());
    await Future.microtask(() => _initializeBases());
    await Future.microtask(() => _initializeUcumUnits());
    await Future.microtask(() => _initializeDispensationUnits());

    _isInitialized = true;
    _isInitializing = false;
  }

  /// Inicializa todos os dados médicos (versão síncrona para compatibilidade)
  static void initialize() {
    if (_isInitialized) return;

    _initializeAdministrationTypes();
    _initializeDrugAdministrationRoutes();
    _initializeBases();
    _initializeUcumUnits();
    _initializeDispensationUnits();

    _isInitialized = true;
  }

  static void _initializeAdministrationTypes() {
    const data = [
      {"code": "local", "display": "Local"},
      {"code": "oral", "display": "Oral"},
      {"code": "other", "display": "Outro"},
      {"code": "parenteral", "display": "Parenteral"},
      {"code": "respiratory", "display": "Respiratória"},
    ];

    _administrationTypes.clear();
    _administrationTypesMap.clear();

    for (final item in data) {
      final enumItem = MedicalEnumItem.fromJson(item);
      _administrationTypes.add(enumItem);
      _administrationTypesMap[enumItem.code.toLowerCase()] = enumItem;
    }
  }

  static void _initializeDrugAdministrationRoutes() {
    const data = [
      {"code": "oral", "display": "Oral"},
      {"code": "bucal", "display": "Bucal"},
      {"code": "sublingual", "display": "Sublingual"},
      {"code": "nasal", "display": "Nasal"},
      {"code": "otological", "display": "Otológica"},
      {"code": "ophthalmic", "display": "Oftálmica"},
      {"code": "vaginal", "display": "Vaginal"},
      {"code": "rectal", "display": "Retal"},
      {"code": "topical", "display": "Tópica"},
      {"code": "transdermal", "display": "Transdérmica"},
      {"code": "subcutaneous", "display": "Subcutânea"},
      {"code": "intramuscular", "display": "Intramuscular"},
      {"code": "intravenous", "display": "Intravenosa"},
      {"code": "intraosseous", "display": "Intraóssea"},
      {"code": "inhalation", "display": "Inalatória"},
      {"code": "epidural", "display": "Epidural"},
      {"code": "intrathecal", "display": "Intratecal"},
      {"code": "intraarticular", "display": "Intra-articular"},
      {"code": "intradermal", "display": "Intradérmica"},
      {"code": "other", "display": "Outro"},
    ];

    _drugAdministrationRoutes.clear();
    _drugAdministrationRoutesMap.clear();

    for (final item in data) {
      final enumItem = MedicalEnumItem.fromJson(item);
      _drugAdministrationRoutes.add(enumItem);
      _drugAdministrationRoutesMap[enumItem.code.toLowerCase()] = enumItem;
    }
  }

  static void _initializeBases() {
    const data = [
      {"code": "sticker", "display": "Adesivo"},
      {"code": "aerosol", "display": "Aerossol"},
      {"code": "capsule", "display": "Cápsula"},
      {"code": "eye_drops", "display": "Colírio"},
      {"code": "tablet", "display": "Comprimido"},
      {"code": "sublingual_tablet", "display": "Comprimido sublingual"},
      {"code": "cream", "display": "Creme"},
      {"code": "injectable_emulsion", "display": "Emulsão injetável"},
      {"code": "medicinal_gas", "display": "Gás medicinal"},
      {"code": "gel", "display": "Gel"},
      {"code": "chewing_gum", "display": "Goma de mascar"},
      {"code": "granule", "display": "Granulado"},
      {"code": "ovule", "display": "Óvulo"},
      {"code": "lozenge", "display": "Pastilha"},
      {"code": "paste", "display": "Pasta"},
      {"code": "powder", "display": "Pó"},
      {
        "code": "lyophilized_powder_for_reconstitution",
        "display": "Pó liofilizado para reconstituição"
      },
      {"code": "ointment", "display": "Pomada"},
      {"code": "rectal_ointment", "display": "Pomada retal"},
      {"code": "oral_solution", "display": "Solução oral"},
      {"code": "drops", "display": "Gota"},
      {
        "code": "injectable_solution_or_infusion",
        "display": "Solução injetável ou infusão"
      },
      {"code": "nasal_solution", "display": "Solução nasal"},
      {"code": "otological_solution", "display": "Solução otológica"},
      {"code": "spray", "display": "Spray"},
      {"code": "suppository", "display": "Supositório"},
      {"code": "vaginal_suppository", "display": "Supositório vaginal"},
      {"code": "oral_suspension", "display": "Suspensão oral"},
      {"code": "injectable_suspension", "display": "Suspensão injetável"},
      {"code": "syrup", "display": "Xarope"},
    ];

    _bases.clear();
    _basesMap.clear();

    for (final item in data) {
      final enumItem = MedicalEnumItem.fromJson(item);
      _bases.add(enumItem);
      _basesMap[enumItem.code.toLowerCase()] = enumItem;
    }
  }

  static void _initializeUcumUnits() {
    const data = [
      {"code": "g", "display": "g"},
      {"code": "mg", "display": "mg"},
      {"code": "ug", "display": "mcg"},
      {"code": "[IU]", "display": "UI"},
      {"code": "mg/mL", "display": "mg/mL"},
      {"code": "ug/mL", "display": "mcg/mL"},
      {"code": "[IU]/mL", "display": "UI/mL"},
      {"code": "mg/g", "display": "mg/g"},
      {"code": "ug/g", "display": "mcg/g"},
      {"code": "mg/[drp]", "display": "mg/gota"},
      {"code": "ug/[drp]", "display": "mcg/gota"},
      {"code": "[IU]/[drp]", "display": "UI/gota"},
      {"code": "mg/{actuation}", "display": "mg/jato"},
      {"code": "ug/{actuation}", "display": "mcg/jato"},
      {"code": "ug/h", "display": "mcg/h"},
      {"code": "mg/24.h", "display": "mg/24h"},
      {"code": "%", "display": "%"},
    ];

    _ucumUnits.clear();
    _ucumUnitsMap.clear();

    for (final item in data) {
      final enumItem = MedicalEnumItem.fromJson(item);
      _ucumUnits.add(enumItem);
      _ucumUnitsMap[enumItem.code.toLowerCase()] = enumItem;
    }
  }

  static void _initializeDispensationUnits() {
    const data = [
      {"code": "ADESIVO", "display": "Adesivo"},
      {"code": "AMPOLA", "display": "Ampola"},
      {"code": "BISNAGA", "display": "Bisnaga"},
      {"code": "BOLSA", "display": "Bolsa"},
      {"code": "CAIXA", "display": "Caixa"},
      {"code": "CILINDRO", "display": "Cilindro"},
      {"code": "CAPSULA", "display": "Cápsula"},
      {"code": "COMPRIMIDO", "display": "Comprimido"},
      {"code": "FRASCO", "display": "Frasco"},
      {"code": "FRASCO_AMPOLA", "display": "Frasco-ampola"},
      {"code": "FRASCO_GOTEJADOR", "display": "Frasco gotejador"},
      {"code": "FRASCO_SPRAY", "display": "Frasco spray"},
      {"code": "GOMA", "display": "Goma"},
      {"code": "INALADOR", "display": "Inalador"},
      {"code": "OVULO", "display": "Óvulo"},
      {"code": "PASTILHA", "display": "Pastilha"},
      {"code": "SACHE", "display": "Sachê"},
      {"code": "SERINGA", "display": "Seringa preenchida"},
      {"code": "SUPOSITORIO", "display": "Supositório"},
      {"code": "TUBO", "display": "Tubo"},
    ];

    _dispensationUnits.clear();
    _dispensationUnitsMap.clear();

    for (final item in data) {
      final enumItem = MedicalEnumItem.fromJson(item);
      _dispensationUnits.add(enumItem);
      _dispensationUnitsMap[enumItem.code.toLowerCase()] = enumItem;
    }
  }

  // Métodos para buscar por código (case-insensitive)

  /// Busca um tipo de administração por código
  static MedicalEnumItem? getAdministrationType(String code) {
    if (!_isInitialized && !_isInitializing) initialize();
    return _administrationTypesMap[code.toLowerCase()];
  }

  /// Busca uma rota de administração de medicamento por código
  static MedicalEnumItem? getDrugAdministrationRoute(String code) {
    if (!_isInitialized && !_isInitializing) initialize();
    return _drugAdministrationRoutesMap[code.toLowerCase()];
  }

  /// Busca uma base por código
  static MedicalEnumItem? getBase(String code) {
    if (!_isInitialized && !_isInitializing) initialize();
    return _basesMap[code.toLowerCase()];
  }

  /// Busca uma unidade UCUM por código
  static MedicalEnumItem? getUcumUnit(String code) {
    if (!_isInitialized && !_isInitializing) initialize();
    return _ucumUnitsMap[code.toLowerCase()];
  }

  /// Busca uma unidade de dispensação por código
  static MedicalEnumItem? getDispensationUnit(String code) {
    initialize();
    return _dispensationUnitsMap[code.toLowerCase()];
  }

  // Métodos para obter listas completas

  /// Obtém todos os tipos de administração
  static List<MedicalEnumItem> get administrationTypes {
    initialize();
    return List.unmodifiable(_administrationTypes);
  }

  /// Obtém todas as rotas de administração de medicamentos
  static List<MedicalEnumItem> get drugAdministrationRoutes {
    initialize();
    return List.unmodifiable(_drugAdministrationRoutes);
  }

  /// Obtém todas as bases
  static List<MedicalEnumItem> get bases {
    initialize();
    return List.unmodifiable(_bases);
  }

  /// Obtém todas as unidades UCUM
  static List<MedicalEnumItem> get ucumUnits {
    initialize();
    return List.unmodifiable(_ucumUnits);
  }

  /// Obtém todas as unidades de dispensação
  static List<MedicalEnumItem> get dispensationUnits {
    initialize();
    return List.unmodifiable(_dispensationUnits);
  }

  // Métodos utilitários

  /// Busca múltiplos itens por códigos
  static List<MedicalEnumItem> getAdministrationRoutes(List<String> codes) {
    initialize();
    return codes
        .map((code) => getDrugAdministrationRoute(code))
        .where((item) => item != null)
        .cast<MedicalEnumItem>()
        .toList();
  }

  /// Busca um item em qualquer categoria por código
  static MedicalEnumItem? findByCode(String code) {
    initialize();

    return getAdministrationType(code) ??
        getDrugAdministrationRoute(code) ??
        getBase(code) ??
        getUcumUnit(code) ??
        getDispensationUnit(code);
  }

  /// Busca itens por texto no display (busca parcial)
  static List<MedicalEnumItem> searchByDisplay(String query,
      [MedicalEnumType? type]) {
    initialize();

    final queryLower = query.toLowerCase();
    List<MedicalEnumItem> searchList = [];

    if (type == null) {
      // Buscar em todas as categorias
      searchList.addAll(_administrationTypes);
      searchList.addAll(_drugAdministrationRoutes);
      searchList.addAll(_bases);
      searchList.addAll(_ucumUnits);
      searchList.addAll(_dispensationUnits);
    } else {
      // Buscar apenas na categoria especificada
      switch (type) {
        case MedicalEnumType.administrationTypes:
          searchList = _administrationTypes;
          break;
        case MedicalEnumType.drugAdministrationRoutes:
          searchList = _drugAdministrationRoutes;
          break;
        case MedicalEnumType.bases:
          searchList = _bases;
          break;
        case MedicalEnumType.ucumUnits:
          searchList = _ucumUnits;
          break;
        case MedicalEnumType.dispensationUnits:
          searchList = _dispensationUnits;
          break;
      }
    }

    return searchList
        .where((item) => item.display.toLowerCase().contains(queryLower))
        .toList();
  }

  /// Pluraliza unidades corretamente baseado na quantidade
  static String pluralizeUnit(String unit, int quantity) {
    if (quantity == 1) return unit;

    // Regras específicas para unidades médicas
    const Map<String, String> pluralRules = {
      'comprimido': 'comprimidos',
      'cápsula': 'cápsulas',
      'gota': 'gotas',
      'ampola': 'ampolas',
      'frasco': 'frascos',
      'caixa': 'caixas',
      'sachê': 'sachês',
      'supositório': 'supositórios',
      'hora': 'horas',
      'dia': 'dias',
      'semana': 'semanas',
      'mês': 'meses',
      'vez': 'vezes',
    };

    // Verifica se há regra específica
    final pluralRule = pluralRules[unit.toLowerCase()];
    if (pluralRule != null) {
      return pluralRule;
    }

    // Regras gerais de pluralização em português
    final lowerUnit = unit.toLowerCase();
    if (lowerUnit.endsWith('ão')) {
      return unit.replaceAll('ão', 'ões');
    } else if (lowerUnit.endsWith('l')) {
      return unit.replaceAll('l', 'is');
    } else if (lowerUnit.endsWith('m')) {
      return unit.replaceAll('m', 'ns');
    } else if (lowerUnit.endsWith('r') ||
        lowerUnit.endsWith('s') ||
        lowerUnit.endsWith('z')) {
      return '${unit}es';
    } else {
      return '${unit}s';
    }
  }

  /// Traduz formas de aprazamento para português
  static String translateAprazamentoForm(String form) {
    const Map<String, String> translations = {
      'interval': 'Intervalo',
      'times_a_day': 'Vezes ao dia',
      'turning': 'Turno',
      'meals': 'Refeições',
      'schedules': 'Horário',
    };
    return translations[form] ?? form;
  }

  /// Traduz formas de duração para português
  static String translateDurationForm(String form) {
    const Map<String, String> translations = {
      'continuous_use': 'Uso contínuo',
      'immediate_use': 'Uso imediato',
      'per': 'Por',
      'for_until': 'Por até',
      'symptoms': 'Enquanto durarem os sintomas',
    };
    return translations[form] ?? form;
  }

  /// Traduz intervalos específicos para português com pluralização correta
  static String translateInterval(String interval) {
    const Map<String, String> translations = {
      '6_hours': '6 em 6 horas',
      '8_hours': '8 em 8 horas',
      '12_hours': '12 em 12 horas',
      '24_hours': '24 em 24 horas',
      'if_necessary': 'Se necessário',
      '1h': '1 em 1 hora',
      '2h': '2 em 2 horas',
      '3h': '3 em 3 horas',
      '4h': '4 em 4 horas',
      '5h': '5 em 5 horas',
      '6h': '6 em 6 horas',
      '7h': '7 em 7 horas',
      '8h': '8 em 8 horas',
      '9h': '9 em 9 horas',
      '10h': '10 em 10 horas',
      '12h': '12 em 12 horas',
      '24h': '24 em 24 horas',
      'other': 'Outro',
    };
    return translations[interval] ?? interval;
  }

  /// Traduz turnos para português
  static String translateTurn(String turn) {
    const Map<String, String> translations = {
      'morning': 'Manhã',
      'afternoon': 'Tarde',
      'night': 'Noite',
    };
    return translations[turn] ?? turn;
  }

  /// Traduz referências de refeições para português
  static String translateMealReference(String reference) {
    const Map<String, String> translations = {
      'before': 'Antes',
      'during': 'Durante',
      'after': 'Após',
    };
    return translations[reference] ?? reference;
  }

  /// Traduz tipos de refeições para português
  static String translateMealType(String meal) {
    const Map<String, String> translations = {
      'breakfast': 'café da manhã',
      'lunch': 'almoço',
      'dinner': 'jantar',
    };
    return translations[meal] ?? meal;
  }

  /// Retorna a preposição correta para refeições
  static String getMealPreposition(String meal) {
    // Retorna 'do' para todas as refeições
    return 'do';
  }

  /// Traduz unidades de tempo para português
  static String translateTimeUnit(String unit, int quantity) {
    const Map<String, Map<String, String>> translations = {
      'days': {'singular': 'dia', 'plural': 'dias'},
      'hours': {'singular': 'hora', 'plural': 'horas'},
      'weeks': {'singular': 'semana', 'plural': 'semanas'},
      'months': {'singular': 'mês', 'plural': 'meses'},
    };

    final unitTranslations = translations[unit];
    if (unitTranslations == null) return unit;

    return quantity == 1
        ? unitTranslations['singular']!
        : unitTranslations['plural']!;
  }

  /// Traduz dispensationUnit para português baseado no contexto da base
  static String translateDispensationUnit(
      String dispensationUnit, String? baseCode) {
    initialize();

    // Mapeamento de dispensationUnit para português
    final Map<String, String> translations = {
      // Comprimidos/Tablets
      'tablet': 'comprimido',
      'tablets': 'comprimidos',
      'tab': 'comprimido',
      'tabs': 'comprimidos',
      'cp': 'comprimido',
      'cps': 'comprimidos',

      // Caixas/Embalagens
      'box': 'caixa',
      'boxes': 'caixas',
      'package': 'embalagem',
      'packages': 'embalagens',
      'pack': 'embalagem',
      'packs': 'embalagens',

      // Frascos/Bottles
      'bottle': 'frasco',
      'bottles': 'frascos',
      'vial': 'frasco',
      'vials': 'frascos',
      'fl': 'frasco',
      'fls': 'frascos',

      // Cápsulas
      'capsule': 'cápsula',
      'capsules': 'cápsulas',
      'caps': 'cápsulas',
      'cap': 'cápsula',

      // Ampolas
      'ampoule': 'ampola',
      'ampoules': 'ampolas',
      'amp': 'ampola',
      'amps': 'ampolas',
      'ampola': 'ampola',
      'ampolas': 'ampolas',

      // Tubos
      'tube': 'tubo',
      'tubes': 'tubos',
      'tubo': 'tubo',
      'tubos': 'tubos',

      // Sachês
      'sachet': 'sachê',
      'sachets': 'sachês',
      'sache': 'sachê',
      'saches': 'sachês',

      // Seringas
      'syringe': 'seringa',
      'syringes': 'seringas',
      'seringa': 'seringa',
      'seringas': 'seringas',

      // Gotas/Drops
      'drop': 'gota',
      'drops': 'gotas',
      'gota': 'gota',
      'gotas': 'gotas',

      // Mililitros
      'ml': 'ml',
      'mL': 'ml',
      'milliliter': 'ml',
      'milliliters': 'ml',

      // Outras unidades comuns
      'unit': 'unidade',
      'units': 'unidades',
      'piece': 'unidade',
      'pieces': 'unidades',
    };

    // Primeiro tenta tradução direta
    final directTranslation = translations[dispensationUnit.toLowerCase()];
    if (directTranslation != null) {
      return directTranslation;
    }

    // Se não encontrou tradução direta, tenta baseado no contexto da base
    if (baseCode != null) {
      final baseDisplay = getBase(baseCode)?.display.toLowerCase();

      // Mapear baseado no tipo de base
      if (baseDisplay != null) {
        if (baseDisplay.contains('comprimido') ||
            baseDisplay.contains('tablet')) {
          if (dispensationUnit.toLowerCase().contains('box') ||
              dispensationUnit.toLowerCase().contains('caixa')) {
            return 'caixa';
          }
        } else if (baseDisplay.contains('cápsula') ||
            baseDisplay.contains('capsule')) {
          if (dispensationUnit.toLowerCase().contains('box') ||
              dispensationUnit.toLowerCase().contains('caixa')) {
            return 'caixa';
          }
        } else if (baseDisplay.contains('solução') ||
            baseDisplay.contains('solution') ||
            baseDisplay.contains('suspensão') ||
            baseDisplay.contains('suspension')) {
          if (dispensationUnit.toLowerCase().contains('bottle') ||
              dispensationUnit.toLowerCase().contains('frasco')) {
            return 'frasco';
          }
        }
      }
    }

    // Se não conseguiu traduzir, retorna o original
    return dispensationUnit;
  }

  /// Traduz unidades de concentração para português
  static String translateConcentrationUnit(String unit) {
    const Map<String, String> translations = {
      'g': 'g',
      'mg': 'mg',
      'mcg': 'mcg',
      'IU': 'UI',
      'mg_per_mL': 'mg/mL',
      'mcg_per_mL': 'mcg/mL',
      'IU_per_mL': 'UI/mL',
      'mg_per_g': 'mg/g',
      'mcg_per_g': 'mcg/g',
      'mg_per_drop': 'mg/gota',
      'mcg_per_drop': 'mcg/gota',
      'IU_per_drop': 'UI/gota',
      'mg_per_actuation': 'mg/disparo',
      'mcg_per_actuation': 'mcg/disparo',
      'mcg_per_h': 'mcg/h',
      'mg_per_24h': 'mg/24h',
      'percentage': '%',
    };

    return translations[unit] ?? unit;
  }

  /// Traduz unidades de dispensação (MedicationNewDispensationUnit) para português
  static String translateDispensationUnitNew(String unit) {
    const Map<String, String> translations = {
      'drops': 'Gotas',
      'sticker': 'Adesivo',
      'vial': 'frasco',
      'tube': 'Tubo',
      'bag': 'Bolsa',
      'box': 'Caixa',
      'cylinder': 'Cilindro',
      'capsule': 'Cápsula',
      'bottle': 'Frasco',
      'dropper_bottle': 'Frasco com conta-gotas',
      'spray_bottle': 'Frasco spray',
      'chewing_gum': 'Goma de mascar',
      'inhaler': 'Inalador',
      'ovule': 'Óvulo',
      'lozenge': 'Pastilha',
      'sachet': 'Sachê',
      'pre_filled_syringe': 'Seringa pré-preenchida',
      'suppository': 'Supositório',
    };

    return translations[unit.toLowerCase()] ?? unit;
  }
}
