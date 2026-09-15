import 'package:flutter/material.dart';
import '../../data/repositories/reserva_repository.dart';
import '../../domain/models/reserva.dart';

class ReservaProvider extends ChangeNotifier {
  final ReservaRepository _reservaRepository = ReservaRepository();
  
  List<Reserva> _reservas = [];
  bool _isLoading = false;

  List<Reserva> get reservas => _reservas;
  bool get isLoading => _isLoading;

  Future<void> fetchReservasByUsuario(String usuarioId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _reservas = await _reservaRepository.getReservasByUsuario(usuarioId);
    } catch (e) {
      print('Error fetching reservas by usuario: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchReservasByNegocio(String negocioId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _reservas = await _reservaRepository.getReservasByNegocio(negocioId);
    } catch (e) {
      print('Error fetching reservas by negocio: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createReserva(Reserva reserva) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _reservaRepository.addReserva(reserva);
      // We might not want to fetch all here, but maybe update current list if applicable
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateReservaEstado(Reserva reserva, String nuevoEstado) async {
    _isLoading = true;
    notifyListeners();
    try {
      final updatedReserva = reserva.copyWith(estado: nuevoEstado);
      await _reservaRepository.updateReserva(updatedReserva);
      
      final index = _reservas.indexWhere((r) => r.id == reserva.id);
      if (index != -1) {
        _reservas[index] = updatedReserva;
      }
    } catch (e) {
      print('Error updating reserva: $e');
    }
    _isLoading = false;
    notifyListeners();
  }
  
  Future<int> checkStock(String muebleId, DateTime start, DateTime end) async {
    return await _reservaRepository.getOccupiedStock(
      muebleId, 
      start.millisecondsSinceEpoch, 
      end.millisecondsSinceEpoch,
    );
  }
}
