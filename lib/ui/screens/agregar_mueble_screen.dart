import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/auth_provider.dart';
import '../providers/inventario_provider.dart';
import '../../domain/models/mueble.dart';

class AgregarMuebleScreen extends StatefulWidget {
  final Mueble? mueble;
  const AgregarMuebleScreen({super.key, this.mueble});

  @override
  State<AgregarMuebleScreen> createState() => _AgregarMuebleScreenState();
}

class _AgregarMuebleScreenState extends State<AgregarMuebleScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _precioController;
  late TextEditingController _stockController;
  
  String _categoria = 'Sillas';
  bool _esVenta = false;
  List<File> _newImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.mueble?.nombre ?? '');
    _descripcionController = TextEditingController(text: widget.mueble?.descripcion ?? '');
    _precioController = TextEditingController(text: widget.mueble?.precioAlquiler.toString() ?? '');
    _stockController = TextEditingController(text: widget.mueble?.stockDisponible.toString() ?? '');
    _categoria = widget.mueble?.categoria ?? 'Sillas';
    _esVenta = widget.mueble?.esVenta ?? false;
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _newImages.addAll(images.map((x) => File(x.path)));
      });
    }
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final inventario = Provider.of<InventarioProvider>(context, listen: false);

    final mueble = Mueble(
      id: widget.mueble?.id ?? '',
      nombre: _nombreController.text,
      descripcion: _descripcionController.text,
      precioAlquiler: double.parse(_precioController.text),
      stockDisponible: int.parse(_stockController.text),
      categoria: _categoria,
      esVenta: _esVenta,
      negocioId: auth.usuario?.negocioId ?? '',
      nombreNegocio: auth.usuario?.nombreNegocio ?? '',
      imageUrls: widget.mueble?.imageUrls ?? [],
      ubicacionNegocio: auth.usuario?.ubicacionNegocio ?? '',
    );

    try {
      if (widget.mueble == null) {
        await inventario.addMueble(mueble, _newImages);
      } else {
        await inventario.updateMueble(mueble, newImages: _newImages);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.mueble == null ? 'Agregar Mueble' : 'Editar Mueble')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _precioController,
                      decoration: const InputDecoration(labelText: 'Precio'),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Requerido' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _stockController,
                      decoration: const InputDecoration(labelText: 'Stock Total'),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Requerido' : null,
                    ),
                  ),
                ],
              ),
              DropdownButtonFormField<String>(
                value: _categoria,
                decoration: const InputDecoration(labelText: 'Categoría'),
                items: ['Sillas', 'Mesas', 'Carpas', 'Inflables', 'Vajilla', 'Otros'].map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) => setState(() => _categoria = val!),
              ),
              SwitchListTile(
                title: const Text('Es para Venta? (Inactivar si es Alquiler)'),
                value: _esVenta,
                onChanged: (val) => setState(() => _esVenta = val),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _pickImages,
                icon: const Icon(Icons.photo_library),
                label: const Text('Seleccionar Imágenes'),
              ),
              if (_newImages.isNotEmpty || (widget.mueble?.imageUrls.isNotEmpty ?? false))
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: (widget.mueble?.imageUrls.length ?? 0) + _newImages.length,
                    itemBuilder: (context, index) {
                      if (index < (widget.mueble?.imageUrls.length ?? 0)) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.network(widget.mueble!.imageUrls[index], width: 100, fit: BoxFit.cover),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.file(_newImages[index - (widget.mueble?.imageUrls.length ?? 0)], width: 100, fit: BoxFit.cover),
                        );
                      }
                    },
                  ),
                ),
              const SizedBox(height: 20),
              Consumer<InventarioProvider>(
                builder: (context, inv, _) {
                  return inv.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(onPressed: _save, child: const Text('Guardar'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    _stockController.dispose();
    super.dispose();
  }
}
