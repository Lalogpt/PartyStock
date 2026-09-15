import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/models/usuario.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  Usuario? _usuario;
  bool _isLoading = false;

  Usuario? get usuario => _usuario;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _usuario != null;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();
    
    final currentUser = _authRepository.currentUser;
    if (currentUser != null) {
      _usuario = await _authRepository.getUsuario(currentUser.uid);
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      _usuario = await _authRepository.login(email, password);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> register({
    required String email,
    required String password,
    required String nombre,
    required bool esAdmin,
    String nombreNegocio = '',
    String telefono = '',
    String ubicacionNegocio = '',
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      _usuario = await _authRepository.register(
        email: email,
        password: password,
        nombre: nombre,
        esAdmin: esAdmin,
        nombreNegocio: nombreNegocio,
        telefono: telefono,
        ubicacionNegocio: ubicacionNegocio,
      );
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _usuario = null;
    notifyListeners();
  }
}
