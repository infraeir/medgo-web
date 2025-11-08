// ignore_for_file: depend_on_referenced_packages, deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:medgo/pages/acompanying/acompanying_page.dart';
import 'package:medgo/pages/biblioteca/biblioteca_page.dart';
import 'package:medgo/pages/calculator/calculator_page.dart';
import 'package:medgo/pages/consultation/consultation.dart';
import 'package:medgo/pages/home/home_page.dart';
import 'package:medgo/pages/redirect/redirect.dart';
import 'package:medgo/pages/register/register_page.dart';
import 'package:medgo/pages/reset_password/reset_password_page.dart';
import 'package:medgo/pages/signIn/signin_page.dart';
import 'package:medgo/themes/app_theme.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';
import 'package:medgo/pages/consultation_history/consultation_history_page.dart';
import 'package:medgo/data/models/medical_enums.dart';
import 'package:medgo/helper/performance_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Tentar carregar .env, mas não falhar se não existir
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Arquivo .env não encontrado: $e');
      }
    }

    setUrlStrategy(PathUrlStrategy());

    if (kDebugMode) {
      print('🔧 Configurando performance...');
    }
    PerformanceConfig.configureApp();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    initializeDateFormatting('pt_BR', null);

    // Inicializar MedicalEnums de forma mais simples em caso de problema
    if (kDebugMode) {
      print('📋 Inicializando enums médicos...');
    }

    try {
      await MedicalEnums.initializeAsync();
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Falha na inicialização assíncrona, usando síncrona: $e');
      }
      MedicalEnums.initialize(); // Fallback para versão síncrona
    }

    if (kDebugMode) {
      print('🚀 Iniciando aplicação...');
    }

    runApp(const StyledToast(
      locale: Locale('pt', 'BR'),
      child: MyApp(),
    ));
  } catch (e) {
    log('❌ Erro durante inicialização: $e');
    // Em caso de erro, inicializar de forma mais simples
    runApp(MaterialApp(
      title: 'MedGo - Erro de Inicialização',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('MedGo'),
          backgroundColor: const Color(0xFF0175C2),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Erro na inicialização',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Detalhes: $e',
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => html.window.location.reload(),
                  child: const Text('Recarregar Página'),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // GoRouter como static para preservar estado durante hot reload
  static final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const RedirectPage(),
      ),
      GoRoute(
        path: '/biblioteca',
        builder: (context, state) => const BibliotecaPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPageMedGo(),
      ),
      GoRoute(
        path: '/signin',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/recover-password',
        builder: (context, state) {
          final token = state.uri.queryParameters['t'];

          return ResetPasswordPage(
            token: token ?? '',
          );
        },
      ),
      GoRoute(
        path: '/calculator/:calculatorType',
        builder: (context, state) {
          final calculatorType = state.pathParameters['calculatorType']!;

          return CalculatorPage(
            calculatorType: calculatorType,
          );
        },
      ),
      GoRoute(
        path: '/acompanying/:id',
        builder: (context, state) {
          final patientId = state.pathParameters['id']!;
          return AcompanyingData(patientId: patientId);
        },
      ),
      GoRoute(
        path: '/consultation/:patientId/:consultationId',
        builder: (context, state) {
          final patientId = state.pathParameters['patientId']!;
          final consultationId = state.pathParameters['consultationId']!;

          return ConsultationPage(
            consultationId: consultationId,
            patientId: patientId,
          );
        },
      ),
      GoRoute(
        path: '/consultation-history/:patientId',
        builder: (context, state) {
          final patientId = state.pathParameters['patientId']!;
          return ConsultationHistoryPage(
            patientId: patientId,
          );
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      routerConfig: _router,
    );
  }
}
