import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:medgo/data/blocs/medication/medication_bloc.dart';
import 'package:medgo/data/blocs/medication/medication_event.dart';
import 'package:medgo/data/blocs/medication/medication_state.dart';
import 'package:medgo/data/models/medication_model.dart';
import 'package:medgo/widgets/news_widgets/search_select.dart';
import 'package:medgo/widgets/news_widgets/multi_select_chip.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SelectMedicationMedGo extends StatefulWidget {
  final MedicationModel? selectedMedication;
  final Function(MedicationModel?) onChanged;
  final String hintText;
  final bool enabled;
  final String? errorText;
  final double maxHeight;

  const SelectMedicationMedGo({
    super.key,
    this.selectedMedication,
    required this.onChanged,
    this.hintText = 'Procurar...',
    this.enabled = true,
    this.errorText,
    this.maxHeight = 300.0,
  });

  @override
  State<SelectMedicationMedGo> createState() => _SelectMedicationMedGoState();
}

class _SelectMedicationMedGoState extends State<SelectMedicationMedGo> {
  late final MedicationBloc _medicationBloc;
  List<MedicationModel> _loadedMedications = [];
  String _lastSearch = '';
  List<String> _selectedFilterIds = [];
  int _currentPage = 1;
  bool _hasNextPage = false;
  bool _isLoadingMore = false;
  Timer? _debounceTimer; // Timer para debounce
  final GlobalKey _chipsKey = GlobalKey(); // Key para os chips

  final List<Map<String, String>> _filterOptions = const [
    {'id': 'generic', 'title': 'Genérico'},
    {'id': 'ref', 'title': 'Referência'},
    {'id': 'similar', 'title': 'Similar'},
    {'id': 'sus', 'title': 'SUS'},
    {'id': 'farmacia_popular', 'title': 'Farmácia Popular'},
  ];

  @override
  void initState() {
    super.initState();
    _medicationBloc = GetIt.I<MedicationBloc>();
    _listenToBloc();
    // NÃO carrega nada inicialmente - usuário deve digitar 3+ caracteres
  }

  void _listenToBloc() {
    _medicationBloc.stream.listen((state) {
      if (state is MedicationsLoaded) {
        print(
            '✅ BLoC: MedicationsLoaded com ${state.medications.medications.length} itens');
        if (mounted) {
          setState(() {
            // Atualiza a lista com os novos dados da API
            _loadedMedications = state.medications.medications;
            _currentPage = state.medications.page;
            _hasNextPage = state.medications.hasNextPage;
            _isLoadingMore = false;
          });
        }
      } else if (state is MedicationsLoadingMore) {
        if (mounted) {
          setState(() {
            _isLoadingMore = true;
          });
        }
      } else if (state is MedicationsLoading) {
        print('⏳ BLoC: MedicationsLoading');
        // Não limpa a lista durante loading inicial - evita RangeError
        if (mounted) {
          setState(() {
            _isLoadingMore = false;
          });
        }
      } else if (state is MedicationsError) {
        print('BLoC: MedicationsError - ${state.e}');
        if (mounted) {
          setState(() {
            _isLoadingMore = false;
          });
        }
      }
    });
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();

    // Se a query está vazia, limpa a lista imediatamente
    if (query.isEmpty) {
      if (mounted) {
        setState(() {
          _loadedMedications = [];
          _lastSearch = '';
          _currentPage = 1;
          _hasNextPage = false;
        });
      }
      return;
    }

    // Se tem menos de 3 caracteres, não busca
    if (query.length < 3) {
      return;
    }

    // Agenda busca após 500ms (debounce)
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (_lastSearch != query) {
        _lastSearch = query;
        _applyFilters();
      }
    });
  }

  void _loadMoreData() {
    if (_isLoadingMore || !_hasNextPage) return;

    // Reconstrói os filtros para a próxima página
    List<String> typeFilters = [];
    bool? susFilter;
    bool? popularPharmacyFilter;

    for (String id in _selectedFilterIds) {
      if (id == 'sus') {
        susFilter = true;
      } else if (id == 'farmacia_popular') {
        popularPharmacyFilter = true;
      } else {
        typeFilters.add(id);
      }
    }

    // Tokens = texto digitado
    List<String>? tokens;

    if (_lastSearch.isNotEmpty) {
      if (_lastSearch.contains('+')) {
        // Separa por '+' em múltiplos tokens
        tokens = _lastSearch
            .split('+')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      } else {
        // Token único = texto digitado
        tokens = [_lastSearch.trim()];
      }
    }

    _medicationBloc.add(LoadMoreDataMedication(
      currentPage: _currentPage + 1,
      search: '', // Vazio quando usa tokens
      loadedMedications: _loadedMedications,
      types: typeFilters.isEmpty ? null : typeFilters,
      tokens: tokens,
      sus: susFilter,
      popularPharmacy: popularPharmacyFilter,
    ));
  }

  void _applyFilters() {
    // Separa os filtros de tipo e SUS/Farmácia Popular
    List<String> typeFilters = [];
    bool? susFilter;
    bool? popularPharmacyFilter;

    for (String id in _selectedFilterIds) {
      if (id == 'sus') {
        susFilter = true;
      } else if (id == 'farmacia_popular') {
        popularPharmacyFilter = true;
      } else {
        // gen, ref, sim
        typeFilters.add(id);
      }
    }

    // Tokens = texto digitado
    // Se tiver '+', separa em múltiplos tokens
    List<String>? tokens;

    if (_lastSearch.isNotEmpty) {
      if (_lastSearch.contains('+')) {
        // Separa por '+' em múltiplos tokens
        tokens = _lastSearch
            .split('+')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      } else {
        // Token único = texto digitado
        tokens = [_lastSearch.trim()];
      }
    }

    _medicationBloc.add(GetMedications(
      loadedMedications: [],
      types: typeFilters.isEmpty ? null : typeFilters,
      tokens: tokens,
      sus: susFilter,
      popularPharmacy: popularPharmacyFilter,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filtros Multi Select Chip - com Key para detectar cliques
        Padding(
          key: _chipsKey,
          padding: const EdgeInsets.only(left: 8.0),
          child: MultiSelectChipMedgo(
            items: _filterOptions,
            selectedIds: _selectedFilterIds,
            onSelectionChanged: (selectedIds) {
              setState(() {
                _selectedFilterIds = selectedIds;
              });
              // Recarrega a lista com os filtros aplicados
              _applyFilters();
            },
            spacing: 8.0,
          ),
        ),
        const SizedBox(height: 4),
        // Campo de busca com dropdown de medicamentos
        BlocBuilder<MedicationBloc, MedicationsState>(
          bloc: _medicationBloc,
          buildWhen: (previous, current) {
            // Só reconstrói quando necessário
            return current is MedicationsLoaded ||
                current is MedicationsLoading ||
                current is MedicationsError;
          },
          builder: (context, state) {
            return SearchSelectMedgo<MedicationModel>(
              items: _loadedMedications,
              itemLabel: (item) => item.displayName,
              itemType: (item) => item.type,
              availableInPopularPharmacy: (item) =>
                  item.availableInPopularPharmacy,
              availableInSUS: (item) => item.availableInSUS,
              selectedItem: widget.selectedMedication,
              onChanged: widget.onChanged,
              hintText: 'Procurar',
              enabled: widget.enabled,
              maxHeight: widget.maxHeight,
              // Passa a key dos chips para o SearchSelect
              excludeFromCloseTap: _chipsKey,
              // Configuração de paginação
              isPaginated: true,
              hasNextPage: _hasNextPage,
              isLoadingMore: _isLoadingMore,
              onLoadMore: _loadMoreData,
              onSearchChanged: _onSearchChanged,
              floatingButtonTitle: 'Cadastrar nova medicação',
              floatingButtonIcon: Icon(
                size: 18.0,
                PhosphorIcons.plusCircle(
                  PhosphorIconsStyle.bold,
                ),
              ),
              onFloatingButtonTap: () {},
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel(); // Cancela timer ao desmontar
    super.dispose();
  }
}
