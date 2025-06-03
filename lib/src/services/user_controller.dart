import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/user_services.dart';

class UserController extends GetxController {
  final Rxn<UserModel> _user = Rxn<UserModel>();

  UserModel? get user => _user.value;
  bool get isLogged => _user.value != null;

  final RxBool isLoading = false.obs;

  void setUser(UserModel user) {
    _user.value = user;
  }

  void logout() {
    _user.value = null;
  }

  Future<bool> updateUserProfile({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String oldEmail,
  }) async {
    isLoading.value = true;

    final success = await UserService.updateUserProfile(
      name: name,
      phone: phone,
      email: email,
      password: password,
      oldEmail: oldEmail,
    );

    if (success && _user.value != null) {
      _user.value = _user.value!.copyWith(
        name: name,
        phone: phone,
        email: email,
        password: password,
      );
    }

    isLoading.value = false;
    return success;
  }
}
