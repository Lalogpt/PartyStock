import 'dart:io';
import 'package:flutter/material.dart';
import '../../data/repositories/inventario_repository.dart';
import '../../data/repositories/storage_repository.dart';
import '../../domain/models/mueble.dart';

class InventarioProvider extends ChangeNotifier {
  final InventarioRepository _inventarioRepository = InventarioRepository();
  final StorageRepository _storageRepository = StorageRepository();
  
  List<Mueble> _muebles = [];
  bool _isLoading = false;

  List<Mueble> get muebles => _muebles;
  bool get isLoading => _isLoading;

  Future<void> fetchMuebles() async {
    _isLoading = true;
    notifyListeners();
    try {
      _muebles = await _inventarioRepository.getMuebles();
    } catch (e) {
      print('Error fetching muebles: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMueblesByNegocio(String negocioId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _muebles = await _inventarioRepository.getMueblesByNegocio(negocioId);
    } catch (e) {
      print('Error fetching muebles by negocio: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addMueble(Mueble mueble, List<File> images) async {
    _isLoading = true;
    notifyListeners();
    try {
      List<String> imageUrls = [];
      for (var i = 0; i < images.length; i++) {
        final url = await _storageRepository.uploadImage(
          images[i],
          '${mueble.nombre}_${DateTime.now().millisecondsSinceEpoch}_$i',
        );
        imageUrls.add(url);
      }
      
      final newMueble = mueble.copyWith(imageUrls: imageUrls);
      await _inventarioRepository.addMueble(newMueble);
      await fetchMuebles(); // Refresh list
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateMueble(Mueble mueble, {List<File>? newImages}) async {
    _isLoading = true;
    notifyListeners();
    try {
      List<String> imageUrls = List.from(mueble.imageUrls);
      if (newImages != null && newImages.isNotEmpty) {
        for (var i = 0; i < newImages.length; i++) {
          final url = await _storageRepository.uploadImage(
            newImages[i],
            '${mueble.nombre}_${DateTime.now().millisecondsSinceEpoch}_$i',
          );
          imageUrls.add(url);
        }
      }
      
      final updatedMueble = mueble.copyWith(imageUrls: imageUrls);
      await _inventarioRepository.updateMueble(updatedMueble);
      await fetchMuebles();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteMueble(String id, List<String> imageUrls) async {
    _isLoading = true;
    notifyListeners();
    try {
      for (var url in imageUrls) {
        await _storageRepository.deleteImage(url);
      }
      await _inventarioRepository.deleteMueble(id);
      _muebles.removeWhere((m) => m.id == id);
    } catch (e) {
      print('Error deleting mueble: $e');
    }
    _isLoading = false;
    notifyListeners();
  }
}
