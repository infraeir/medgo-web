import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medgo/pages/calculator/calculator_list/calculator_list_page.dart';
import 'package:medgo/pages/home/widgets/app_bar_home.dart';
import 'package:medgo/pages/patients/patients_page.dart';
import 'package:medgo/themes/app_theme.dart';
import '../../data/providers/logout_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String _selectedTabId = 'patients';

  @override
  void initState() {
    super.initState();

    // Verificar parâmetro tab na URL ao inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uri = GoRouterState.of(context).uri;
      final tabParam = uri.queryParameters['tab'];
      if (tabParam != null &&
          ['patients', 'calculators', 'prescriptions', 'consultations']
              .contains(tabParam)) {
        setState(() {
          _selectedTabId = tabParam;
        });
      }
    });
  }

  void _updateTab(String tabId) {
    setState(() {
      _selectedTabId = tabId;
    });

    // Atualizar URL com parâmetro tab
    final uri = GoRouterState.of(context).uri;
    final newUri = uri.replace(queryParameters: {'tab': tabId});
    context.go(newUri.toString());
  }

  int _getTabIndex(String tabId) {
    switch (tabId) {
      case 'patients':
        return 0;
      case 'calculators':
        return 1;
      case 'prescriptions':
        return 2;
      case 'consultations':
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryBackground,
      body: Column(
        children: [
          // AppBar customizada no topo
          AppBarHome(
            isHome: true,
            isSelected: [
              _selectedTabId == 'patients',
              _selectedTabId == 'calculators',
              _selectedTabId == 'prescriptions',
              _selectedTabId == 'consultations',
            ],
            onToggle: (index) {
              final List<String> tabs = [
                'patients',
                'calculators',
                'prescriptions',
                'consultations'
              ];
              if (index < tabs.length) {
                _updateTab(tabs[index]);
              }
            },
            onLogout: () async {
              await postLogout();
              if (mounted) {
                context.go('/signin');
              }
            },
          ),
          const SizedBox(height: 10),
          // Conteúdo principal
          Expanded(
            child: IndexedStack(
              index: _getTabIndex(_selectedTabId),
              children: [
                // Tab 0: Pacientes
                PatientsPage(
                  selected: (value) {
                    // Manter compatibilidade com o sistema antigo
                    final tabId = value[0] ? 'patients' : 'calculators';
                    _updateTab(tabId);
                  },
                ),
                // Tab 1: Calculadoras
                CalculatorListPage(
                  selected: (value) {
                    // Manter compatibilidade com o sistema antigo
                    final tabId = value[0] ? 'patients' : 'calculators';
                    _updateTab(tabId);
                  },
                ),
                // Tab 2: Prescrições
                const Center(
                  child: Text(
                    'Prescrições\n(Em desenvolvimento)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                // Tab 3: Consultas
                const Center(
                  child: Text(
                    'Consultas\n(Em desenvolvimento)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
