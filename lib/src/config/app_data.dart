import 'package:flutter_application/src/models/user_model.dart';

/// Usuário atualmente logado no app. Pode ser null se não estiver logado.
UserModel? user;

/// Atualiza o usuário global (substitui por um novo)
void updateUser(UserModel newUser) {
  user = newUser;
}

/// Limpa os dados do usuário (ex: ao fazer logout)
void clearUser() {
  user = null;
}
