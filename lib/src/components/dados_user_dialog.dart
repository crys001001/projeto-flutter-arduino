import 'package:flutter/material.dart';
import 'package:flutter_application/src/config/app_data.dart' as appData;
import 'package:flutter_application/src/components/edit_profile_dialog.dart';

class DadosUserDialog extends StatelessWidget {
  const DadosUserDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final user = appData.user;

    return AlertDialog(
      title: const Text('Dados do Usuário'),
      content:
          user == null
              ? const Text('Nenhum usuário logado.')
              : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nome: ${user.name}'),
                  const SizedBox(height: 8),
                  Text('Celular: ${user.phone}'),
                  const SizedBox(height: 8),
                  Text('Email: ${user.email}'),
                ],
              ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Fecha o dialog de dados
            showDialog(
              context: context,
              builder: (_) => const EditProfileDialog(),
            );
          },
          child: const Text('Editar Perfil'),
        ),
      ],
    );
  }
}
