import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../entities/user.dart';

abstract class UserRepository {
  Future<String?> insertUser(User user);
  Future<User?> getUserByEmail(String email);
  Future<bool> updateUser(User user);
  Future<bool> deleteUser(String id);
  Future<firebase_auth.UserCredential?> signInWithEmailAndPassword(
      String email, String password);
  Future<firebase_auth.UserCredential?> createUserWithEmailAndPassword(
      String email, String password);
  Future<void> signOut();
  firebase_auth.User? get currentUser;
}
