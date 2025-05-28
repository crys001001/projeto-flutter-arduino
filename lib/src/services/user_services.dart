import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_data.dart' as appData;

class UserService {
  static const String baseUrl = 'https://suaapi.com'; // Troque pela URL real

  static Future<bool> updateUserProfile({
    required String name,
    required String phone,
    required String cpf,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/update'), // Endpoint real aqui
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer SEU_TOKEN_AQUI', // Coloque seu token aqui, se necessário
        },
        body: jsonEncode({
          'email': appData.user.email, // chave identificadora
          'name': name,
          'phone': phone,
          'cpf': cpf,
        }),
      );

      if (response.statusCode == 200) {
        // Atualiza localmente também
        appData.user.name = name;
        appData.user.phone = phone;
        appData.user.cpf = cpf;
        return true;
      } else {
        print('Erro ao atualizar perfil: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro de conexão: $e');
      return false;
    }
  }

  static deleteAccount({required String password}) {}
}
