import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medgo/data/models/consultation_socket_model.dart';
import 'package:medgo/strings/strings.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/themes/app_theme_spacing.dart';
import 'package:medgo/widgets/dynamic_form/widgets/custom_toolchip.dart';
import 'package:medgo/widgets/news_widgets/icon_button.dart';
import 'package:medgo/widgets/header/header_feedback_dignostico.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HeaderFeedbackSugestoesWidget extends StatefulWidget {
  final ConsultationSocketModel? suggestionModel;
  final Function(String id) accept;
  const HeaderFeedbackSugestoesWidget({
    Key? key,
    required this.suggestionModel,
    required this.accept,
  }) : super(key: key);

  @override
  State<HeaderFeedbackSugestoesWidget> createState() =>
      _HeaderFeedbackSugestoesWidgetState();
}

class _HeaderFeedbackSugestoesWidgetState
    extends State<HeaderFeedbackSugestoesWidget> {
  List<String> suggestionOpen = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8.0, right: 8.0),
      padding: const EdgeInsets.only(
          top: 4.0, left: 14.0, right: 14.0, bottom: 14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Cor da sombra
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Use Expanded para o texto ocupar o espaço disponível
                  SvgPicture.asset(
                    Strings.logoSvg,
                    height: 40,
                    width: 40,
                  ),
                  Expanded(
                    child: Text(
                      'Sugestões diagnósticas do MedGo',
                      style: TextStyle(
                        color: AppTheme.theme.primaryColor,
                        fontSize: AppThemeSpacing.dezesseis,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: CustomTooltip(
                      message:
                          'As sugestões diagnósticas são sugeridas com base em critérios diagnósticos descritos em artigos, diretrizes ou protocolos institucionais.',
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {},
                        icon: Icon(
                          PhosphorIcons.info(
                            PhosphorIconsStyle.fill,
                          ),
                          color: Color(0xff57636C),
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Visibility(
            visible: widget.suggestionModel?.suggestions?.isNotEmpty ?? false,
            child: Column(
              children: widget.suggestionModel?.suggestions?.map((suggestion) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffF1F4F8),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.grey.withOpacity(0.5), // Cor da sombra
                            spreadRadius: 1,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: AppThemeSpacing.oito,
                            ),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Title with flexible width and line break
                                    Expanded(
                                      child: Text(
                                        suggestion.title ?? '',
                                        // Remove overflow and maxLines to allow line break
                                        style: TextStyle(
                                          color: AppTheme.theme.primaryColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    // Action buttons, wrapped to avoid overflow
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomIconButtonMedGo(
                                          onPressed: () {
                                            widget.accept(suggestion.id ?? '');
                                          },
                                          icon: Icon(
                                            PhosphorIcons.checkCircle(
                                              PhosphorIconsStyle.bold,
                                            ),
                                            color: const Color(
                                              0xff229689,
                                            ),
                                            shadows: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                              ),
                                            ],
                                          ),
                                        ),
                                        CustomIconButtonMedGo(
                                          icon: Icon(
                                            suggestionOpen
                                                    .contains(suggestion.id!)
                                                ? Icons.expand_more
                                                : Icons.expand_less,
                                            color: AppTheme.primary,
                                            shadows: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                              ),
                                            ],
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if (suggestionOpen
                                                  .contains(suggestion.id!)) {
                                                suggestionOpen
                                                    .remove(suggestion.id!);
                                              } else {
                                                suggestionOpen
                                                    .add(suggestion.id!);
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          !suggestionOpen.contains(suggestion.id)
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: AppThemeSpacing.doze,
                                      left: AppThemeSpacing.oito),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Icon(
                                        PhosphorIcons.listChecks(
                                          PhosphorIconsStyle.bold,
                                        ),
                                        color: const Color(0xff57636C),
                                        shadows: [
                                          BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 3,
                                              blurRadius: 5,
                                              offset: Offset(2, 2)),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 4.0,
                                      ),
                                      const Text(
                                        'Critérios:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.secondaryText,
                                        ),
                                      ),
                                      const Expanded(child: SizedBox()),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: CustomTooltip(
                                          message:
                                              'Critérios utilizados para esta sugestão, com base nos dados de seu paciente.',
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            onPressed: () {},
                                            icon: Icon(
                                              PhosphorIcons.info(
                                                PhosphorIconsStyle.fill,
                                              ),
                                              color: const Color(0xff57636C),
                                              size: 22,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(
                            height: AppThemeSpacing.quatro,
                          ),
                          !suggestionOpen.contains(suggestion.id)
                              ? ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: suggestion.criteria?.length,
                                  itemBuilder: ((context, criteriaIndex) {
                                    return HeaderDignosticoLabelWidget(
                                      criterionName: suggestion
                                              .criteria?[criteriaIndex]
                                              .reason ??
                                          'null',
                                    );
                                  }),
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(height: AppThemeSpacing.quatro),
                        ],
                      ),
                    );
                  }).toList() ??
                  [],
            ),
          ),
          const SizedBox(height: AppThemeSpacing.dez),
        ],
      ),
    );
  }
}
