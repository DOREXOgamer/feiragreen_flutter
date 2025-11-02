import 'package:feiragreen_flutter/domain/entities/user.dart';

abstract class UserRepository {
  Future<void> setUser(User user);
  Future<User?> getUserByEmail(String email);
}
