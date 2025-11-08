import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:medgo/data/blocs/patients/patients_service_bloc.dart';
import 'package:medgo/data/blocs/patients/patients_service_event.dart';
import 'package:medgo/data/blocs/patients/patients_service_state.dart';
import 'package:medgo/data/models/patients_model.dart';
import 'package:medgo/widgets/news_widgets/search_select.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SelectPatientMedGo extends StatefulWidget {
  final PatientsModel? selectedPatient;
  final Function(PatientsModel?) onChanged;
  final String hintText;
  final bool enabled;
  final String? errorText;
  final double maxHeight;

  const SelectPatientMedGo({
    super.key,
    this.selectedPatient,
    required this.onChanged,
    this.hintText = 'Procurar paciente...',
    this.enabled = true,
    this.errorText,
    this.maxHeight = 300.0,
  });

  @override
  State<SelectPatientMedGo> createState() => _SelectPatientMedGoState();
}

class _SelectPatientMedGoState extends State<SelectPatientMedGo> {
  late final PatientsBloc _patientsBloc;
  List<PatientsModel> _loadedPatients = [];
  String _lastSearch = '';
  int _currentPage = 1;
  bool _hasNextPage = false;
  bool _isLoadingMore = false;
  Timer? _debounceTimer; // Timer para debounce

  @override
  void initState() {
    super.initState();
    _patientsBloc = GetIt.I<PatientsBloc>();
    _listenToBloc();
    // NÃO carrega nada inicialmente - usuário deve digitar 2+ caracteres
  }

  void _listenToBloc() {
    _patientsBloc.stream.listen((state) {
      if (state is PatientsLoaded) {
        print(
            '✅ BLoC: PatientsLoaded com ${state.patients.patients.length} itens');
        if (mounted) {
          setState(() {
            // Atualiza a lista com os novos dados da API
            _loadedPatients = state.patients.patients;
            _currentPage = state.patients.page;
            _hasNextPage = state.patients.page < state.patients.totalPages;
            _isLoadingMore = false;
          });
        }
      } else if (state is PatientsLoadingMore) {
        if (mounted) {
          setState(() {
            _isLoadingMore = true;
          });
        }
      } else if (state is PatientsLoading) {
        print('⏳ BLoC: PatientsLoading');
        // Não limpa a lista durante loading inicial - evita RangeError
        if (mounted) {
          setState(() {
            _isLoadingMore = false;
          });
        }
      } else if (state is PatientsError) {
        print('❌ BLoC: PatientsError - ${state.e}');
        if (mounted) {
          setState(() {
            _isLoadingMore = false;
          });
        }
      }
    });
  }

  void _onSearchChanged(String query) {
    // Cancela o timer anterior se existir
    _debounceTimer?.cancel();

    // Se a query está vazia, limpa a lista imediatamente
    if (query.isEmpty) {
      if (mounted) {
        setState(() {
          _loadedPatients = [];
          _lastSearch = '';
          _currentPage = 1;
          _hasNextPage = false;
        });
      }
      return;
    }

    // Se tem menos de 2 caracteres, não busca
    if (query.length < 2) {
      return;
    }

    // Agenda busca após 500ms (debounce)
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (_lastSearch != query) {
        _lastSearch = query;
        _searchPatients();
      }
    });
  }

  void _searchPatients() {
    _patientsBloc.add(GetPatients(
      loadedPatients: [],
      search: _lastSearch,
    ));
  }

  void _loadMoreData() {
    if (_isLoadingMore || !_hasNextPage) return;

    _patientsBloc.add(LoadMoreData(
      currentPage: _currentPage + 1,
      search: _lastSearch,
      loadedPatients: _loadedPatients,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientsBloc, PatientsState>(
      bloc: _patientsBloc,
      builder: (context, state) {
        return SearchSelectMedgo<PatientsModel>(
          items: _loadedPatients,
          itemLabel: (item) => item.name,
          itemType: (item) => '${item.age} anos',
          availableInPopularPharmacy: (item) => false,
          availableInSUS: (item) => false,
          selectedItem: widget.selectedPatient,
          onChanged: widget.onChanged,
          hintText: widget.hintText,
          enabled: widget.enabled,
          maxHeight: widget.maxHeight,
          // Configuração de paginação
          isPaginated: true,
          hasNextPage: _hasNextPage,
          isLoadingMore: _isLoadingMore,
          onLoadMore: _loadMoreData,
          onSearchChanged: _onSearchChanged,
          floatingButtonIcon: Icon(
            size: 18.0,
            PhosphorIcons.userCirclePlus(
              PhosphorIconsStyle.bold,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel(); // Cancela timer ao desmontar
    super.dispose();
  }
}
