import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/common_widgets/custom_text_fild.dart';
import 'package:flutter_application/src/components/admin_access_dialog.dart';
import 'package:flutter_application/src/config/app_data.dart' as appData;
import 'package:flutter_application/src/models/user_model.dart';
import 'package:flutter_application/src/pages_routes/app_pages.dart';
import 'package:flutter_application/src/services/user_controller.dart';
import 'package:flutter_application/src/services/validators.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final UserController userController = Get.find<UserController>();

  bool isLoading = false;

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('http://192.168.0.10:3000/logar');
    final body = {
      'email': emailController.text.trim(),
      'senha': passwordController.text.trim(),
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print('DEBUG LOGIN: $data'); // Veja a resposta no console!

        // Agora pegue o usuário dentro da chave "dados":
        final userJson = data['dados'];
        final user = UserModel.fromJson(userJson);
        userController.setUser(user);
        appData.user = user; // ou appData.updateUser(user);

        userController.setUser(UserModel.fromJson(userJson));
        print('DEBUG USER APÓS LOGIN: ${userController.user}');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login realizado com sucesso!')),
        );

        Get.offAllNamed(PagesRoutes.BaseRoute);
      } else {
        final errorMessage =
            jsonDecode(
              response.body,
            )['mensagem'] ?? // se backend usa "mensagem"
            jsonDecode(response.body)['erro'] ?? // se backend usa "erro"
            'Erro ao fazer login';
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text.rich(
                      TextSpan(
                        style: TextStyle(fontSize: 50),
                        children: [
                          TextSpan(
                            text: 'Presence',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' +',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      height: 30,
                      child: DefaultTextStyle(
                        style: const TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                        child: AnimatedTextKit(
                          pause: Duration.zero,
                          repeatForever: true,
                          animatedTexts: [
                            FadeAnimatedText('Detecção de Movimento'),
                            FadeAnimatedText('App inteligente'),
                            FadeAnimatedText('Sensor de Presença'),
                            FadeAnimatedText('Mais segurança'),
                            FadeAnimatedText('Ultra Rápido'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 24,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(45),
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                CustomTextFild(
                                  controller: emailController,
                                  icon: Icons.email,
                                  label: 'Email',
                                  validator: emailValidator,
                                  textInputType: TextInputType.emailAddress,
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
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.blueAccent,
                                      side: const BorderSide(
                                        color: Colors.blueAccent,
                                        width: 2.3,
                                      ),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                    onPressed: isLoading ? null : login,
                                    child:
                                        isLoading
                                            ? const CircularProgressIndicator(
                                              color: Colors.blueAccent,
                                            )
                                            : const Text(
                                              'Acessar',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: Colors.grey.withAlpha(90),
                                        thickness: 3,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      child: Text('ou'),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: Colors.grey.withAlpha(90),
                                        thickness: 3,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
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
                                    onPressed: () {
                                      Get.toNamed(PagesRoutes.signUpRoute);
                                    },
                                    child: const Text(
                                      'Criar conta',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
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
                                    onPressed: () async {
                                      final result = await showDialog<bool>(
                                        context: context,
                                        builder:
                                            (_) => const AdminAccessDialog(),
                                      );
                                      if (result == true) {
                                        Get.toNamed(PagesRoutes.auditRoute);
                                      }
                                    },
                                    child: const Text(
                                      'Admin',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
