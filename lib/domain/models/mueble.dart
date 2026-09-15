class Mueble {
  final String id;
  final String nombre;
  final String descripcion;
  final double precioAlquiler;
  final int stockDisponible;
  final String negocioId;
  final String nombreNegocio;
  final String categoria;
  final List<String> imageUrls;
  final bool esVenta;
  final String ubicacionNegocio;

  Mueble({
    this.id = '',
    this.nombre = '',
    this.descripcion = '',
    this.precioAlquiler = 0.0,
    this.stockDisponible = 0,
    this.negocioId = '',
    this.nombreNegocio = '',
    this.categoria = 'Otros',
    this.imageUrls = const [],
    this.esVenta = false,
    this.ubicacionNegocio = '',
  });

  factory Mueble.fromMap(Map<String, dynamic> map) {
    return Mueble(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'] ?? '',
      precioAlquiler: (map['precioAlquiler'] ?? 0.0).toDouble(),
      stockDisponible: map['stockDisponible'] ?? 0,
      negocioId: map['negocioId'] ?? '',
      nombreNegocio: map['nombreNegocio'] ?? '',
      categoria: map['categoria'] ?? 'Otros',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      esVenta: map['esVenta'] ?? false,
      ubicacionNegocio: map['ubicacionNegocio'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precioAlquiler': precioAlquiler,
      'stockDisponible': stockDisponible,
      'negocioId': negocioId,
      'nombreNegocio': nombreNegocio,
      'categoria': categoria,
      'imageUrls': imageUrls,
      'esVenta': esVenta,
      'ubicacionNegocio': ubicacionNegocio,
    };
  }

  Mueble copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    double? precioAlquiler,
    int? stockDisponible,
    String? negocioId,
    String? nombreNegocio,
    String? categoria,
    List<String>? imageUrls,
    bool? esVenta,
    String? ubicacionNegocio,
  }) {
    return Mueble(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      precioAlquiler: precioAlquiler ?? this.precioAlquiler,
      stockDisponible: stockDisponible ?? this.stockDisponible,
      negocioId: negocioId ?? this.negocioId,
      nombreNegocio: nombreNegocio ?? this.nombreNegocio,
      categoria: categoria ?? this.categoria,
      imageUrls: imageUrls ?? this.imageUrls,
      esVenta: esVenta ?? this.esVenta,
      ubicacionNegocio: ubicacionNegocio ?? this.ubicacionNegocio,
    );
  }
}
