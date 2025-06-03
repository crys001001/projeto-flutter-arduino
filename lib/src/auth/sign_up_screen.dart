import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/common_widgets/custom_text_fild.dart';
import 'package:flutter_application/src/models/user_model.dart';
import 'package:flutter_application/src/pages_routes/app_pages.dart';
import 'package:flutter_application/src/services/user_controller.dart';
import 'package:flutter_application/src/services/validators.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final cpffomartter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp(r'[0-9]')},
  );

  final phoneFormatter = MaskTextInputFormatter(
    mask: '## # ####-####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final cpfController = TextEditingController();

  final UserController userController = Get.find<UserController>();

  bool isLoading = false;

  Future<void> signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('http://192.168.0.10:3000/cadastrar');
    final body = {
      'nome': nameController.text.trim(),
      'email': emailController.text.trim(),
      'celular': phoneController.text.trim(),
      'cpf': cpfController.text.trim(),
      'senha': passwordController.text.trim(),
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('Resposta do backend: ${response.body}'); // Para debug

      if (response.statusCode == 201) {
        // Atualiza o usuário no UserController
        userController.setUser(
          UserModel(
            name: nameController.text.trim(),
            email: emailController.text.trim(),
            phone: phoneController.text.trim(),
            cpf: cpfController.text.trim(),
            password: passwordController.text.trim(),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário cadastrado com sucesso!')),
        );

        Get.offAllNamed(PagesRoutes.BaseRoute);
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ?? 'Erro ao cadastrar usuário';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro na conexão: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    cpfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(fontSize: 50),
                    children: [
                      const TextSpan(
                        text: 'Presence',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text: ' +',
                        style: TextStyle(color: Colors.red),
                      ),
                      TextSpan(
                        text: '\nCrie sua conta',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 24,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextFild(
                          controller: nameController,
                          icon: Icons.person,
                          label: 'Nome',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Informe o nome';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        CustomTextFild(
                          controller: emailController,
                          icon: Icons.email,
                          label: 'Email',
                          validator: emailValidator,
                          textInputType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12),
                        CustomTextFild(
                          controller: phoneController,
                          icon: Icons.phone,
                          label: 'Telefone',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Informe o telefone';
                            }
                            if (!RegExp(
                              r'^\d{2} \d \d{4}-\d{4}$',
                            ).hasMatch(value)) {
                              return 'Telefone inválido';
                            }
                            return null;
                          },
                          inputFormatters: [phoneFormatter],
                          textInputType: TextInputType.phone,
                        ),
                        const SizedBox(height: 12),
                        CustomTextFild(
                          controller: cpfController,
                          icon: Icons.assignment_ind,
                          label: 'CPF',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Informe o CPF';
                            }
                            if (!RegExp(
                              r'^\d{3}\.\d{3}\.\d{3}-\d{2}$',
                            ).hasMatch(value)) {
                              return 'CPF inválido';
                            }
                            return null;
                          },
                          inputFormatters: [cpffomartter],
                          textInputType: TextInputType.number,
                        ),
                        const SizedBox(height: 12),
                        CustomTextFild(
                          controller: passwordController,
                          icon: Icons.lock,
                          label: 'Senha',
                          isSecret: true,
                          validator: passwordValidator,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            onPressed: isLoading ? null : signUp,
                            child:
                                isLoading
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : const Text(
                                      'Criar Conta',
                                      style: TextStyle(fontSize: 18),
                                    ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text(
                            'Já tenho conta',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                      ],
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
