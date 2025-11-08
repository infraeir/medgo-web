// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:medgo/helper/helper.dart';
import 'package:medgo/data/blocs/patients/patients_service_bloc.dart';
import 'package:medgo/data/blocs/patients/patients_service_event.dart';
import 'package:medgo/data/blocs/patients/patients_service_state.dart';
import 'package:medgo/data/models/patients_model.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/buttons/primary_icon_button.dart';
import 'package:medgo/widgets/news_widgets/buttons/tertiary_icon_button.dart';
import 'package:medgo/widgets/news_widgets/icon_button.dart';
import 'package:medgo/widgets/dialogs/loading_dialog.dart';
import 'package:medgo/widgets/news_widgets/input_chip.dart';
import 'package:medgo/widgets/news_widgets/input_icon_chip.dart';
import 'package:medgo/widgets/news_widgets/short_text_input.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'dart:ui';
import '../../../strings/strings.dart';

class CrudPatientModal extends StatefulWidget {
  final PatientsModel? patient;
  const CrudPatientModal({super.key, this.patient});

  @override
  State<CrudPatientModal> createState() => _CrudPatientModalState();
}

class _CrudPatientModalState extends State<CrudPatientModal> {
  String selectedSex = 'male';
  bool _isNameError = false;
  bool _isNascError = false;
  bool _isMotherNameError = false;
  bool _isFatherNameError = false;
  String _nascErrorMessage = '';
  String selectedChips = 'brown';
  TextEditingController nameController = TextEditingController();
  TextEditingController nascController = TextEditingController();
  TextEditingController nameMotherController = TextEditingController();
  TextEditingController nameFatherController = TextEditingController();
  MaskTextInputFormatter dateFormatter = MaskTextInputFormatter(
      mask: '##/##/####', filter: {'#': RegExp(r'[0-9]')});
  late final PatientsBloc _patientsBloc;

  @override
  void initState() {
    super.initState();
    _patientsBloc = GetIt.I<PatientsBloc>();
    if (widget.patient != null) {
      nameController.text = widget.patient!.name;
      nascController.text = Helper.convertToDate(widget.patient!.dateOfBirth);
      nameFatherController.text = widget.patient!.fatherName;
      nameMotherController.text = widget.patient!.motherName;
      selectedChips = widget.patient!.ethnicity;
      if (widget.patient!.gender == 'male') {
        selectedSex = 'male';
      } else {
        selectedSex = 'female';
      }
    }
    _listenEvents();
  }

  void _listenEvents() {
    _patientsBloc.stream.listen((state) {
      if (state is PatientsLoading) {
        shoLoadingDialog(context: context, barriedDismissible: false);
      }
      if (state is PatientsPosted) {
        Navigator.of(context).pop('true');
        Navigator.of(context).pop('true');
      } else if (state is PatientsPuted) {
        Navigator.of(context).pop('true');
        Navigator.of(context).pop('true');
      } else if (state is PatientDeleted) {
        Navigator.of(context).pop('true');
        Navigator.of(context).pop('true');
        Navigator.of(context).pop('true');
      }
    });
  }

  void cadastrarPatients() {
    _patientsBloc.add(
      PostPatients(
        cor: selectedChips,
        nome: nameController.text,
        nomeMae: nameMotherController.text,
        nomePai: nameFatherController.text,
        dataNasc: Helper.convertToISO8601(nascController.text),
        sexo: selectedSex,
      ),
    );
  }

  void editarPatients() {
    _patientsBloc.add(
      PutPatients(
        id: widget.patient!.id,
        cor: selectedChips,
        nome: nameController.text,
        nomeMae: nameMotherController.text,
        nomePai: nameFatherController.text,
        dataNasc: Helper.convertToISO8601(nascController.text),
        sexo: selectedSex,
      ),
    );
  }

  void deletarPatients() {
    _patientsBloc.add(
      DeletePatient(
        id: widget.patient!.id,
      ),
    );
  }

  void validarCampos() {
    bool hasError = false;

    if (nameController.text.isEmpty) {
      setState(() {
        _isNameError = true;
      });
      hasError = true;
    } else {
      setState(() {
        _isNameError = false;
      });
    }

    if (nascController.text.length < 10) {
      setState(() {
        _isNascError = true;
      });
      hasError = true;
    } else {
      setState(() {
        _isNascError = false;
      });
    }

    if (!hasError) {
      if (widget.patient == null) {
        cadastrarPatients();
      } else {
        editarPatients();
      }
    }
  }

  DateTime? _convertStringToDate(String value) {
    try {
      List<String> parts = value.split('/');
      if (parts.length == 3) {
        int day = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int year = int.parse(parts[2]);

        return DateTime(year, month, day);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 8,
            sigmaY: 8,
          ),
          child: GestureDetector(
            onTap: () {},
            child: Dialog(
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
                      color: Colors.black.withOpacity(0.1),
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
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${widget.patient != null ? 'Edição' : 'Cadastro'} de Paciente',
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
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nome do paciente',
                            style: TextStyle(
                              color: AppTheme.secondaryText,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                      ? 'O nome não pode ser vazio'
                                      : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Data de Nascimento',
                                      style: TextStyle(
                                        color: AppTheme.secondaryText,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    ShortTextInputMedgo(
                                      controller: nascController,
                                      hintText: Strings.dataHora,
                                      inputFormatters: [
                                        dateFormatter
                                      ], // Certifique-se de que o formato da data seja DD/MM/YYYY
                                      onChanged: (value) {
                                        // Verifica se o campo não está vazio e tem o formato correto de data
                                        if (value.isNotEmpty &&
                                            value.length == 10) {
                                          // Tenta converter a string para uma data
                                          DateTime? inputDate =
                                              _convertStringToDate(value);
                                          DateTime currentDate = DateTime.now();

                                          // Verifica se a data de nascimento é maior que a data atual
                                          if (inputDate != null &&
                                              inputDate.isAfter(currentDate)) {
                                            setState(() {
                                              _isNascError = true;
                                              _nascErrorMessage =
                                                  'A data de nascimento não pode ser maior que a data atual.';
                                            });
                                          } else {
                                            setState(() {
                                              _isNascError = false;
                                              _nascErrorMessage =
                                                  ''; // Remove a mensagem de erro
                                            });
                                          }
                                        } else {
                                          // Caso a data não tenha o formato completo ou esteja vazia
                                          setState(() {
                                            _isNascError = true;
                                            _nascErrorMessage =
                                                'Insira uma data válida no formato DD/MM/YYYY.';
                                          });
                                        }
                                      },
                                      errorText: _nascErrorMessage != ''
                                          ? _nascErrorMessage
                                          : null,
                                    ),
                                    // Exibe a mensagem de erro abaixo do campo, se houver erro
                                    if (_isNascError)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          _nascErrorMessage,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  margin: const EdgeInsets.only(left: 20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InputIconChipMedgo(
                                            icon: Icon(
                                              PhosphorIcons.genderFemale(
                                                PhosphorIconsStyle.bold,
                                              ),
                                              color: const Color(0xffAD00B1),
                                              size: 18,
                                            ),
                                            selectedChip:
                                                selectedSex == 'female',
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
                                            height: 5,
                                          ),
                                          InputIconChipMedgo(
                                            icon: Icon(
                                              PhosphorIcons.genderMale(
                                                PhosphorIconsStyle.bold,
                                              ),
                                              color: const Color(0xff003FBA),
                                              size: 18,
                                              shadows: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.50),
                                                  blurRadius: 1.5,
                                                  offset:
                                                      const Offset(-0.25, 1),
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
                                ),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Cor/Etnia',
                                            style: TextStyle(
                                              color: AppTheme.secondaryText,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InputChipMedgo(
                                            selectedChip:
                                                selectedChips == 'brown',
                                            title: 'Pardo',
                                            onSelected: (selected) {
                                              setState(() {
                                                if (selected) {
                                                  selectedChips = 'brown';
                                                }
                                              });
                                            },
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          InputChipMedgo(
                                            selectedChip:
                                                selectedChips == 'white',
                                            title: 'Branco',
                                            onSelected: (selected) {
                                              setState(() {
                                                if (selected) {
                                                  selectedChips = 'white';
                                                }
                                              });
                                            },
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          InputChipMedgo(
                                            selectedChip:
                                                selectedChips == 'black',
                                            title: 'Negro',
                                            onSelected: (selected) {
                                              setState(() {
                                                if (selected) {
                                                  selectedChips = 'black';
                                                }
                                              });
                                            },
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          InputChipMedgo(
                                            selectedChip:
                                                selectedChips == 'indigenous',
                                            title: 'Indígena',
                                            onSelected: (selected) {
                                              setState(() {
                                                if (selected) {
                                                  selectedChips = 'indigenous';
                                                }
                                              });
                                            },
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          InputChipMedgo(
                                            selectedChip:
                                                selectedChips == 'yellow',
                                            title: 'Amarelo',
                                            onSelected: (selected) {
                                              setState(() {
                                                if (selected) {
                                                  selectedChips = 'yellow';
                                                }
                                              });
                                            },
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          InputChipMedgo(
                                            selectedChip:
                                                selectedChips == 'other',
                                            title: 'Outro',
                                            onSelected: (selected) {
                                              setState(() {
                                                if (selected) {
                                                  selectedChips = 'other';
                                                }
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Filiação(mãe)',
                                      style: TextStyle(
                                        color: AppTheme.secondaryText,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                ShortTextInputMedgo(
                                  controller: nameMotherController,
                                  hintText: Strings.nomeMae,
                                  onChanged: (value) {
                                    setState(() {
                                      _isMotherNameError = value.isEmpty;
                                    });
                                  },
                                  errorText: _isMotherNameError
                                      ? 'Nome da mãe não pode ser vazio'
                                      : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Filiação(pai)',
                                      style: TextStyle(
                                        color: AppTheme.secondaryText,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                ShortTextInputMedgo(
                                  controller: nameFatherController,
                                  hintText: Strings.nomePai,
                                  onChanged: (value) {
                                    setState(() {
                                      _isFatherNameError = value.isEmpty;
                                    });
                                  },
                                  errorText: _isFatherNameError
                                      ? 'Nome da mãe não pode ser vazio'
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.patient != null
                            ? CustomIconButtonMedGo(
                                onPressed: () {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      backgroundColor: Colors.white,
                                      title: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
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
                                            'Excluir ${widget.patient!.name}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      content: const Text(
                                          'Você deseja realmente excluir esse paciente?'),
                                      actions: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: 100,
                                              child: PrimaryIconButtonMedGo(
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
                                              child: PrimaryIconButtonMedGo(
                                                onTap: () {
                                                  deletarPatients();
                                                },
                                                title: 'Confirmar',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: Icon(
                                  PhosphorIcons.trash(
                                    PhosphorIconsStyle.bold,
                                  ),
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
                              title: widget.patient == null
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
            ), // Fecha Container interno do Dialog
          ), // Fecha Dialog
        ), // Fecha GestureDetector interno
      ), // Fecha BackdropFilter
    ); // Fecha Container + GestureDetector externo
  }
}
