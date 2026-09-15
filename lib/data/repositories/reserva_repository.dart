import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/reserva.dart';

class ReservaRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'reservaciones';

  Future<List<Reserva>> getReservas() async {
    final snapshot = await _firestore.collection(_collection).get();
    return snapshot.docs.map((doc) => Reserva.fromMap(doc.data())).toList();
  }

  Stream<List<Reserva>> getReservasStream() {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Reserva.fromMap(doc.data())).toList();
    });
  }

  Future<List<Reserva>> getReservasByNegocio(String negocioId) async {
    // Note: Since articulos is a list, we might need to filter manually if we don't have a top-level negocioId
    // But the models show ArticuloReservado has negocioId. 
    // Usually, a reservation is for a single negocio, but if it can have multiple, 
    // we should check if any article belongs to the negocio.
    // Assuming for now a reservation has a main negocioId or we filter in-memory for simplicity
    // unless the Reserva model is updated.
    
    // Looking at the Reserva model, it doesn't have negocioId at the top level.
    // I'll filter in memory or search how to query this.
    final snapshot = await _firestore.collection(_collection).get();
    final allReservas = snapshot.docs.map((doc) => Reserva.fromMap(doc.data())).toList();
    return allReservas.where((r) => r.articulos.any((a) => a.negocioId == negocioId)).toList();
  }

  Future<List<Reserva>> getReservasByUsuario(String usuarioId) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('usuarioId', isEqualTo: usuarioId)
        .get();
    return snapshot.docs.map((doc) => Reserva.fromMap(doc.data())).toList();
  }

  Future<void> addReserva(Reserva reserva) async {
    final docRef = _firestore.collection(_collection).doc();
    final newReserva = reserva.copyWith(id: docRef.id);
    await docRef.set(newReserva.toMap());
  }

  Future<void> updateReserva(Reserva reserva) async {
    await _firestore
        .collection(_collection)
        .doc(reserva.id)
        .update(reserva.toMap());
  }

  Future<void> deleteReserva(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }

  Future<int> getOccupiedStock(String muebleId, int startMillis, int endMillis) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('estado', isNotEqualTo: 'CANCELADA')
        .get();

    int occupied = 0;
    for (var doc in snapshot.docs) {
      final reserva = Reserva.fromMap(doc.data());
      
      // Check overlap: (StartA < EndB) and (EndA > StartB)
      bool overlaps = reserva.fechaInicioMillis < endMillis && reserva.fechaFinMillis > startMillis;
      
      if (overlaps) {
        for (var articulo in reserva.articulos) {
          if (articulo.muebleId == muebleId) {
            occupied += articulo.cantidad;
          }
        }
      }
    }
    return occupied;
  }
}
