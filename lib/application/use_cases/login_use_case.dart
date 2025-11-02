import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

class LoginUseCase {
  final UserRepository userRepository;

  LoginUseCase(this.userRepository);

  Future<User?> execute(String email, String password) async {
    final user = await userRepository.getUserByEmail(email);
    if (user != null && user.senha == password) {
      return user;
    }
    return null;
  }
}
