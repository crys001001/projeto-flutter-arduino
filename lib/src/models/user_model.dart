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
      name: json['name'] ?? json['nome'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? json['celular'] ?? '',
      cpf: json['cpf'] ?? '',
      password: json['password'] ?? json['senha'] ?? '',
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

  // Adicionado: Método copyWith
  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? cpf,
    String? password,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      cpf: cpf ?? this.cpf,
      password: password ?? this.password,
    );
  }
}
