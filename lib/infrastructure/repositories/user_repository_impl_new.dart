import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestore_service.dart';
import '../logging/logger_service.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuthService _firebaseAuthService;
  final FirestoreService _firestoreService;
  final LoggerService _logger = LoggerService();

  UserRepositoryImpl({
    required FirebaseAuthService firebaseAuthService,
    required FirestoreService firestoreService,
  })  : _firebaseAuthService = firebaseAuthService,
        _firestoreService = firestoreService;

  @override
  Future<String?> insertUser(User user) async {
    try {
      _logger.info('Inserindo usuário: ${user.email}');
      // Primeiro, registrar no Firebase Auth
      final userCredential = await _firebaseAuthService.registerUser(
        user.email,
        user.password,
      );

      // Depois, salvar dados adicionais no Firestore
      final userData = user.toMap();
      userData.remove('password'); // Não salvar senha no Firestore

      await _firestoreService.createUser(userCredential.user!.uid, userData);

      _logger.info('Usuário inserido com sucesso: ${userCredential.user!.uid}');
      return userCredential.user!.uid;
    } catch (e) {
      _logger.error('Erro ao inserir usuário: ${user.email}', e);
      return null;
    }
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    try {
      _logger.debug('Buscando usuário por email: $email');
      // Como o Firestore não permite busca por email diretamente,
      // precisamos buscar todos os usuários e filtrar
      // Em produção, considere usar uma coleção separada ou custom claims
      final usersSnapshot = await _firestoreService.firestore
          .collection(FirestoreService.usersCollection)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (usersSnapshot.docs.isNotEmpty) {
        final userData = usersSnapshot.docs.first.data();
        userData['id'] = usersSnapshot.docs.first.id;
        _logger.debug('Usuário encontrado: $email');
        return User.fromMap(userData);
      } else {
        _logger.debug('Usuário não encontrado: $email');
        return null;
      }
    } catch (e) {
      _logger.error('Erro ao buscar usuário por email: $email', e);
      return null;
    }
  }

  @override
  Future<bool> updateUser(User user) async {
    try {
      _logger.info('Atualizando usuário: ${user.id}');
      final userData = user.toMap();
      userData.remove('password'); // Não atualizar senha aqui

      await _firestoreService.updateUser(user.id!, userData);
      _logger.info('Usuário atualizado com sucesso: ${user.id}');
      return true;
    } catch (e) {
      _logger.error('Erro ao atualizar usuário: ${user.id}', e);
      return false;
    }
  }

  @override
  Future<bool> deleteUser(String id) async {
    try {
      _logger.info('Deletando usuário: $id');
      await _firestoreService.deleteUser(id);
      // Também deletar da autenticação se necessário
      await _firebaseAuthService.deleteAccount();
      _logger.info('Usuário deletado com sucesso: $id');
      return true;
    } catch (e) {
      _logger.error('Erro ao deletar usuário: $id', e);
      return false;
    }
  }

  // Métodos adicionais para autenticação
  @override
  Future<firebase_auth.UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      _logger.info('Fazendo login: $email');
      final result = await _firebaseAuthService.signInUser(email, password);
      _logger.info('Login realizado com sucesso: $email');
      return result;
    } catch (e) {
      _logger.error('Erro no login: $email', e);
      return null;
    }
  }

  @override
  Future<firebase_auth.UserCredential?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      _logger.info('Criando usuário: $email');
      final result = await _firebaseAuthService.registerUser(email, password);
      _logger.info('Usuário criado com sucesso: $email');
      return result;
    } catch (e) {
      _logger.error('Erro ao criar usuário: $email', e);
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      _logger.info('Fazendo logout');
      await _firebaseAuthService.signOut();
      _logger.info('Logout realizado com sucesso');
    } catch (e) {
      _logger.error('Erro no logout', e);
    }
  }

  @override
  firebase_auth.User? get currentUser => _firebaseAuthService.currentUser;
}
