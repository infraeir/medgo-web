import 'package:flutter/material.dart';
import 'package:medgo/data/blocs/calculator/caclulator_bloc.dart';
import 'package:medgo/data/models/consultation_socket_model.dart';
import 'package:medgo/data/socket/socket_manager.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/themes/app_theme_spacing.dart';
import 'package:medgo/widgets/header/header_feedback_confirmados.dart';
import 'package:medgo/widgets/header/header_feedback_hipoteses.dart';
import 'package:medgo/widgets/header/header_feedback_sugestoes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeaderCalculator extends StatefulWidget {
  final String calculatorId;
  final List<String> allowedDiagnosesTypes;
  final CalculatorBloc calculatorBloc;
  final VoidCallback reloadConsulta;
  final VoidCallback reloadForm;
  const HeaderCalculator({
    super.key,
    required this.calculatorId,
    required this.calculatorBloc,
    required this.reloadConsulta,
    required this.reloadForm,
    required this.allowedDiagnosesTypes,
  });

  @override
  State<HeaderCalculator> createState() => _HeaderCalculatorState();
}

class _HeaderCalculatorState extends State<HeaderCalculator> {
  late SocketManager socketManager;
  ConsultationSocketModel? consultationModel;

  @override
  void initState() {
    super.initState();
    socketManager = SocketManager.getInstance();
    openSocketConnections();
    consultationModel = ConsultationSocketModel(
        suggestions: [], consultationId: widget.calculatorId);
  }

  Future<void> openSocketConnections() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('userToken') ?? '';

    openDiagnosesConnection(token);
    openConsultationConnection(token);
  }

  void openDiagnosesConnection(String token) {
    final fullPath = "diagnoses?calculatorId=${widget.calculatorId}";
    const event = 'diagnoses_updated';
    socketManager.connect(
      fullPath,
      event,
      token,
      (eventData) {
        print("Recebidas novas sugestões de diagnóstico: $eventData");
        updateSuggestions(ConsultationSocketModel.fromJson(eventData['data']));
      },
    );
  }

  void openConsultationConnection(String token) {
    final fullPathConsultation =
        "calculators?calculatorId=${widget.calculatorId}";
    const eventConsultation = 'update_calculator_dynamic_form';
    socketManager.connect(
      fullPathConsultation,
      eventConsultation,
      token,
      (eventData) {
        print("Recebida atualização do formulário dinâmico: $eventData");
        reloadForm();
      },
    );
  }

  void updateSuggestions(ConsultationSocketModel suggestions) {
    if (mounted) {
      setState(() {
        consultationModel = suggestions;
      });
    }
  }

  void reloadForm() {
    if (mounted) {
      widget.reloadForm();
    }
  }

  Future<void> acceptSocketConnection(String diagnosisID) async {
    final Map<String, String> payload = {
      "diagnosisId": diagnosisID,
    };

    socketManager.notifyServerWith('accept_diagnosis_suggestion', payload);
  }

  Future<void> rejectSocketConnection(String diagnosisID) async {
    final Map<String, String> payload = {
      "diagnosisId": diagnosisID,
    };

    socketManager.notifyServerWith('reject_diagnosis_suggestion', payload);
  }

  Future<void> updateConductSocketConnection(
      String conductID, bool accept) async {
    final Map<String, dynamic> payload = {
      "conductId": conductID,
      "isAccepted": accept
    };

    socketManager.notifyServerWith('update_conduct_status', payload);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: MediaQuery.of(context).size.height * 0.98,
        decoration: BoxDecoration(
          color: AppTheme.lightBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.theme.primaryColor.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: AppThemeSpacing.dez,
              ),
              widget.allowedDiagnosesTypes.contains('suggestion')
                  ? Container(
                      margin: const EdgeInsets.only(
                        bottom: AppThemeSpacing.dez,
                      ),
                      child: HeaderFeedbackSugestoesWidget(
                        suggestionModel: consultationModel,
                        accept: (id) {
                          acceptSocketConnection(id);
                        },
                      ),
                    )
                  : const SizedBox.shrink(),
              widget.allowedDiagnosesTypes.contains('hypothesis')
                  ? Container(
                      margin: const EdgeInsets.only(
                        bottom: AppThemeSpacing.dez,
                      ),
                      child: HeaderFeedbackHipotesesWidget(
                        hyphoteseModel: consultationModel,
                        reject: (id) {
                          rejectSocketConnection(id);
                        },
                        updateConduct: (id, accept) {
                          updateConductSocketConnection(id, accept);
                        },
                      ),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(
                height: AppThemeSpacing.dez,
              ),
              widget.allowedDiagnosesTypes.contains('confirmed')
                  ? Container(
                      margin: const EdgeInsets.only(
                        bottom: AppThemeSpacing.dez,
                      ),
                      child: HeaderFeedbackConfirmadoWidget(
                        confirmedModel: consultationModel,
                        updateConduct: (id, accept) {
                          updateConductSocketConnection(id, accept);
                        },
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
