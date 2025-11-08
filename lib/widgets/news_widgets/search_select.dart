// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/search_input.dart';
import 'package:medgo/widgets/news_widgets/buttons/primary_icon_button.dart';
import 'package:medgo/widgets/scrollbar/custom_scroll_bar.dart';

class SearchSelectMedgo<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) itemLabel;
  final String Function(T)? itemType;
  final bool Function(T)? availableInSUS;
  final bool Function(T)? availableInPopularPharmacy;
  final T? selectedItem;
  final Function(T?) onChanged;
  final String hintText;
  final bool enabled;
  final String? errorText;
  final double maxHeight;

  // Parâmetros do botão flutuante opcional
  final String? floatingButtonTitle;
  final Icon? floatingButtonIcon;
  final VoidCallback? onFloatingButtonTap;

  // Parâmetros para paginação
  final bool isPaginated;
  final bool hasNextPage;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;
  final Function(String)? onSearchChanged;

  // Key de widget que não deve fechar o dropdown ao clicar
  final GlobalKey? excludeFromCloseTap;

  const SearchSelectMedgo({
    super.key,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.itemType,
    this.availableInPopularPharmacy,
    this.availableInSUS,
    this.selectedItem,
    this.hintText = 'Buscar...',
    this.enabled = true,
    this.errorText,
    this.maxHeight = 230.0,
    this.floatingButtonTitle,
    this.floatingButtonIcon,
    this.onFloatingButtonTap,
    this.isPaginated = false,
    this.hasNextPage = false,
    this.isLoadingMore = false,
    this.onLoadMore,
    this.onSearchChanged,
    this.excludeFromCloseTap,
  });

  @override
  State<SearchSelectMedgo<T>> createState() => _SearchSelectMedgoState<T>();
}

class _SearchSelectMedgoState<T> extends State<SearchSelectMedgo<T>> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  final ScrollController _scrollController = ScrollController();
  OverlayEntry? _overlayEntry;
  List<T> _filteredItems = [];
  bool _isOpen = false;
  bool _canScrollDown = false;
  String _currentQuery = ''; // Armazena a query atual para highlighting

  @override
  void initState() {
    super.initState();

    // Se for paginado, não filtra localmente - usa os itens vindos do backend
    if (widget.isPaginated) {
      _filteredItems = widget.items;
    } else {
      _filteredItems = widget.items;
    }

    if (widget.selectedItem != null) {
      _searchController.text = widget.itemLabel(widget.selectedItem as T);
    }

    _focusNode.addListener(() {
      if (_focusNode.hasFocus && !_isOpen) {
        _openDropdown();
      }
    });

    // Se for paginado e tem callback de busca, usa ele ao invés de filtrar localmente
    if (widget.isPaginated && widget.onSearchChanged != null) {
      _searchController.addListener(() {
        final query = _searchController.text.toLowerCase();
        if (_currentQuery != query) {
          setState(() {
            _currentQuery = query;
          });

          // Atualiza o overlay APÓS o build quando a query muda
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _isOpen) {
              _updateOverlay();
            }
          });

          widget.onSearchChanged!(_searchController.text);
        }
      });
    } else {
      _searchController.addListener(_filterItems);
    }

    _scrollController.addListener(_updateScrollState);
  }

  void _updateScrollState() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    final canScrollDown = position.pixels < position.maxScrollExtent - 10;

    if (_canScrollDown != canScrollDown) {
      setState(() {
        _canScrollDown = canScrollDown;
      });
      _updateOverlay();
    }

    // Se for paginado e tem mais páginas, carrega quando chegar perto do fim
    if (widget.isPaginated &&
        widget.hasNextPage &&
        !widget.isLoadingMore &&
        widget.onLoadMore != null &&
        _filteredItems.isNotEmpty) {
      // Carrega quando estiver próximo ao final (85% do scroll)
      final scrollPercentage = position.pixels / position.maxScrollExtent;
      if (scrollPercentage >= 0.85) {
        widget.onLoadMore!();
      }
    }
  }

  @override
  void didUpdateWidget(SearchSelectMedgo<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // SEMPRE atualiza _filteredItems quando items mudar, mas com proteção
    if (oldWidget.items != widget.items) {
      print(
          '🔄 SearchSelect: Items mudaram de ${oldWidget.items.length} para ${widget.items.length}');

      // Verifica se o widget ainda está montado antes de setState
      if (mounted) {
        setState(() {
          _filteredItems = widget.items;
        });

        // FORÇA reconstrução do overlay com os novos dados - APÓS o build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            try {
              if (_isOpen) {
                print('🔄 SearchSelect: Overlay está aberto, forçando rebuild');
                _updateOverlay();
              } else {
                print(
                    '⚠️ SearchSelect: Overlay está FECHADO, dados não serão visíveis');
              }

              if (_scrollController.hasClients) {
                _updateScrollState();
              }
            } catch (e) {
              print('❌ SearchSelect: Erro ao atualizar overlay: $e');
              // Em caso de erro, fecha o overlay para evitar estado inconsistente
              if (_isOpen) {
                _closeDropdown();
              }
            }
          }
        });
      }
    }

    if (oldWidget.selectedItem != widget.selectedItem) {
      if (widget.selectedItem != null && mounted) {
        _searchController.text = widget.itemLabel(widget.selectedItem as T);
      } else if (mounted) {
        _searchController.clear();
      }
    }
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();

    // Se for paginado, não filtra localmente - deixa a API fazer o filtro
    if (widget.isPaginated) {
      setState(() {
        _currentQuery = query; // Atualiza apenas para highlighting
      });
      return;
    }

    setState(() {
      _currentQuery = query;
      _filteredItems = widget.items.where((item) {
        return widget.itemLabel(item).toLowerCase().contains(query);
      }).toList();
    });
    _updateOverlay();

    // Atualiza o estado do scroll após a filtragem
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateScrollState();
    });
  }

  void _openDropdown() {
    if (!widget.enabled || _isOpen) return;

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });

    // Atualiza o estado do scroll após abrir o dropdown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateScrollState();
    });
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isOpen = false;
    });
  }

  void _updateOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // GestureDetector para fechar ao clicar fora
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                _closeDropdown();
                _focusNode.unfocus();
              },
            ),
          ),
          // Conteúdo do dropdown (permite interação com widgets internos)
          Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0.0, size.height + 4.0),
              child: Material(
                elevation: 8.0,
                borderRadius: BorderRadius.circular(10),
                shadowColor: Colors.black.withOpacity(0.2),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: widget.maxHeight,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppTheme.primary,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: _filteredItems.isEmpty
                      ? _buildEmptyState(
                          searchEmpty: _searchController.text.trim().length < 3,
                        )
                      : _buildListView(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({required bool searchEmpty}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          searchEmpty
              ? 'Digite pelo menos 3 caracteres para buscar...'
              : 'Nenhum item encontrado',
          style: const TextStyle(
            color: AppTheme.primaryText,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        height: widget.maxHeight,
        child: Stack(
          children: [
            GestureDetector(
              onPanUpdate: (details) {
                // Move o scroll na direção do arrasto (invertido para seguir o mouse)
                final newOffset = _scrollController.offset - details.delta.dy;
                if (newOffset >= 0 &&
                    newOffset <= _scrollController.position.maxScrollExtent) {
                  _scrollController.jumpTo(newOffset);
                }
              },
              child: CustomScrollbar(
                trackMargin: const EdgeInsets.only(
                  bottom: 40,
                ),
                controller: _scrollController,
                child: Builder(builder: (context) {
                  return ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      scrollbars: false,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 20.0,
                        left: 4.0,
                      ),
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(
                          bottom: 38,
                        ),
                        itemCount: _filteredItems.length,
                        itemBuilder: (context, index) {
                          // Proteção contra RangeError
                          if (index >= _filteredItems.length) {
                            return const SizedBox.shrink();
                          }

                          final item = _filteredItems[index];
                          final isSelected = widget.selectedItem == item;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: _SearchSelectItem<T>(
                              index: index,
                              item: item,
                              isSelected: isSelected,
                              itemLabel: widget.itemLabel(item),
                              itemType: widget.itemType != null
                                  ? widget.itemType!(item)
                                  : null,
                              availableInPopularPharmacy:
                                  widget.availableInPopularPharmacy != null
                                      ? widget.availableInPopularPharmacy!(item)
                                      : false,
                              availableInSUS: widget.availableInSUS != null
                                  ? widget.availableInSUS!(item)
                                  : false,
                              searchQuery: _currentQuery,
                              onTap: () {
                                widget.onChanged(item);
                                _searchController.text = widget.itemLabel(item);
                                _closeDropdown();
                                _focusNode.unfocus();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),
              ),
            ),
            // Loading indicator no final da lista (paginação)
            if (widget.isPaginated && widget.isLoadingMore)
              Positioned(
                left: 0,
                right: 0,
                bottom: 40,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.0),
                        Colors.white.withOpacity(0.95),
                      ],
                    ),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: AppTheme.theme.primaryColor,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
              ),
            // Blur gradient - final (bottom)
            if (_canScrollDown)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 15,
                child: IgnorePointer(
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.5),
                              Colors.white.withOpacity(1),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.dstOut,
                      ),
                    ),
                  ),
                ),
              ),
            // Botão flutuante no canto inferior direito (opcional)
            if (widget.floatingButtonTitle != null ||
                widget.floatingButtonIcon != null)
              Positioned(
                right: 2,
                bottom: 1,
                child: PrimaryIconButtonMedGo(
                  title: widget.floatingButtonTitle,
                  rightIcon: widget.floatingButtonIcon,
                  onTap: widget.onFloatingButtonTap ?? () {},
                  size: 12.0,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: () {
          if (!_isOpen && widget.enabled) {
            _focusNode.requestFocus();
          }
        },
        child: SearchInputMedgo(
          controller: _searchController,
          focusNode: _focusNode,
          hintText: widget.hintText,
          enabled: widget.enabled,
          onChanged: (value) {
            // O dropdown já será aberto pelo listener do focusNode
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _closeDropdown();
    _searchController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class _SearchSelectItem<T> extends StatefulWidget {
  final T item;
  final int index;
  final bool isSelected;
  final String itemLabel;
  final String? itemType;
  final bool availableInSUS;
  final bool availableInPopularPharmacy;
  final String searchQuery;
  final VoidCallback onTap;

  const _SearchSelectItem({
    required this.item,
    required this.index,
    required this.isSelected,
    required this.itemLabel,
    required this.availableInPopularPharmacy,
    required this.availableInSUS,
    required this.searchQuery,
    required this.onTap,
    this.itemType,
  });

  @override
  State<_SearchSelectItem<T>> createState() => _SearchSelectItemState<T>();
}

class _SearchSelectItemState<T> extends State<_SearchSelectItem<T>> {
  bool _isHovering = false;
  bool _isPressed = false;

  Color _getBackgroundColor() {
    if (_isPressed) return AppTheme.blueDark;
    if (widget.isSelected) return AppTheme.primary;
    if (_isHovering) return AppTheme.blueLight;
    return AppTheme.info;
  }

  Color _getBorderColor() {
    if (_isPressed) return AppTheme.salmon;
    if (widget.isSelected) return AppTheme.blueLight;
    if (_isHovering) return AppTheme.salmon;
    return AppTheme.primary;
  }

  Color _getTextColor() {
    if (_isPressed) return Colors.white;
    if (widget.isSelected) return Colors.white;
    if (_isHovering) return AppTheme.primaryText;
    return AppTheme.primaryText;
  }

  double _getBorderWidth() {
    if (_isPressed || widget.isSelected) return 2.0;
    return 1.0;
  }

  List<BoxShadow> _getShadow() {
    if (_isPressed) {
      return [
        BoxShadow(
          color: AppTheme.primaryAccent.withOpacity(0.25),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];
    }
    if (_isHovering) {
      return [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ];
    }
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 2,
        offset: const Offset(0, 1),
      ),
    ];
  }

  TextSpan _buildHighlightedText() {
    final text = widget.itemLabel;
    final query = widget.searchQuery;

    if (query.isEmpty) {
      return TextSpan(
        text: text,
        style: TextStyle(
          color: _getTextColor(),
          fontSize: 14,
          fontWeight: widget.isSelected || _isPressed
              ? FontWeight.w700
              : FontWeight.w500,
        ),
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final startIndex = lowerText.indexOf(lowerQuery);

    if (startIndex == -1) {
      return TextSpan(
        text: text,
        style: TextStyle(
          color: _getTextColor(),
          fontSize: 14,
          fontWeight: widget.isSelected || _isPressed
              ? FontWeight.w700
              : FontWeight.w400,
        ),
      );
    }

    final beforeMatch = text.substring(0, startIndex);
    final match = text.substring(startIndex, startIndex + query.length);
    final afterMatch = text.substring(startIndex + query.length);

    return TextSpan(
      children: [
        // Texto antes da match
        if (beforeMatch.isNotEmpty)
          TextSpan(
            text: beforeMatch,
            style: TextStyle(
              color: _getTextColor(),
              fontSize: 14,
              fontWeight: widget.isSelected || _isPressed
                  ? FontWeight.w700
                  : FontWeight.w400,
            ),
          ),
        // Texto que deu match (em negrito)
        TextSpan(
          text: match,
          style: TextStyle(
            color: _getTextColor(),
            fontSize: 14,
            fontWeight: FontWeight.w700, // Sempre bold
          ),
        ),
        // Texto depois da match
        if (afterMatch.isNotEmpty)
          TextSpan(
            text: afterMatch,
            style: TextStyle(
              color: _getTextColor(),
              fontSize: 14,
              fontWeight: widget.isSelected || _isPressed
                  ? FontWeight.w700
                  : FontWeight.w400,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: BoxDecoration(
            color: _getBackgroundColor(),
            border: Border.all(
              color: _getBorderColor(),
              width: _getBorderWidth(),
            ),
            borderRadius: widget.index == 0
                ? const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(2),
                    bottomRight: Radius.circular(2),
                  )
                : BorderRadius.circular(4),
            boxShadow: _getShadow(),
          ),
          child: Row(
            children: [
              if (widget.itemType != null)
                Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child:
                      SvgPicture.asset('assets/icons/${widget.itemType}.svg'),
                ),
              Expanded(
                child: RichText(
                  text: _buildHighlightedText(),
                ),
              ),
              if (widget.availableInSUS)
                Tooltip(
                  message: 'Disponível no SUS',
                  child: SvgPicture.asset(
                    'assets/icons/sus.svg',
                    height: 20,
                    width: 36,
                  ),
                ),
              if (widget.availableInPopularPharmacy)
                Padding(
                  padding: const EdgeInsets.only(left: 3.0),
                  child: Tooltip(
                    message: 'Disponível na Farmácia Popular',
                    child: Image.asset(
                      'assets/icons/popular.png',
                      height: 24,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
