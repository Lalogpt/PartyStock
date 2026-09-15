class ArticuloReservado {
  final String muebleId;
  final String nombre;
  final int cantidad;
  final double precioUnitario;
  final String negocioId;
  final bool esVenta;

  ArticuloReservado({
    this.muebleId = '',
    this.nombre = '',
    this.cantidad = 0,
    this.precioUnitario = 0.0,
    this.negocioId = '',
    this.esVenta = false,
  });

  factory ArticuloReservado.fromMap(Map<String, dynamic> map) {
    return ArticuloReservado(
      muebleId: map['muebleId'] ?? '',
      nombre: map['nombre'] ?? '',
      cantidad: map['cantidad'] ?? 0,
      precioUnitario: (map['precioUnitario'] ?? 0.0).toDouble(),
      negocioId: map['negocioId'] ?? '',
      esVenta: map['esVenta'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'muebleId': muebleId,
      'nombre': nombre,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
      'negocioId': negocioId,
      'esVenta': esVenta,
    };
  }
}

class Reserva {
  final String id;
  final String usuarioId;
  final int fechaInicioMillis;
  final int fechaFinMillis;
  final String estado;
  final double total;
  final List<ArticuloReservado> articulos;
  final String direccionCalle;
  final String direccionColonia;
  final String direccionCP;
  final String direccionMunicipio;
  final String telefonoContacto;
  final String horaEntrega;
  final String horaRecogida;
  final String metodoPago;
  final String notas;
  final int numDias;

  Reserva({
    this.id = '',
    this.usuarioId = '',
    this.fechaInicioMillis = 0,
    this.fechaFinMillis = 0,
    this.estado = 'PENDIENTE',
    this.total = 0.0,
    this.articulos = const [],
    this.direccionCalle = '',
    this.direccionColonia = '',
    this.direccionCP = '',
    this.direccionMunicipio = '',
    this.telefonoContacto = '',
    this.horaEntrega = '',
    this.horaRecogida = '',
    this.metodoPago = 'EFECTIVO',
    this.notas = '',
    this.numDias = 1,
  });

  factory Reserva.fromMap(Map<String, dynamic> map) {
    return Reserva(
      id: map['id'] ?? '',
      usuarioId: map['usuarioId'] ?? '',
      fechaInicioMillis: map['fechaInicioMillis'] ?? 0,
      fechaFinMillis: map['fechaFinMillis'] ?? 0,
      estado: map['estado'] ?? 'PENDIENTE',
      total: (map['total'] ?? 0.0).toDouble(),
      articulos: (map['articulos'] as List? ?? [])
          .map((a) => ArticuloReservado.fromMap(a))
          .toList(),
      direccionCalle: map['direccionCalle'] ?? '',
      direccionColonia: map['direccionColonia'] ?? '',
      direccionCP: map['direccionCP'] ?? '',
      direccionMunicipio: map['direccionMunicipio'] ?? '',
      telefonoContacto: map['telefonoContacto'] ?? '',
      horaEntrega: map['horaEntrega'] ?? '',
      horaRecogida: map['horaRecogida'] ?? '',
      metodoPago: map['metodoPago'] ?? 'EFECTIVO',
      notas: map['notas'] ?? '',
      numDias: map['numDias'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'fechaInicioMillis': fechaInicioMillis,
      'fechaFinMillis': fechaFinMillis,
      'estado': estado,
      'total': total,
      'articulos': articulos.map((a) => a.toMap()).toList(),
      'direccionCalle': direccionCalle,
      'direccionColonia': direccionColonia,
      'direccionCP': direccionCP,
      'direccionMunicipio': direccionMunicipio,
      'telefonoContacto': telefonoContacto,
      'horaEntrega': horaEntrega,
      'horaRecogida': horaRecogida,
      'metodoPago': metodoPago,
      'notas': notas,
      'numDias': numDias,
    };
  }

  Reserva copyWith({
    String? id,
    String? usuarioId,
    int? fechaInicioMillis,
    int? fechaFinMillis,
    String? estado,
    double? total,
    List<ArticuloReservado>? articulos,
    String? direccionCalle,
    String? direccionColonia,
    String? direccionCP,
    String? direccionMunicipio,
    String? telefonoContacto,
    String? horaEntrega,
    String? horaRecogida,
    String? metodoPago,
    String? notas,
    int? numDias,
  }) {
    return Reserva(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      fechaInicioMillis: fechaInicioMillis ?? this.fechaInicioMillis,
      fechaFinMillis: fechaFinMillis ?? this.fechaFinMillis,
      estado: estado ?? this.estado,
      total: total ?? this.total,
      articulos: articulos ?? this.articulos,
      direccionCalle: direccionCalle ?? this.direccionCalle,
      direccionColonia: direccionColonia ?? this.direccionColonia,
      direccionCP: direccionCP ?? this.direccionCP,
      direccionMunicipio: direccionMunicipio ?? this.direccionMunicipio,
      telefonoContacto: telefonoContacto ?? this.telefonoContacto,
      horaEntrega: horaEntrega ?? this.horaEntrega,
      horaRecogida: horaRecogida ?? this.horaRecogida,
      metodoPago: metodoPago ?? this.metodoPago,
      notas: notas ?? this.notas,
      numDias: numDias ?? this.numDias,
    );
  }
}
