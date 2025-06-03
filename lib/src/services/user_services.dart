import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application/src/models/user_model.dart';

class UserService {
  static const String baseUrl =
      'http://10.0.2.2:3000'; // Troque pela sua URL real

  /// Busca os dados do perfil do usuário na API
  static Future<UserModel?> fetchUserProfile() async {
    final url = Uri.parse('$baseUrl/user/profile');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer seu_token_aqui', // se precisar autenticação
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        print('Erro ao buscar perfil: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception fetchUserProfile: $e');
      return null;
    }
  }

  /// Atualiza o perfil do usuário (nome, telefone e email)
  static Future<bool> updateUserProfile({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String oldEmail,
  }) async {
    final url = Uri.parse('http://192.168.0.10:3000/atualizar');

    try {
      print('DEBUG OLD EMAIL: $oldEmail');
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer seu_token_aqui', // se precisar autenticação
        },
        body: jsonEncode({
          'nome': name,
          'celular': phone,
          'novo_email': email,
          'senha': password, // Incluindo senha para confirmação
          'email': oldEmail,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Erro ao atualizar perfil: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception updateUserProfile: $e');
      return false;
    }
  }

  /// Exclui a conta do usuário mediante confirmação de senha
  static Future<bool> deleteAccount({
    required String email, // <- Adicione o email aqui
    required String password,
  }) async {
    final url = Uri.parse('http://192.168.0.10:3000/deletar');

    print('DEBUG EMAIL PARA DELETAR: $email');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        // Envie também a senha se quiser validar na API
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Erro ao excluir conta: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception deleteAccount: $e');
      return false;
    }
  }
}
