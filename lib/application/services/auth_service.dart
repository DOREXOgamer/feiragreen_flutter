class AuthService {
  bool validateEmail(String email) {
    final emailRegex = RegExp(r"^[\w\.+-]+@[\w\.-]+\.[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(email);
  }
}

