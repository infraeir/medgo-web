import 'package:flutter/material.dart';
import 'package:medgo/data/blocs/prescription/prescription_bloc.dart';
import 'package:medgo/data/models/system_prescription_model.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/input_icon_chip.dart';
import 'package:medgo/widgets/news_widgets/icon_button.dart';
import 'package:medgo/widgets/prescription/new_recommended_prescription.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'new_horizontal_remedy_list.dart';

class NewPrescriptionSection extends StatefulWidget {
  final SystemPrescriptionModel prescription;
  final String controllerKey;
  final Function({required String prescriptionItemId, required bool isChosen})
      onUpdatePrescription;
  final VoidCallback onReload;
  final String? consultationId;
  final String? calculatorId;
  final PrescriptionBloc prescriptionBloc;

  const NewPrescriptionSection({
    Key? key,
    required this.prescription,
    required this.controllerKey,
    required this.onUpdatePrescription,
    required this.onReload,
    required this.consultationId,
    required this.calculatorId,
    required this.prescriptionBloc,
  }) : super(key: key);

  @override
  State<NewPrescriptionSection> createState() => _NewPrescriptionSectionState();
}

class _NewPrescriptionSectionState extends State<NewPrescriptionSection> {
  late ScrollController _scrollController;
  bool _canScrollLeft = false;
  bool _canScrollRight = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_updateScrollState);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateScrollState();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollState);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateScrollState() {
    if (mounted) {
      setState(() {
        _canScrollLeft = _scrollController.offset > 0;
        _canScrollRight = _scrollController.offset <
            _scrollController.position.maxScrollExtent;
      });
    }
  }

  void _scroll(bool forward) {
    final targetOffset = forward
        ? _scrollController.offset + 200
        : _scrollController.offset - 200;

    _scrollController.animateTo(
      targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSectionTitle(),
          _buildContentContainer(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 20,
              bottom: 2,
            ),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Indicação: ',
                    style: AppTheme.h4(
                      color: AppTheme.theme.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: widget.prescription.conduct.name,
                    style: AppTheme.h4(
                      color: AppTheme.blueDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              InputIconChipMedgo(
                icon: Icon(
                  PhosphorIcons.prescription(),
                  color: AppTheme.salmon,
                  size: 20,
                ),
                title: 'Automática',
                selectedChip: true,
                onSelected: (selected) {},
              ),
              const SizedBox(width: 10),
              InputIconChipMedgo(
                title: 'Simples',
                selectedChip: false,
                onSelected: (selected) {},
              ),
              const SizedBox(width: 10),
              InputIconChipMedgo(
                title: 'Manual',
                selectedChip: false,
                onSelected: (selected) {},
              ),
              const SizedBox(width: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentContainer() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.theme.primaryColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NewHorizontalRemedyList(
                prescription: widget.prescription,
                scrollController: _scrollController,
                onUpdatePrescription: widget.onUpdatePrescription,
                canScrollLeft:
                    widget.prescription.items.length > 3 && _canScrollLeft,
                canScrollRight:
                    widget.prescription.items.length > 3 && _canScrollRight,
              ),
              if (widget.prescription.items.any((item) => item.isChosen))
                Padding(
                  padding: const EdgeInsets.only(
                    right: 8.0,
                    left: 8.0,
                    bottom: 8.0,
                  ),
                  child: NewRecommendedPrescription(
                    prescription: widget.prescription,
                    consultationId: widget.consultationId,
                    calculatorId: widget.calculatorId,
                    prescriptionBloc: widget.prescriptionBloc,
                    reload: widget.onReload,
                    onUpdatePrescription: widget.onUpdatePrescription,
                  ),
                ),
            ],
          ),
        ),
        if (widget.prescription.items.length > 3) ...[
          if (_canScrollLeft) _buildLeftButton(),
          if (_canScrollRight) _buildRightButton(),
        ],
      ],
    );
  }

  Widget _buildLeftButton() {
    return Positioned(
      left: 5,
      top: 82,
      child: CustomIconButtonMedGo(
        padding: EdgeInsets.zero,
        onPressed: () => _scroll(false),
        icon: const Icon(
          PhosphorIconsBold.caretLeft,
          color: AppTheme.primary,
          shadows: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
          size: 24,
        ),
      ),
    );
  }

  Widget _buildRightButton() {
    return Positioned(
      right: 5,
      top: 82,
      child: CustomIconButtonMedGo(
        padding: EdgeInsets.zero,
        onPressed: () => _scroll(true),
        icon: const Icon(
          PhosphorIconsBold.caretRight,
          color: AppTheme.primary,
          shadows: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
          size: 24,
        ),
      ),
    );
  }
}
