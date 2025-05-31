import 'package:flutter/material.dart';
import 'package:flutter_application/src/components/dados_user_dialog.dart';
import 'package:flutter_application/src/components/delete_account_dialog.dart';
import 'package:flutter_application/src/components/edit_profile_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.blueAccent),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: const [
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Presence +',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.black),
            title: const Text('Ver Perfil'),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => const DadosUserDialog(),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.black),
            title: const Text('Editar Perfil'),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => const EditProfileDialog(),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.black),
            title: const Text('Excluir Conta'),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => const DeleteAccountDialog(),
              );
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
