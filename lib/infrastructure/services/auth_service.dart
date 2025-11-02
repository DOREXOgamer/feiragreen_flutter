class AuthService {
  bool validateEmail(String email) {
    // Validação simples: deve conter '@' e ter pelo menos um '.' após o '@'
    if (email.isEmpty || !email.contains('@')) {
      return false;
    }
    final atIndex = email.indexOf('@');
    final dotIndex = email.lastIndexOf('.');
    return dotIndex > atIndex && dotIndex < email.length - 1;
  }
}
