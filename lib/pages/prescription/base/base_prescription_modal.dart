import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/scrollbar/custom_scroll_bar.dart';

/// Modal base reutilizável para todos os tipos de prescrição
/// Fornece a estrutura visual comum: backdrop, container, sombras
abstract class BasePrescriptionModal extends StatefulWidget {
  const BasePrescriptionModal({super.key});
}

/// State base com estrutura comum para todos os modals de prescrição
abstract class BasePrescriptionModalState<T extends BasePrescriptionModal>
    extends State<T> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  /// Constrói o conteúdo principal do modal - deve implementar o SingleChildScrollView interno
  Widget buildContent();

  /// Constrói o cabeçalho específico do modal
  Widget buildHeader();

  /// Constrói o rodapé específico do modal
  Widget buildFooter();

  @override
  Widget build(BuildContext context) {
    // Otimizar BackdropFilter na web - usar opacity ao invés de blur pesado
    final backdropChild = Center(
      child: Dialog(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: AppTheme.info
                .withOpacity(0.98), // Usar opacity ao invés de blur adicional
            borderRadius:
                BorderRadius.circular(32.0), // Usar o mesmo raio do Dialog
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
                spreadRadius: 3,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 25,
                offset: const Offset(0, 3),
                spreadRadius: 8,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Conteúdo principal com CustomScrollbar
              Padding(
                padding: const EdgeInsets.only(
                  left: 24.0,
                  right: 20.0,
                ),
                child: CustomScrollbar(
                  trackMargin: const EdgeInsets.only(
                    top: 100,
                    bottom: 100,
                  ),
                  controller: scrollController,
                  child: Builder(builder: (context) {
                    return RepaintBoundary(
                      child: ScrollConfiguration(
                        behavior: _WebOptimizedScrollBehavior(),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: buildContent(),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // Header posicionado no topo - com clipBehavior para evitar linhas
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.info.withOpacity(0.98),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      child: buildHeader(),
                    ),
                  ),
                ),
              ),

              // Footer posicionado na parte inferior - com clipBehavior para evitar linhas
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.info.withOpacity(0.98),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 8,
                      ),
                      child: buildFooter(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Na web, usar Container com cor ao invés de BackdropFilter pesado
    if (kIsWeb) {
      return Container(
        color: Colors.black.withOpacity(0.3),
        child: backdropChild,
      );
    }

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: backdropChild,
    );
  }
}

/// ScrollBehavior otimizado para web com suporte a eventos passivos
class _WebOptimizedScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // Desabilitar scrollbar padrão já que usamos CustomScrollbar
    return child;
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // Desabilitar overscroll glow na web para melhor performance
    if (kIsWeb) {
      return child;
    }
    return super.buildOverscrollIndicator(context, child, details);
  }
}
