import 'package:flutter/foundation.dart';

class PerformanceConfig {
  static const bool enablePerformanceOverlay = kDebugMode;
  static const bool enableRepaintRainbow = false;
  static const bool showSemanticsDebugger = false;

  // Configurações de debounce para melhorar performance
  static const Duration searchDebounceDelay = Duration(milliseconds: 500);
  static const Duration overlayRebuildDelay = Duration(milliseconds: 100);

  // Configurações de paginação
  static const int defaultPageSize = 20;
  static const int maxCachedPages = 5;

  // Configurações de scroll
  static const double scrollThresholdForLoadMore = 0.85;
  static const double scrollPhysicsSpringConstant = 100.0;

  // Configurações de overlay
  static const Duration overlayAnimationDuration = Duration(milliseconds: 200);
  static const double maxOverlayHeight = 300.0;

  // Configurações de BLoC
  static const Duration blocStateChangeDebounce = Duration(milliseconds: 50);

  static void configureApp() {
    if (kDebugMode) {
      print('🔧 PerformanceConfig: Configurações de performance aplicadas');
      print('   - Search debounce: ${searchDebounceDelay.inMilliseconds}ms');
      print(
          '   - Overlay rebuild delay: ${overlayRebuildDelay.inMilliseconds}ms');
      print('   - Page size: $defaultPageSize');
    }
  }
}
