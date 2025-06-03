import 'package:flutter/material.dart';
import 'package:flutter_application/src/common_widgets/custom_text_fild.dart';
import 'package:flutter_application/src/config/app_data.dart' as appData;
import 'package:flutter_application/src/services/user_services.dart';
import 'package:get/get.dart';
import 'package:flutter_application/src/services/user_controller.dart';

class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({super.key});

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _isLoading = false;

  late String oldEmail;

  // Use o UserController para acessar o usuário
  final UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    final user = userController.user; // Mudança aqui!
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _passwordController = TextEditingController();
    oldEmail = user?.email ?? '';
    print('DEBUG OLD EMAIL initState: $oldEmail'); // Agora não fica mais vazio!
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final success = await UserService.updateUserProfile(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      oldEmail: oldEmail, // Aqui está OK!
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      if (appData.user != null) {
        appData.updateUser(
          appData.user!.copyWith(
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          ),
        );
      }
      if (mounted) Navigator.of(context).pop(true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil atualizado com sucesso')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao atualizar perfil')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Editar Perfil',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomTextFild(
                      controller: _nameController,
                      icon: Icons.person,
                      label: 'Nome',
                      validator:
                          (value) =>
                              (value == null || value.isEmpty)
                                  ? 'Informe seu nome'
                                  : null,
                    ),
                    CustomTextFild(
                      controller: _phoneController,
                      icon: Icons.phone,
                      label: 'Celular',
                      validator:
                          (value) =>
                              (value == null || value.isEmpty)
                                  ? 'Informe o número de celular'
                                  : null,
                    ),
                    CustomTextFild(
                      controller: _emailController,
                      icon: Icons.email,
                      label: 'Email',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe seu e-mail';
                        }
                        if (!value.contains('@')) {
                          return 'E-mail inválido';
                        }
                        return null;
                      },
                    ),
                    CustomTextFild(
                      controller: _passwordController,
                      icon: Icons.lock,
                      label: 'Senha',
                      isSecret: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe sua senha';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: _isLoading ? null : _saveProfile,
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text('Salvar Alterações'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed:
                  _isLoading ? null : () => Navigator.of(context).pop(false),
            ),
          ),
        ],
      ),
    );
  }
}
