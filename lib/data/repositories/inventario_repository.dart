import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/mueble.dart';

class InventarioRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'mobiliario';

  Future<List<Mueble>> getMuebles() async {
    final snapshot = await _firestore.collection(_collection).get();
    return snapshot.docs.map((doc) => Mueble.fromMap(doc.data())).toList();
  }

  Stream<List<Mueble>> getMueblesStream() {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Mueble.fromMap(doc.data())).toList();
    });
  }

  Future<List<Mueble>> getMueblesByNegocio(String negocioId) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('negocioId', isEqualTo: negocioId)
        .get();
    return snapshot.docs.map((doc) => Mueble.fromMap(doc.data())).toList();
  }

  Stream<List<Mueble>> getMueblesByNegocioStream(String negocioId) {
    return _firestore
        .collection(_collection)
        .where('negocioId', isEqualTo: negocioId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Mueble.fromMap(doc.data())).toList();
    });
  }

  Future<void> addMueble(Mueble mueble) async {
    final docRef = _firestore.collection(_collection).doc();
    final newMueble = mueble.copyWith(id: docRef.id);
    await docRef.set(newMueble.toMap());
  }

  Future<void> updateMueble(Mueble mueble) async {
    await _firestore
        .collection(_collection)
        .doc(mueble.id)
        .update(mueble.toMap());
  }

  Future<void> deleteMueble(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}
