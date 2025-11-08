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

class HeaderFeedbackHipotesesWidget extends StatefulWidget {
  final ConsultationSocketModel? hyphoteseModel;
  final Function(String id) reject;
  final Function(String id, bool accept) updateConduct;

  const HeaderFeedbackHipotesesWidget({
    super.key,
    this.hyphoteseModel,
    required this.reject,
    required this.updateConduct,
  });

  @override
  State<HeaderFeedbackHipotesesWidget> createState() =>
      _HeaderFeedbackHipotesesWidgetState();
}

class _HeaderFeedbackHipotesesWidgetState
    extends State<HeaderFeedbackHipotesesWidget> {
  List<String> hypotheseOpen = [];

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
                    'Hipóteses diagnósticas da MedGo',
                    style: TextStyle(
                      color: AppTheme.theme.primaryColor,
                      fontSize: AppThemeSpacing.dezesseis,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: CustomTooltip(
                    message:
                        'Essas são suas hipóteses diagnósticas de trabalho. Com base nelas são sugeridas condutas, que você pode escolher realizar ou não.',
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
            Visibility(
              visible: widget.hyphoteseModel?.hypotheses?.isNotEmpty ?? false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children:
                        widget.hyphoteseModel?.hypotheses?.map((hypothese) {
                              if (hypotheseOpen.contains(hypothese)) {
                                return const SizedBox.shrink();
                              }

                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
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
                                                  hypothese.title ?? '',
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    color: AppTheme
                                                        .theme.primaryColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  CustomIconButtonMedGo(
                                                    onPressed: () {
                                                      widget.reject(
                                                          hypothese.id ?? '');
                                                    },
                                                    icon: Icon(
                                                      PhosphorIcons.xCircle(
                                                        PhosphorIconsStyle.bold,
                                                      ),
                                                      color: const Color(
                                                          0xffFF5963),
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
                                                      hypotheseOpen.contains(
                                                              hypothese.id!)
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
                                                        if (hypotheseOpen
                                                            .contains(hypothese
                                                                .id!)) {
                                                          hypotheseOpen.remove(
                                                              hypothese.id!);
                                                        } else {
                                                          hypotheseOpen.add(
                                                              hypothese.id!);
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ],
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    !hypotheseOpen.contains(hypothese.id)
                                        ? Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: AppThemeSpacing.oito,
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Icon(
                                                      PhosphorIcons.listChecks(
                                                        PhosphorIconsStyle.bold,
                                                      ),
                                                      color: const Color(
                                                          0xff57636C),
                                                      shadows: [
                                                        BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.5),
                                                            spreadRadius: 3,
                                                            blurRadius: 5,
                                                            offset:
                                                                const Offset(
                                                                    2, 2)),
                                                      ],
                                                    ),
                                                    const Text(
                                                      'Critérios:',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppTheme
                                                            .secondaryText,
                                                      ),
                                                    ),
                                                    const Expanded(
                                                        child: SizedBox()),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 10.0),
                                                      child: CustomTooltip(
                                                        message:
                                                            'Critérios utilizados para esta hipótese, com base nos dados de seu paciente.',
                                                        child: IconButton(
                                                          padding:
                                                              EdgeInsets.zero,
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
                                                  height:
                                                      AppThemeSpacing.quatro),
                                              ListView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount:
                                                    hypothese.criteria?.length,
                                                itemBuilder:
                                                    ((context, criteriaIndex) {
                                                  return HeaderDignosticoLabelWidget(
                                                    criterionName: hypothese
                                                            .criteria?[
                                                                criteriaIndex]
                                                            .reason ??
                                                        'null',
                                                  );
                                                }),
                                              ),
                                              hypothese.conducts != null
                                                  ? Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .only(
                                                              top:
                                                                  AppThemeSpacing
                                                                      .doze,
                                                              left:
                                                                  AppThemeSpacing
                                                                      .oito),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .history_edu,
                                                                color: const Color(
                                                                    0xff57636C),
                                                                shadows: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.5),
                                                                      spreadRadius:
                                                                          3,
                                                                      blurRadius:
                                                                          5,
                                                                      offset:
                                                                          const Offset(
                                                                              2,
                                                                              2)),
                                                                ],
                                                              ),
                                                              const Text(
                                                                'Condutas:',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: AppTheme
                                                                      .secondaryText,
                                                                ),
                                                              ),
                                                              const Expanded(
                                                                  child:
                                                                      SizedBox()),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            10.0),
                                                                child:
                                                                    CustomTooltip(
                                                                  message:
                                                                      'Condutas relacionadas à essa hipótese, com base nos dados de seu paciente.',
                                                                  child:
                                                                      IconButton(
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
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height:
                                                              AppThemeSpacing
                                                                  .quatro,
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 10,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5), // Cor da sombra
                                                                spreadRadius: 2,
                                                                blurRadius: 5,
                                                              ),
                                                            ],
                                                          ),
                                                          child:
                                                              ListView.builder(
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemCount: hypothese
                                                                .conducts
                                                                ?.length,
                                                            itemBuilder: ((context,
                                                                conductIndex) {
                                                              return Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        5),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        ToggleIconButtonMedgo(
                                                                          isSelected: hypothese
                                                                              .conducts![conductIndex]
                                                                              .accepted!,
                                                                          onToggle:
                                                                              (selected) {
                                                                            widget.updateConduct(
                                                                              hypothese.conducts![conductIndex].id!,
                                                                              selected,
                                                                            );
                                                                          },
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            hypothese.conducts?[conductIndex].name ??
                                                                                '',
                                                                            overflow:
                                                                                TextOverflow.visible,
                                                                            softWrap:
                                                                                true,
                                                                            style:
                                                                                TextStyle(
                                                                              color: AppTheme.theme.primaryColor,
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w700,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    if (hypothese
                                                                            .conducts?[conductIndex]
                                                                            .dose !=
                                                                        null)
                                                                      Column(
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                top: 6,
                                                                                left: AppThemeSpacing.oito,
                                                                                right: AppThemeSpacing.oito),
                                                                            child:
                                                                                Container(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                                                                              decoration: BoxDecoration(
                                                                                color: AppTheme.primaryBackground,
                                                                                borderRadius: BorderRadius.circular(AppThemeSpacing.quatro),
                                                                                boxShadow: [
                                                                                  BoxShadow(
                                                                                    color: AppTheme.theme.primaryColor,
                                                                                    blurRadius: 1,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              child: Column(
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
                                                                                              color: AppTheme.primary,
                                                                                              fontWeight: FontWeight.bold,
                                                                                            ),
                                                                                          ),
                                                                                          Text(
                                                                                            hypothese.conducts?[conductIndex].dose ?? '',
                                                                                            style: const TextStyle(
                                                                                              color: Colors.black,
                                                                                              fontWeight: FontWeight.bold,
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
                                                                    if (hypothese
                                                                            .conducts?[conductIndex]
                                                                            .age !=
                                                                        null)
                                                                      Column(
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                top: 6,
                                                                                left: AppThemeSpacing.oito,
                                                                                right: AppThemeSpacing.oito),
                                                                            child:
                                                                                Container(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                                                                              decoration: BoxDecoration(
                                                                                color: AppTheme.primaryBackground,
                                                                                borderRadius: BorderRadius.circular(AppThemeSpacing.quatro),
                                                                                boxShadow: [
                                                                                  BoxShadow(
                                                                                    color: AppTheme.theme.primaryColor,
                                                                                    blurRadius: 1,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              child: Column(
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
                                                                                            style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
                                                                                          ),
                                                                                          Text(
                                                                                            hypothese.conducts?[conductIndex].age ?? '',
                                                                                            style: const TextStyle(
                                                                                              color: Colors.black,
                                                                                              fontWeight: FontWeight.bold,
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
                                                                      height:
                                                                          10,
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            }),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height:
                                                              AppThemeSpacing
                                                                  .dez,
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

            // const SizedBox(
            //   height: AppThemeSpacing.dez,
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //       top: AppThemeSpacing.doze, left: AppThemeSpacing.oito),
            //   child: Row(
            //     mainAxisSize: MainAxisSize.max,
            //     children: const [
            //       Icon(
            //         PhosphorIcons.list_checks_bold,
            //         color: Color(0xff57636C),
            //       ),
            //       Text('Condutas:'),
            //       Expanded(child: SizedBox()),
            //       Icon(
            //         PhosphorIcons.info_fill,
            //         color: Color(0xff57636C),
            //       ),
            //       SizedBox(
            //         width: AppThemeSpacing.dez,
            //       ),
            //     ],
            //   ),
            // ),
            // Column(
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.only(
            //           top: AppThemeSpacing.doze,
            //           left: AppThemeSpacing.oito,
            //           right: AppThemeSpacing.oito),
            //       child: Container(
            //         decoration: BoxDecoration(
            //           color: Colors.white,
            //           borderRadius:
            //               BorderRadius.circular(AppThemeSpacing.quatro),
            //         ),
            //         child: Column(children: [
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.start,
            //                 children: [
            //                   const SizedBox(
            //                     width: AppThemeSpacing.dezesseis,
            //                   ),
            //                   Icon(
            //                     PhosphorIcons.square_bold,
            //                     color: AppTheme.theme.primaryColor,
            //                     size: AppThemeSpacing.vinte,
            //                   ),
            //                   const SizedBox(
            //                     width: AppThemeSpacing.quatro,
            //                   ),
            //                   const Text(
            //                     'Suplementação de ferro',
            //                     style: TextStyle(
            //                       color: Colors.black,
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.end,
            //                 children: const [
            //                   Icon(
            //                     PhosphorIcons.info_fill,
            //                     color: Color(0xff57636C),
            //                   ),
            //                 ],
            //               )
            //             ],
            //           ),
            //           Container(
            //             decoration: BoxDecoration(
            //                 color: Color(0xffF1F4F8),
            //                 borderRadius:
            //                     BorderRadius.circular(AppThemeSpacing.quatro),
            //                 boxShadow: const [
            //                   BoxShadow(
            //                     color: Color(0xffF1F4F8),
            //                     blurRadius: 1,
            //                   )
            //                 ]),
            //             child: Column(
            //               children: [
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.start,
            //                   children: const [
            //                     Text('Dose: '),
            //                   ],
            //                 ),
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.start,
            //                   children: const [Text('Inicio: ')],
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ]),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
