import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/usuario.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<Usuario?> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        return getUsuario(credential.user!.uid);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<Usuario?> register({
    required String email,
    required String password,
    required String nombre,
    required bool esAdmin,
    String nombreNegocio = '',
    String telefono = '',
    String ubicacionNegocio = '',
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final usuario = Usuario(
          id: credential.user!.uid,
          nombre: nombre,
          email: email,
          rol: esAdmin ? 'ADMIN' : 'CLIENTE',
          nombreNegocio: nombreNegocio,
          telefono: telefono,
          ubicacionNegocio: ubicacionNegocio,
          negocioId: esAdmin ? credential.user!.uid : '',
        );

        await _firestore
            .collection('usuarios')
            .doc(usuario.id)
            .set(usuario.toMap());
        
        return usuario;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<Usuario?> getUsuario(String uid) async {
    final doc = await _firestore.collection('usuarios').doc(uid).get();
    if (doc.exists) {
      return Usuario.fromMap(doc.data()!);
    }
    return null;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('usuarios').doc(user.uid).delete();
      await user.delete();
    }
  }
}
