class User {
  final int? id;
  final String nome;
  final String email;
  final String senha;
  final String? imagemPerfil;
  final String role;

  User({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    this.imagemPerfil,
    this.role = 'buyer',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'imagemPerfil': imagemPerfil,
      'role': role,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      senha: map['senha'],
      imagemPerfil: map['imagemPerfil'],
      role: map['role'] ?? 'buyer',
    );
  }
}
