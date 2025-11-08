// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:medgo/data/blocs/calculator/caclulator_bloc.dart';
import 'package:medgo/data/blocs/calculator/calculator_event.dart';
import 'package:medgo/data/blocs/calculator/calculator_state.dart';
import 'package:medgo/data/models/calculators_model.dart';
import 'package:medgo/pages/calculator/calculator_list/calculator_list_binding.dart';
import 'package:medgo/strings/strings.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/buttons/tertiary_icon_button.dart';
import 'package:medgo/widgets/news_widgets/search_input.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CalculatorListPage extends StatefulWidget {
  final Function(List<bool> value) selected;
  const CalculatorListPage({Key? key, required this.selected})
      : super(key: key);

  @override
  State<CalculatorListPage> createState() => _CalculatorListPageState();
}

class _CalculatorListPageState extends State<CalculatorListPage> {
  late final ScrollController _scrollController;
  late CalculatorBloc _calculatorsBloc;
  TextEditingController searchController = TextEditingController();
  List<CalculatorsModel> listCalculators = [];
  int calculatorsLenght = 0;
  int totalPages = 1;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(infiniteScrolling);
    setUpCalculators();
    _calculatorsBloc = GetIt.I<CalculatorBloc>();
    getCalculatorsIniciais();
    _listenEvents();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  infiniteScrolling() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _geNewtCalculators(_currentPage + 1);
      _currentPage++;
    }
  }

  getCalculatorsIniciais() {
    _calculatorsBloc.add(
      GetCalculators(
        loadedCalculators: listCalculators,
        search: searchController.text,
      ),
    );
  }

  _geNewtCalculators(current) {
    if (current <= totalPages) {
      _calculatorsBloc.add(
        LoadMoreData(
          currentPage: current,
          loadedCalculators: listCalculators,
          search: searchController.text,
        ),
      );
    }
  }

  void _listenEvents() {
    _calculatorsBloc.stream.listen((state) {
      if (state is CalculatorsLoaded) {
        setState(() {
          calculatorsLenght = state.calculators.calculators.length;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 210,
            ),
            Text(
              "Selecione uma calculadora.",
              style:
                  AppTheme.p(color: Colors.black, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              width: 228,
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          width: 528,
          child: SearchInputMedgo(
            controller: searchController,
            hintText: Strings.procurarCalculadora,
            enabled: true,
            onChanged: (value) {
              getCalculatorsIniciais();
            },
            iconSize: 20,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Expanded(
          child: BlocBuilder<CalculatorBloc, CalculatorsState>(
            bloc: _calculatorsBloc,
            builder: (context, state) {
              if (state is CalculatorsLoaded || state is CalculatorsLoading) {
                if (state is CalculatorsLoaded) {
                  listCalculators.clear();
                  listCalculators.addAll(state.calculators.calculators);
                  totalPages = state.calculators.totalPages;
                }

                return Padding(
                  padding: const EdgeInsets.only(
                    right: 24,
                    left: 24,
                    bottom: 20,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemCount: listCalculators.length,
                    itemBuilder: (context, index) {
                      final calculator = listCalculators[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                            color: AppTheme.primaryBackground,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      PhosphorIcons.calculator(
                                        PhosphorIconsStyle.bold,
                                      ),
                                      color: AppTheme.textPrimary,
                                      shadows: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 4.0,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      calculator.name,
                                      style: AppTheme.p(
                                        color: AppTheme.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Container(
                                      width: 5,
                                      height: 5,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: AppTheme.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Text(
                                      'Referências:',
                                      style: AppTheme.h5(
                                        color: AppTheme.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (calculator.references.isNotEmpty)
                                      ...calculator.references.map(
                                        (reference) => Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: SvgPicture.asset(
                                            'assets/icons/$reference.svg',
                                            height: 24,
                                            width: 24,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 200,
                              child: TertiaryIconButtonMedGo(
                                onTap: () {
                                  context.go('/calculator/${calculator.type}');
                                },
                                title: Strings.abrir,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              } else if (state is CalculatorsError) {
                return Center(
                    child: Column(
                  children: [
                    const Text("Erro ao carregar calculadoras"),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("Recarregar"),
                    IconButton(
                      onPressed: () {
                        getCalculatorsIniciais();
                      },
                      icon: Icon(Icons.refresh,
                          color: AppTheme.theme.primaryColor),
                    ),
                  ],
                ));
              } else {
                return Center(
                    child: CircularProgressIndicator(
                  color: AppTheme.theme.primaryColor,
                ));
              }
            },
          ),
        )
      ],
    );
  }
}
