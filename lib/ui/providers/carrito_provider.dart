import 'package:flutter/material.dart';
import '../../domain/models/mueble.dart';
import '../../domain/models/reserva.dart';

class CarritoProvider extends ChangeNotifier {
  final Map<String, ArticuloReservado> _items = {};
  
  Map<String, ArticuloReservado> get items => {..._items};
  
  int get itemCount => _items.length;
  
  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, articulo) {
      total += articulo.precioUnitario * articulo.cantidad;
    });
    return total;
  }

  void addItem(Mueble mueble, int cantidad) {
    if (_items.containsKey(mueble.id)) {
      _items.update(
        mueble.id,
        (existing) => ArticuloReservado(
          muebleId: existing.muebleId,
          nombre: existing.nombre,
          cantidad: existing.cantidad + cantidad,
          precioUnitario: existing.precioUnitario,
          negocioId: existing.negocioId,
          esVenta: existing.esVenta,
        ),
      );
    } else {
      _items.putIfAbsent(
        mueble.id,
        () => ArticuloReservado(
          muebleId: mueble.id,
          nombre: mueble.nombre,
          cantidad: cantidad,
          precioUnitario: mueble.precioAlquiler,
          negocioId: mueble.negocioId,
          esVenta: mueble.esVenta,
        ),
      );
    }
    notifyListeners();
  }

  void incrementItem(String muebleId) {
    if (_items.containsKey(muebleId)) {
      _items.update(
        muebleId,
        (existing) => ArticuloReservado(
          muebleId: existing.muebleId,
          nombre: existing.nombre,
          cantidad: existing.cantidad + 1,
          precioUnitario: existing.precioUnitario,
          negocioId: existing.negocioId,
          esVenta: existing.esVenta,
        ),
      );
      notifyListeners();
    }
  }

  void removeOneItem(String muebleId) {
    if (!_items.containsKey(muebleId)) return;
    
    if (_items[muebleId]!.cantidad > 1) {
      _items.update(
        muebleId,
        (existing) => ArticuloReservado(
          muebleId: existing.muebleId,
          nombre: existing.nombre,
          cantidad: existing.cantidad - 1,
          precioUnitario: existing.precioUnitario,
          negocioId: existing.negocioId,
          esVenta: existing.esVenta,
        ),
      );
    } else {
      _items.remove(muebleId);
    }
    notifyListeners();
  }

  void removeItem(String muebleId) {
    _items.remove(muebleId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
