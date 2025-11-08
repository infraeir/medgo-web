// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:medgo/themes/app_theme.dart';
import 'package:medgo/widgets/news_widgets/buttons/primary_icon_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LocalAtendimentoCard extends StatelessWidget {
  final Map<String, dynamic> localData;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const LocalAtendimentoCard({
    super.key,
    required this.localData,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.softBlue,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      localData['nome'] ?? 'Sem nome',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryText,
                      ),
                    ),
                    Text(
                      ' - CNES: ${localData['cnes'] ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryText,
                      ),
                    ),
                    if (localData['contexto'] != null)
                      Text(
                        ' - ${localData['contexto']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryText,
                        ),
                      ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Endereço: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryText,
                      ),
                    ),
                    if (_hasAddress())
                      Text(
                        _getFullAddress(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryText,
                        ),
                      ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Contato: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryText,
                      ),
                    ),
                    // Telefone
                    if (localData['telefone'] != null &&
                        localData['telefone'].toString().isNotEmpty) ...[
                      Text(
                        localData['telefone'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryText,
                        ),
                      ),
                    ],
                    if (localData['email'] != null &&
                        localData['email'].toString().isNotEmpty) ...[
                      Text(
                        localData['email'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryText,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              PrimaryIconButtonMedGo(
                leftIcon: Icon(
                  size: 20,
                  PhosphorIcons.pencilSimple(
                    PhosphorIconsStyle.regular,
                  ),
                ),
                onTap: onEdit,
              ),
              const SizedBox(height: 8),
              PrimaryIconButtonMedGo(
                size: 20,
                leftIcon: Icon(
                  color: AppTheme.error,
                  PhosphorIcons.trash(
                    PhosphorIconsStyle.regular,
                  ),
                ),
                onTap: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _hasAddress() {
    return (localData['cep'] != null &&
            localData['cep'].toString().isNotEmpty) ||
        (localData['logradouro'] != null &&
            localData['logradouro'].toString().isNotEmpty) ||
        (localData['cidade'] != null &&
            localData['cidade'].toString().isNotEmpty);
  }

  String _getFullAddress() {
    List<String> parts = [];

    if (localData['logradouro'] != null &&
        localData['logradouro'].toString().isNotEmpty) {
      String logradouro = localData['logradouro'];
      if (localData['numero'] != null &&
          localData['numero'].toString().isNotEmpty) {
        logradouro += ', ${localData['numero']}';
      }
      parts.add(logradouro);
    }

    if (localData['complemento'] != null &&
        localData['complemento'].toString().isNotEmpty) {
      parts.add(localData['complemento']);
    }

    if (localData['bairro'] != null &&
        localData['bairro'].toString().isNotEmpty) {
      parts.add(localData['bairro']);
    }

    if (localData['cidade'] != null &&
        localData['cidade'].toString().isNotEmpty) {
      String cidade = localData['cidade'];
      if (localData['uf'] != null && localData['uf'].toString().isNotEmpty) {
        cidade += ' - ${localData['uf']}';
      }
      parts.add(cidade);
    }

    if (localData['cep'] != null && localData['cep'].toString().isNotEmpty) {
      parts.add('CEP: ${localData['cep']}');
    }

    return parts.join(' • ');
  }
}
