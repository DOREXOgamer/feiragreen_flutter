import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

/**
 * Implementação do repositório de usuários usando Firebase.
 * 
 * Esta classe implementa a interface IUserRepository definida na camada de domínio,
 * fornecendo a implementação concreta usando o Firebase Firestore e Authentication.
 */
class FirebaseUserRepository implements IUserRepository {
  final FirebaseFirestore _firestore;
  final fb_auth.FirebaseAuth _auth;

  /**
   * Construtor que recebe as instâncias do Firestore e Authentication.
   * 
   * Permite a injeção de dependências para facilitar testes.
   */
  FirebaseUserRepository({
    FirebaseFirestore? firestore,
    fb_auth.FirebaseAuth? auth,
  }) : 
    _firestore = firestore ?? FirebaseFirestore.instance,
    _auth = auth ?? fb_auth.FirebaseAuth.instance;

  /**
   * Referência à coleção de usuários no Firestore.
   */
  CollectionReference get _users => _firestore.collection('users');

  @override
  Future<void> setUser(User user) async {
    final docRef = _users.doc(user.id?.toString() ?? _auth.currentUser?.uid);
    await docRef.set(user.toMap(), SetOptions(merge: true));
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    final querySnapshot = await _users.where('email', isEqualTo: email).get();
    if (querySnapshot.docs.isNotEmpty) {
      return User.fromMap(querySnapshot.docs.first.data() as Map<String, dynamic>);
    }
    return null;
  }

  @override
  Future<User?> getUserById(String id) async {
    try {
      final docSnapshot = await _users.doc(id).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data is Map<String, dynamic>) {
          return User.fromMap(data);
        } else {
          throw Exception('Dados do usuário não estão no formato esperado: ${data.runtimeType}');
        }
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao buscar usuário: $e');
    }
  }
}