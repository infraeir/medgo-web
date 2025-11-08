import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medgo/data/models/consultation_socket_model.dart';
import 'package:medgo/strings/strings.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/themes/app_theme_spacing.dart';
import 'package:medgo/widgets/dynamic_form/widgets/custom_toolchip.dart';
import 'package:medgo/widgets/news_widgets/icon_button.dart';
import 'package:medgo/widgets/header/header_feedback_dignostico.dart';
import 'package:medgo/widgets/news_widgets/toggable_icon.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HeaderFeedbackConfirmadoWidget extends StatefulWidget {
  final ConsultationSocketModel? confirmedModel;
  final Function(String id, bool accept) updateConduct;

  const HeaderFeedbackConfirmadoWidget({
    super.key,
    this.confirmedModel,
    required this.updateConduct,
  });

  @override
  State<HeaderFeedbackConfirmadoWidget> createState() =>
      _HeaderFeedbackConfirmadoWidgetState();
}

class _HeaderFeedbackConfirmadoWidgetState
    extends State<HeaderFeedbackConfirmadoWidget> {
  List<String> confirmedOpen = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  Strings.logoSvg,
                  height: 40,
                  width: 40,
                ),
                Expanded(
                  child: Text(
                    'Seus diagnósticos confirmados',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: AppTheme.theme.primaryColor,
                        fontSize: AppThemeSpacing.dezesseis,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 4.0,
                      ),
                      child: CustomTooltip(
                        message:
                            'Esses são seu diagnósticos confimados. Com base neles são sugeridas condutas, que você pode escolher realizar ou não.',
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
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Visibility(
              visible: widget.confirmedModel?.confirmed?.isNotEmpty ?? false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: widget.confirmedModel?.confirmed
                            ?.map((confirmed) {
                          if (confirmedOpen.contains(confirmed)) {
                            return const SizedBox.shrink();
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xffF1F4F8),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey
                                      .withOpacity(0.5), // Cor da sombra
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              confirmed.title ?? '',
                                              style: TextStyle(
                                                color:
                                                    AppTheme.theme.primaryColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CustomIconButtonMedGo(
                                                icon: Icon(
                                                  confirmedOpen.contains(
                                                          confirmed.id!)
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
                                                    if (confirmedOpen.contains(
                                                        confirmed.id!)) {
                                                      confirmedOpen.remove(
                                                          confirmed.id!);
                                                    } else {
                                                      confirmedOpen
                                                          .add(confirmed.id!);
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
                                !confirmedOpen.contains(confirmed.id)
                                    ? Column(
                                        children: [
                                          Padding(
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
                                                  color:
                                                      const Color(0xff57636C),
                                                  shadows: [
                                                    BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        spreadRadius: 3,
                                                        blurRadius: 5,
                                                        offset:
                                                            const Offset(2, 2)),
                                                  ],
                                                ),
                                                const Text(
                                                  'Critérios:',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        AppTheme.secondaryText,
                                                  ),
                                                ),
                                                const Expanded(
                                                    child: SizedBox()),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    right: 8.0,
                                                  ),
                                                  child: CustomTooltip(
                                                    message:
                                                        'Critérios utilizados para esta hipótese, com base nos dados de seu paciente.',
                                                    child: IconButton(
                                                      padding: EdgeInsets.zero,
                                                      constraints:
                                                          const BoxConstraints(),
                                                      onPressed: () {},
                                                      icon: Icon(
                                                        PhosphorIcons.info(
                                                          PhosphorIconsStyle
                                                              .fill,
                                                        ),
                                                        color: const Color(
                                                            0xff57636C),
                                                        size: 22,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: AppThemeSpacing.quatro,
                                          ),
                                          const SizedBox(
                                              height: AppThemeSpacing.quatro),
                                          ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount:
                                                confirmed.criteria?.length,
                                            itemBuilder:
                                                ((context, criteriaIndex) {
                                              return HeaderDignosticoLabelWidget(
                                                criterionName: confirmed
                                                        .criteria?[
                                                            criteriaIndex]
                                                        .reason ??
                                                    'null',
                                              );
                                            }),
                                          ),
                                          const SizedBox(
                                              height: AppThemeSpacing.dez),
                                          confirmed.conducts != null
                                              ? Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .only(
                                                          top: AppThemeSpacing
                                                              .doze,
                                                          left: AppThemeSpacing
                                                              .oito),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          const Icon(
                                                            Icons.history_edu,
                                                            color: Color(
                                                                0xff57636C),
                                                          ),
                                                          const Text(
                                                              'Condutas:'),
                                                          const Expanded(
                                                              child:
                                                                  SizedBox()),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              right: 8.0,
                                                            ),
                                                            child:
                                                                CustomTooltip(
                                                              message:
                                                                  'Condutas relacionadas à essa hipótese, com base nos dados de seu paciente.',
                                                              child: IconButton(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                constraints:
                                                                    const BoxConstraints(),
                                                                onPressed:
                                                                    () {},
                                                                icon: Icon(
                                                                  PhosphorIcons
                                                                      .info(
                                                                    PhosphorIconsStyle
                                                                        .fill,
                                                                  ),
                                                                  color: const Color(
                                                                      0xff57636C),
                                                                  size: 22,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width:
                                                                AppThemeSpacing
                                                                    .dez,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: AppThemeSpacing
                                                          .quatro,
                                                    ),
                                                    ListView.builder(
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: confirmed
                                                          .conducts?.length,
                                                      itemBuilder: ((context,
                                                          conductIndex) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  ToggleIconButtonMedgo(
                                                                    isSelected: confirmed
                                                                        .conducts![
                                                                            conductIndex]
                                                                        .accepted!,
                                                                    onToggle:
                                                                        (selected) {
                                                                      widget
                                                                          .updateConduct(
                                                                        confirmed
                                                                            .conducts![conductIndex]
                                                                            .id!,
                                                                        selected,
                                                                      );
                                                                    },
                                                                  ),
                                                                  Text(
                                                                    confirmed
                                                                            .conducts?[conductIndex]
                                                                            .name ??
                                                                        '',
                                                                    overflow:
                                                                        TextOverflow
                                                                            .clip,
                                                                    style: TextStyle(
                                                                        color: AppTheme
                                                                            .theme
                                                                            .primaryColor,
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  ),
                                                                ],
                                                              ),
                                                              if (confirmed
                                                                      .conducts?[
                                                                          conductIndex]
                                                                      .dose !=
                                                                  null)
                                                                Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              6,
                                                                          left: AppThemeSpacing
                                                                              .oito,
                                                                          right:
                                                                              AppThemeSpacing.oito),
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius: BorderRadius.circular(AppThemeSpacing.quatro),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: AppTheme.theme.primaryColor,
                                                                                blurRadius: 1,
                                                                              )
                                                                            ]),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    const SizedBox(
                                                                                      width: AppThemeSpacing.quatro,
                                                                                    ),
                                                                                    const Text(
                                                                                      "Dose: ",
                                                                                      style: TextStyle(
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                    Text(
                                                                                      confirmed.conducts?[conductIndex].dose ?? '',
                                                                                      style: const TextStyle(
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              if (confirmed
                                                                      .conducts?[
                                                                          conductIndex]
                                                                      .age !=
                                                                  null)
                                                                Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              4,
                                                                          left: AppThemeSpacing
                                                                              .oito,
                                                                          right:
                                                                              AppThemeSpacing.oito),
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius: BorderRadius.circular(AppThemeSpacing.quatro),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: AppTheme.theme.primaryColor,
                                                                                blurRadius: 1,
                                                                              )
                                                                            ]),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    const SizedBox(
                                                                                      width: AppThemeSpacing.quatro,
                                                                                    ),
                                                                                    const Text(
                                                                                      "Início: ",
                                                                                      style: TextStyle(
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                    Text(
                                                                                      confirmed.conducts?[conductIndex].age ?? '',
                                                                                      style: const TextStyle(
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                    const SizedBox(
                                                      height:
                                                          AppThemeSpacing.dez,
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox.shrink(),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          );
                        }).toList() ??
                        [],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: AppThemeSpacing.dez,
            ),
          ],
        ),
      ),
    );
  }
}
