class UserModel {
  final String name;
  final String email;
  final String phone;
  final String cpf;
  final String password;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.cpf,
    required this.password,
  });

  // Cria uma instância a partir de um JSON (mapa)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      cpf: json['cpf'] ?? '',
      password: json['password'] ?? '',
    );
  }

  // Converte o usuário para JSON (mapa)
  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'cpf': cpf,
    'password': password,
  };
}
