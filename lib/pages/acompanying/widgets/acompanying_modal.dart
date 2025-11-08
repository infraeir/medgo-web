// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:medgo/data/blocs/acompanying/acompanying_bloc.dart';
import 'package:medgo/data/blocs/acompanying/acompanying_event.dart';
import 'package:medgo/data/blocs/acompanying/acompanying_state.dart';
import 'package:medgo/data/models/companion_model.dart';
import 'package:medgo/data/models/patients_model.dart';
import 'package:medgo/strings/strings.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/buttons/primary_icon_button.dart';
import 'package:medgo/widgets/news_widgets/buttons/tertiary_icon_button.dart';
import 'package:medgo/widgets/news_widgets/icon_button.dart';
import 'package:medgo/widgets/button/outline_button.dart';
import 'package:medgo/widgets/button/primary_button.dart';
import 'package:medgo/widgets/dialogs/dialog.dart';
import 'package:medgo/widgets/dialogs/loading_dialog.dart';
import 'package:medgo/widgets/news_widgets/input_chip.dart';
import 'package:medgo/widgets/news_widgets/input_icon_chip.dart';
import 'package:medgo/widgets/news_widgets/short_text_input.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CompanionModal extends StatefulWidget {
  final PatientsModel patient;
  final CompanionModel? companion;
  final String? consultationID;
  final Function(List<CompanionModel>?) companionsUpdated;
  const CompanionModal({
    super.key,
    required this.patient,
    this.companion,
    this.consultationID,
    required this.companionsUpdated,
  });

  @override
  State<CompanionModal> createState() => _CompanionModalState();
}

class _CompanionModalState extends State<CompanionModal> {
  String selectedSex = 'male';
  String selectedRelation = 'father';
  bool _isNameError = false;
  TextEditingController nameController = TextEditingController();
  late final CompanionBloc _companionBloc;

  @override
  void initState() {
    super.initState();
    _companionBloc = GetIt.I<CompanionBloc>();
    if (widget.companion != null) {
      nameController.text = widget.companion!.name;
      selectedSex = widget.companion!.gender;
      selectedRelation = widget.companion!.relationship;
    }
    _listenEvents();
  }

  void _listenEvents() {
    _companionBloc.stream.listen((state) {
      if (state is CompanionLoading) {
        shoLoadingDialog(context: context, barriedDismissible: false);
      } else if (state is CompanionPosted ||
          state is CompanionPuted ||
          state is CompanionPatched ||
          state is CompanionDeleted) {
        Navigator.of(context).pop();

        // Fecha o modal principal retornando true para atualizar a tela anterior
        Navigator.of(context).pop('true');
        if (state is CompanionDeleted) {
          Navigator.of(context).pop('true');
        }

        // Se for uma atualização, atualiza a lista de acompanhantes
        if (state is CompanionPatched) {
          widget.companionsUpdated(state.companions);
        }
      } else if (state is CompanionError) {
        Navigator.of(context).pop();

        String errorMessage = state.e.toString();

        showTheDialog(
          context: context,
          title: "Erro!",
          actionButtonText2: Strings.fechar,
          onActionButtonPressed: () {},
          body: Text(
            errorMessage,
            style: const TextStyle(color: Colors.red),
          ),
        );
      }
    });
  }

  cadastrarCompanion() {
    if (widget.consultationID == null) {
      _companionBloc.add(
        PostCompanion(
          gender: selectedSex,
          idPatient: widget.patient.id,
          name: nameController.text,
          relationship: selectedRelation,
          relationshipAddInfo: '',
        ),
      );
    } else {
      _companionBloc.add(
        PostExtraCompanion(
            name: nameController.text,
            gender: selectedSex,
            relationship: selectedRelation,
            relationshipAddInfo: '',
            consultationsID: widget.consultationID ?? ''),
      );
    }
  }

  editarCompanion() {
    _companionBloc.add(
      PutCompanion(
        idCompanion: widget.companion!.id,
        gender: selectedSex,
        idPatient: widget.patient.id,
        name: nameController.text,
        relationship: selectedRelation,
        relationshipAddInfo: '',
      ),
    );
  }

  deleteCompanion() {
    _companionBloc.add(
      DeleteCompanion(
        companionID: widget.companion!.id,
      ),
    );
  }

  validarCampos() {
    if (nameController.text.isEmpty) {
      setState(() {
        _isNameError = true;
      });
    } else {
      if (widget.companion != null) {
        editarCompanion();
      } else {
        cadastrarCompanion();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Center(
        child: Dialog(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          child: Container(
            width: 960,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppTheme.secondaryBackground,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Sombra mais suave
                  blurRadius: 30,
                  offset: const Offset(0, 5),
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${widget.companion != null ? 'Edição' : 'Cadastro'} de Acompanhante',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          shadows: [
                            Shadow(
                              color: AppTheme.primary.withOpacity(0.3),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Nome do Acompanhante',
                            style: TextStyle(
                              color: AppTheme.secondaryText,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ShortTextInputMedgo(
                              controller: nameController,
                              hintText: Strings.nomePaciente,
                              onChanged: (value) {
                                bool hasError = value.isNotEmpty;
                                setState(() {
                                  _isNameError = !hasError;
                                });
                              },
                              errorText: _isNameError
                                  ? 'Erro no nome do acompanhante'
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sexo',
                                    style: TextStyle(
                                      color: AppTheme.secondaryText,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InputIconChipMedgo(
                                    icon: Icon(
                                      PhosphorIcons.genderFemale(),
                                      color: const Color(0xffAD00B1),
                                      size: 18,
                                    ),
                                    selectedChip: selectedSex == 'female',
                                    title: 'Feminino',
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          selectedSex = 'female';
                                        }
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  InputIconChipMedgo(
                                    icon: Icon(
                                      PhosphorIcons.genderMale(),
                                      color: Color(0xff003FBA),
                                      size: 18,
                                      shadows: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.50),
                                          blurRadius: 1.5,
                                          offset: const Offset(-0.25, 1),
                                        ),
                                      ],
                                    ),
                                    selectedChip: selectedSex == 'male',
                                    title: Strings.masculino,
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          selectedSex = 'male';
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Relação',
                                    style: TextStyle(
                                      color: AppTheme.secondaryText,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InputChipMedgo(
                                    selectedChip: selectedRelation == 'father',
                                    title: 'Pai',
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          selectedRelation = 'father';
                                        }
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  InputChipMedgo(
                                    selectedChip: selectedRelation == 'mother',
                                    title: 'Mãe',
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          selectedRelation = 'mother';
                                        }
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  InputChipMedgo(
                                    selectedChip: selectedRelation == 'uncle',
                                    title: 'Tio/Tia',
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          selectedRelation = 'uncle';
                                        }
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  InputChipMedgo(
                                    selectedChip:
                                        selectedRelation == 'godfather',
                                    title: 'Padrinho',
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          selectedRelation = 'godfather';
                                        }
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  InputChipMedgo(
                                    selectedChip:
                                        selectedRelation == 'family_friend',
                                    title: 'Amigo',
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          selectedRelation = 'family_friend';
                                        }
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  InputChipMedgo(
                                    selectedChip: selectedRelation == 'other',
                                    title: 'Outro',
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          selectedRelation = 'other';
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.companion != null
                        ? CustomIconButtonMedGo(
                            onPressed: () {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Icon(
                                        PhosphorIcons.warning(
                                          PhosphorIconsStyle.bold,
                                        ),
                                        color: AppTheme.error,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        'Excluir ${widget.companion!.name}?',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  content: const Text(
                                      'Você deseja realmente excluir esse acompanhante?'),
                                  actions: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: OutlinePrimaryButton(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            title: 'Cancelar',
                                          ),
                                        ),
                                        const SizedBox(
                                            width:
                                                8), // Espaçamento entre os botões
                                        SizedBox(
                                          width: 120,
                                          child: PrimaryButton(
                                            onTap: () {
                                              deleteCompanion();
                                            },
                                            conteudo: const Text(
                                              'Confirmar',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: PhosphorIcon(
                              PhosphorIcons.trash(
                                PhosphorIconsStyle.bold,
                              ),
                              shadows: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 1.5,
                                  offset: const Offset(-0.25, 1),
                                ),
                              ],
                              color: AppTheme.error,
                            ),
                          )
                        : const SizedBox.shrink(),
                    Row(
                      children: [
                        PrimaryIconButtonMedGo(
                          leftIcon: PhosphorIcon(
                            PhosphorIcons.caretLeft(
                              PhosphorIconsStyle.bold,
                            ),
                            color: AppTheme.warning,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                          title: Strings.voltar,
                        ),
                        const SizedBox(width: 8.0),
                        TertiaryIconButtonMedGo(
                          rightIcon: PhosphorIcon(
                            PhosphorIcons.floppyDisk(
                              PhosphorIconsStyle.bold,
                            ),
                            color: AppTheme.success,
                          ),
                          onTap: () {
                            validarCampos();
                          },
                          title: widget.companion == null
                              ? Strings.cadastrar
                              : Strings.salvarAlteracoes,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _companionBloc.close();
  }
}
