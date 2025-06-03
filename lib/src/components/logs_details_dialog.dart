import 'package:flutter/material.dart';

class LogDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> log;

  const LogDetailsDialog({super.key, required this.log});

  String _formatarData(dynamic data) {
    if (data == null) return 'Não informado';
    final str = data.toString();
    try {
      final dt = DateTime.tryParse(str);
      if (dt != null) {
        return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
      }
      // Formatos do tipo "2024-06-12 14:51:00"
      final apenasData = RegExp(r'(\d{4})-(\d{2})-(\d{2})');
      final match = apenasData.firstMatch(str);
      if (match != null) {
        return '${match.group(3)}/${match.group(2)}/${match.group(1)}';
      }
    } catch (_) {}
    return 'Não informado';
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> acaoMap = {
      'I': 'inseriu',
      'A': 'editou',
      'E': 'excluiu',
    };

    final String acaoCodigo =
        (log['tipo_acao'] ?? log['acao'] ?? '').toString().toUpperCase();
    final String acao = acaoMap[acaoCodigo] ?? acaoCodigo;
    final String usuario =
        (log['nome_usuario'] ?? log['usuario'] ?? 'Não informado').toString();

    IconData icone;
    Color cor;

    switch (acao) {
      case 'inseriu':
        icone = Icons.add_circle_outline;
        cor = Colors.green;
        break;
      case 'editou':
        icone = Icons.edit;
        cor = Colors.amber[800]!;
        break;
      case 'excluiu':
        icone = Icons.delete_outline;
        cor = Colors.red;
        break;
      default:
        icone = Icons.info_outline;
        cor = Colors.blueGrey;
    }

    Widget infoRow(String label, dynamic value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                value != null && value.toString().trim().isNotEmpty
                    ? value.toString()
                    : 'Não informado',
                style: const TextStyle(color: Colors.black54),
              ),
            ),
          ],
        ),
      );
    }

    return AlertDialog(
      title: Row(
        children: [
          Icon(icone, color: cor, size: 30),
          const SizedBox(width: 10),
          Text(
            'Detalhes da Ação',
            style: TextStyle(color: cor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          infoRow('ID do Log:', log['id_log']),
          infoRow('Usuário:', usuario),
          infoRow('Ação:', acao),
          infoRow(
            'Data/Hora:',
            _formatarData(
              log['data_hora'] ??
                  log['data'] ??
                  log['created_at'] ??
                  log['hora'],
            ),
          ),
          if (acao == 'editou') ...[
            Divider(),
            infoRow('Campo Editado:', log['campo_editado']),
            infoRow('Valor Antigo:', log['valor_antigo']),
            infoRow('Valor Novo:', log['valor_novo']),
          ],
          if (acao == 'excluiu') ...[
            Divider(),
            infoRow('Item Excluído:', log['valor_antigo']),
          ],
          if (acao == 'inseriu') ...[
            Divider(),
            Center(child: Text('Registro inserido com sucesso!')),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
