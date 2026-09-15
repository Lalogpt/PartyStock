class Usuario {
  final String id;
  final String nombre;
  final String email;
  final String rol;
  final String nombreNegocio;
  final String logoUrl;
  final String telefono;
  final String ubicacionNegocio;
  final String negocioId;

  Usuario({
    this.id = '',
    this.nombre = '',
    this.email = '',
    this.rol = 'CLIENTE',
    this.nombreNegocio = '',
    this.logoUrl = '',
    this.telefono = '',
    this.ubicacionNegocio = '',
    this.negocioId = '',
  });

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      email: map['email'] ?? '',
      rol: map['rol'] ?? 'CLIENTE',
      nombreNegocio: map['nombreNegocio'] ?? '',
      logoUrl: map['logoUrl'] ?? '',
      telefono: map['telefono'] ?? '',
      ubicacionNegocio: map['ubicacionNegocio'] ?? '',
      negocioId: map['negocioId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'rol': rol,
      'nombreNegocio': nombreNegocio,
      'logoUrl': logoUrl,
      'telefono': telefono,
      'ubicacionNegocio': ubicacionNegocio,
      'negocioId': negocioId,
    };
  }
}
