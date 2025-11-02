import 'package:firebase_auth/firebase_auth.dart';
import 'package:feiragreen_flutter/infrastructure/logging/logger_service.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth;
  final LoggerService _logger = LoggerService();

  FirebaseAuthService({FirebaseAuth? firebaseAuth})
      : _auth = firebaseAuth ?? FirebaseAuth.instance;

  // Stream para monitorar mudanças no estado de autenticação
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Obter usuário atual
  User? get currentUser => _auth.currentUser;

  // Registrar novo usuário
  Future<UserCredential> registerUser(String email, String password) async {
    try {
      _logger.info('Tentando registrar usuário: $email');
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _logger
          .info('Usuário registrado com sucesso: ${userCredential.user?.uid}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      _logger.error('Erro ao registrar usuário: ${e.message}', e);
      throw _handleAuthException(e);
    } catch (e) {
      _logger.error('Erro inesperado ao registrar usuário', e);
      throw Exception('Erro inesperado ao registrar usuário');
    }
  }

  // Fazer login
  Future<UserCredential> signInUser(String email, String password) async {
    try {
      _logger.info('Tentando fazer login: $email');
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _logger.info('Login realizado com sucesso: ${userCredential.user?.uid}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      _logger.error('Erro ao fazer login: ${e.message}', e);
      throw _handleAuthException(e);
    } catch (e) {
      _logger.error('Erro inesperado ao fazer login', e);
      throw Exception('Erro inesperado ao fazer login');
    }
  }

  // Fazer logout
  Future<void> signOut() async {
    try {
      _logger.info('Fazendo logout do usuário: ${_auth.currentUser?.uid}');
      await _auth.signOut();
      _logger.info('Logout realizado com sucesso');
    } catch (e) {
      _logger.error('Erro ao fazer logout', e);
      throw Exception('Erro ao fazer logout');
    }
  }

  // Resetar senha
  Future<void> resetPassword(String email) async {
    try {
      _logger.info('Enviando email de reset de senha para: $email');
      await _auth.sendPasswordResetEmail(email: email);
      _logger.info('Email de reset enviado com sucesso');
    } on FirebaseAuthException catch (e) {
      _logger.error('Erro ao enviar email de reset: ${e.message}', e);
      throw _handleAuthException(e);
    } catch (e) {
      _logger.error('Erro inesperado ao enviar email de reset', e);
      throw Exception('Erro inesperado ao enviar email de reset');
    }
  }

  // Atualizar email
  Future<void> updateEmail(String newEmail) async {
    try {
      _logger.info('Atualizando email do usuário: ${_auth.currentUser?.uid}');
      await _auth.currentUser?.verifyBeforeUpdateEmail(newEmail);
      _logger.info('Email atualizado com sucesso');
    } on FirebaseAuthException catch (e) {
      _logger.error('Erro ao atualizar email: ${e.message}', e);
      throw _handleAuthException(e);
    } catch (e) {
      _logger.error('Erro inesperado ao atualizar email', e);
      throw Exception('Erro inesperado ao atualizar email');
    }
  }

  // Atualizar senha
  Future<void> updatePassword(String newPassword) async {
    try {
      _logger.info('Atualizando senha do usuário: ${_auth.currentUser?.uid}');
      await _auth.currentUser?.updatePassword(newPassword);
      _logger.info('Senha atualizada com sucesso');
    } on FirebaseAuthException catch (e) {
      _logger.error('Erro ao atualizar senha: ${e.message}', e);
      throw _handleAuthException(e);
    } catch (e) {
      _logger.error('Erro inesperado ao atualizar senha', e);
      throw Exception('Erro inesperado ao atualizar senha');
    }
  }

  // Deletar conta
  Future<void> deleteAccount() async {
    try {
      _logger.info('Deletando conta do usuário: ${_auth.currentUser?.uid}');
      await _auth.currentUser?.delete();
      _logger.info('Conta deletada com sucesso');
    } on FirebaseAuthException catch (e) {
      _logger.error('Erro ao deletar conta: ${e.message}', e);
      throw _handleAuthException(e);
    } catch (e) {
      _logger.error('Erro inesperado ao deletar conta', e);
      throw Exception('Erro inesperado ao deletar conta');
    }
  }

  // Reautenticar usuário (necessário para operações sensíveis)
  Future<void> reauthenticateUser(String email, String password) async {
    try {
      _logger.info('Reautenticando usuário: ${_auth.currentUser?.uid}');
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await _auth.currentUser?.reauthenticateWithCredential(credential);
      _logger.info('Reautenticação realizada com sucesso');
    } on FirebaseAuthException catch (e) {
      _logger.error('Erro na reautenticação: ${e.message}', e);
      throw _handleAuthException(e);
    } catch (e) {
      _logger.error('Erro inesperado na reautenticação', e);
      throw Exception('Erro inesperado na reautenticação');
    }
  }

  // Método auxiliar para tratar exceções do Firebase Auth
  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return Exception('Este email já está sendo usado por outra conta.');
      case 'weak-password':
        return Exception('A senha é muito fraca. Use pelo menos 6 caracteres.');
      case 'invalid-email':
        return Exception('O email fornecido é inválido.');
      case 'user-not-found':
        return Exception('Usuário não encontrado. Verifique o email.');
      case 'wrong-password':
        return Exception('Senha incorreta.');
      case 'user-disabled':
        return Exception('Esta conta foi desabilitada.');
      case 'too-many-requests':
        return Exception('Muitas tentativas. Tente novamente mais tarde.');
      case 'requires-recent-login':
        return Exception('Esta operação requer reautenticação recente.');
      default:
        return Exception('Erro de autenticação: ${e.message}');
    }
  }
}
