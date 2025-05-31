import 'package:get/get.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  // Rxn para usuário que pode ser nulo inicialmente
  final Rxn<UserModel> _user = Rxn<UserModel>();

  // Getter para o usuário atual (pode ser nulo)
  UserModel? get user => _user.value;

  // Verifica se usuário está logado
  bool get isLogged => _user.value != null;

  // Define/atualiza o usuário
  void setUser(UserModel user) {
    _user.value = user;
  }

  // Limpa o usuário (logout)
  void logout() {
    _user.value = null;
  }
}
