// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/scrollbar/custom_scroll_bar.dart';

class ResponsiveTableExpanded extends StatelessWidget {
  final List<Widget> headerCells;
  final List<TableRowData> bodyRows;
  final String footerText;
  final String title;
  final bool isLoading;
  final bool isEmpty;
  final Widget? emptyStateWidget;
  final List<int> columnFlex;
  final ScrollController? scrollController;

  const ResponsiveTableExpanded({
    Key? key,
    required this.headerCells,
    required this.bodyRows,
    required this.footerText,
    required this.title,
    required this.columnFlex,
    this.isLoading = false,
    this.isEmpty = false,
    this.emptyStateWidget,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return _buildMobileTable();
        } else {
          return _buildDesktopTable();
        }
      },
    );
  }

  Widget _buildDesktopTable() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(
            20,
          ),
        ),
        border: Border.all(color: AppTheme.lightOutline),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        child: Stack(
          children: [
            // Corpo
            if (isLoading)
              Positioned.fill(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: AppTheme.theme.primaryColor,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text('Carregando lista de $title...'),
                    ],
                  ),
                ),
              )
            else if (isEmpty)
              Positioned.fill(
                child: emptyStateWidget ?? _buildEmptyStateContent(),
              )
            else
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: CustomScrollbar(
                    trackMargin: const EdgeInsets.only(
                      top: 38,
                      bottom: 34,
                    ),
                    controller: scrollController,
                    child: Builder(
                      builder: (context) => ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          scrollbars: false,
                        ),
                        child: _buildTableContent(),
                      ),
                    ),
                  ),
                ),
              ),
            // Cabeçalho
            if (!isLoading)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 5,
                        left: 8.0,
                        right: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(1),
                            Colors.white.withOpacity(0.7),
                            Colors.white.withOpacity(0.0),
                          ],
                          stops: const [
                            0.0,
                            0.5,
                            1.0
                          ], // Define os pontos de transição
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 8),
                        decoration: const BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(8)),
                        ),
                        child: Row(
                          children: List.generate(headerCells.length, (index) {
                            return Expanded(
                              flex: columnFlex[index],
                              child: headerCells[index],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            // Rodapé
            if (!isLoading)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 1.5,
                      sigmaY: 1.5,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.white.withOpacity(1),
                            Colors.white.withOpacity(0.7),
                            Colors.white.withOpacity(0.0),
                          ],
                          stops: const [
                            0.0,
                            0.5,
                            1.0
                          ], // Define os pontos de transição
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: const BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(bottom: Radius.circular(8)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              footerText,
                              style: AppTheme.h5(
                                color: AppTheme.secondaryText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableContent() {
    return Builder(
      builder: (context) {
        final effectiveController =
            scrollController ?? PrimaryScrollController.of(context);
        return ListView.builder(
          controller: effectiveController,
          itemCount: bodyRows.length,
          padding: const EdgeInsets.only(
            top: 38,
            bottom: 34,
          ),
          itemBuilder: (context, rowIndex) {
            final row = bodyRows[rowIndex];
            return Column(
              children: [
                Card(
                  color: AppTheme.lightSurfaceBright,
                  margin: const EdgeInsets.only(
                      top: 4, bottom: 4, right: 22, left: 4),
                  child: InkWell(
                    onTap: row.onExpand != null
                        ? () => row.onExpand!(row.id)
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: List.generate(row.cells.length, (cellIndex) {
                          return Expanded(
                            flex: columnFlex[cellIndex],
                            child: row.cells[cellIndex],
                          );
                        }),
                      ),
                    ),
                  ),
                ),
                if (row.isExpanded && row.expandedContent != null)
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 4, bottom: 4, right: 22, left: 12),
                    child: Card(
                      color: AppTheme.lightSurfaceBright,
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: row.expandedContent!,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildMobileTable() {
    return Column(
      children: [
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else if (isEmpty)
          emptyStateWidget ?? _buildEmptyState()
        else
          Expanded(
            child: CustomScrollbar(
              controller: scrollController,
              child: Builder(
                builder: (context) => ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    scrollbars: false,
                  ),
                  child: Builder(
                    builder: (context) {
                      final effectiveController = scrollController ??
                          PrimaryScrollController.of(context);
                      return ListView.builder(
                        controller: effectiveController,
                        itemCount: bodyRows.length,
                        itemBuilder: (context, index) {
                          final row = bodyRows[index];
                          return Column(
                            children: [
                              Card(
                                color: AppTheme.lightSurfaceBright,
                                margin: const EdgeInsets.all(8),
                                child: InkWell(
                                  onTap: row.onExpand != null
                                      ? () => row.onExpand!(row.id)
                                      : null,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.generate(
                                          headerCells.length, (cellIndex) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              DefaultTextStyle(
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                child: headerCells[cellIndex],
                                              ),
                                              const SizedBox(height: 4),
                                              row.cells[cellIndex],
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              ),
                              if (row.isExpanded && row.expandedContent != null)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: row.expandedContent!,
                                ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        // Rodapé mobile
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.lightOutline),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              footerText,
              style: AppTheme.h5(
                color: AppTheme.primaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyStateContent() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.lightOutline,
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "images/image_empty.svg",
              height: 150,
            ),
            const SizedBox(height: 16),
            Text(
              "Nenhum dado encontrado!",
              style: TextStyle(
                color: AppTheme.theme.primaryColor,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Expanded(
      child: _buildEmptyStateContent(),
    );
  }
}

class TableRowData {
  final String id;
  final List<Widget> cells;
  final Widget? expandedContent;
  final bool isExpanded;
  final Function(String)? onExpand;

  TableRowData({
    required this.id,
    required this.cells,
    this.expandedContent,
    this.isExpanded = false,
    this.onExpand,
  });
}
