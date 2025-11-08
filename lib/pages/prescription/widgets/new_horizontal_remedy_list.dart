// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:medgo/data/models/system_prescription_model.dart';
import 'package:medgo/widgets/prescription/new_system_remedy_card.dart';
import 'package:medgo/widgets/scrollbar/custom_scroll_bar.dart';

class NewHorizontalRemedyList extends StatelessWidget {
  final SystemPrescriptionModel prescription;
  final ScrollController scrollController;
  final Function({required String prescriptionItemId, required bool isChosen})
      onUpdatePrescription;
  final bool canScrollLeft;
  final bool canScrollRight;

  const NewHorizontalRemedyList({
    Key? key,
    required this.prescription,
    required this.scrollController,
    required this.onUpdatePrescription,
    this.canScrollLeft = false,
    this.canScrollRight = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: const BorderRadiusGeometry.all(Radius.circular(20)),
        child: Stack(
          children: [
            GestureDetector(
              onPanUpdate: (details) {
                final newOffset = scrollController.offset - details.delta.dx;
                if (newOffset >= 0 &&
                    newOffset <= scrollController.position.maxScrollExtent) {
                  scrollController.jumpTo(newOffset);
                }
              },
              child: CustomScrollbar(
                controller: scrollController,
                axis: Axis.horizontal,
                trackMargin: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Builder(
                  builder: (context) => ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      scrollbars: false,
                    ),
                    child: Listener(
                      onPointerSignal: (event) {},
                      child: ListView.builder(
                        controller: scrollController,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemCount: prescription.items.length,
                        itemBuilder: (context, idx) {
                          return Container(
                            margin: EdgeInsets.only(
                              right:
                                  idx == prescription.items.length - 1 ? 0 : 10,
                              bottom: 18,
                            ),
                            child: NewSystemRemedyCard(
                              click: (mdc) {
                                onUpdatePrescription(
                                  isChosen: !prescription.items[idx].isChosen,
                                  prescriptionItemId:
                                      prescription.items[idx].id,
                                );
                              },
                              medication: prescription.items[idx],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Blur gradient - início (esquerda)
            if (canScrollLeft)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 42,
                child: IgnorePointer(
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [
                              Colors.white,
                              Colors.transparent,
                            ],
                            stops: [0.0, 1.0],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.dstOut,
                        child: Container(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            // Blur gradient - final (direita)
            if (canScrollRight)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: 42,
                child: IgnorePointer(
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.white,
                              Colors.white.withOpacity(0.4),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.4, 1.0],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.dstOut,
                        child: Container(
                          color: Colors.white,
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
}
