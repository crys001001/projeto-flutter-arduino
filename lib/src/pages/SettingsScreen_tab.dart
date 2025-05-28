import 'package:flutter/material.dart';
import 'package:flutter_application/src/common_widgets/custom_text_fild.dart';
import 'package:flutter_application/src/services/user_services.dart';
import '../config/app_data.dart' as appData;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Cabeçalho azul
          Container(
            decoration: const BoxDecoration(color: Colors.blueAccent),
            padding: const EdgeInsets.all(11),
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

          // Editar Perfil
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.black),
            title: const Text(
              'Editar Perfil',
              style: TextStyle(color: Colors.black),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
            onTap: () => _showEditProfileDialog(context),
          ),
          const Divider(),

          // Excluir Conta
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.black),
            title: const Text(
              'Excluir Conta',
              style: TextStyle(color: Colors.black),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
            onTap: () => _showDeleteAccountDialog(context),
          ),
          const Divider(),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final nameController = TextEditingController(text: appData.user.name);
    final phoneController = TextEditingController(text: appData.user.phone);
    final emailController = TextEditingController(text: appData.user.email);
    final formKey = GlobalKey<FormState>();

    showDialog<bool>(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: formKey,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Editar Perfil',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        CustomTextFild(
                          controller: nameController,
                          icon: Icons.person,
                          label: 'Nome',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Informe seu nome';
                            }
                            return null;
                          },
                        ),
                        CustomTextFild(
                          controller: phoneController,
                          icon: Icons.phone,
                          label: 'Celular',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Informe o número de celular';
                            }
                            return null;
                          },
                        ),
                        CustomTextFild(
                          controller: emailController,
                          icon: Icons.email,
                          label: 'Email',
                          readOnly: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Informe seu e-mail';
                            }
                            if (!value.contains('@')) return 'E-mail inválido';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 45,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                final success =
                                    await UserService.updateUserProfile(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      cpf: appData.user.cpf, // CPF fixo
                                    );
                                if (success) {
                                  appData.user.name = nameController.text;
                                  appData.user.phone = phoneController.text;

                                  Navigator.of(ctx).pop(true);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Perfil atualizado com sucesso',
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Erro ao atualizar perfil'),
                                    ),
                                  );
                                }
                              }
                            },
                            child: const Text('Salvar Alterações'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(ctx).pop(false),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog<bool>(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: formKey,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),
                      const Text(
                        'Excluir Conta',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Para confirmar, digite sua senha:',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      CustomTextFild(
                        controller: passwordController,
                        isSecret: true,
                        icon: Icons.lock,
                        label: 'Senha',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira a senha';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              final success = await UserService.deleteAccount(
                                password: passwordController.text,
                              );

                              if (success) {
                                Navigator.of(ctx).pop(true);

                                // Redireciona para tela inicial/login
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/login',
                                  (route) => false,
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Conta excluída com sucesso'),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(ctx).showSnackBar(
                                  const SnackBar(
                                    content: Text('Erro ao excluir a conta'),
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text('Excluir Conta'),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(ctx).pop(false),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
