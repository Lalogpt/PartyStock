import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/reserva_provider.dart';
import '../../domain/models/reserva.dart';

class MisReservasScreen extends StatefulWidget {
  const MisReservasScreen({super.key});

  @override
  State<MisReservasScreen> createState() => _MisReservasScreenState();
}

class _MisReservasScreenState extends State<MisReservasScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final reservaProv = Provider.of<ReservaProvider>(context, listen: false);
      if (auth.usuario != null) {
        if (auth.usuario!.rol == 'ADMIN') {
          reservaProv.fetchReservasByNegocio(auth.usuario!.negocioId);
        } else {
          reservaProv.fetchReservasByUsuario(auth.usuario!.id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final reservaProv = Provider.of<ReservaProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final esAdmin = auth.usuario?.rol == 'ADMIN';
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(title: Text(esAdmin ? 'Reservas de Clientes' : 'Mis Reservas')),
      body: reservaProv.isLoading
          ? const Center(child: CircularProgressIndicator())
          : reservaProv.reservas.isEmpty
              ? const Center(child: Text('No hay reservas'))
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: reservaProv.reservas.length,
                  itemBuilder: (context, index) {
                    final reserva = reservaProv.reservas[index];
                    return Card(
                      child: ExpansionTile(
                        title: Text('Pedido #${reserva.id.substring(0, 6)} - ${reserva.estado}'),
                        subtitle: Text('${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(reserva.fechaInicioMillis))} a ${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(reserva.fechaFinMillis))}'),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total: \$${reserva.total}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text('Dirección: ${reserva.direccionCalle}, ${reserva.direccionColonia}'),
                                Text('Teléfono: ${reserva.telefonoContacto}'),
                                const Divider(),
                                const Text('Artículos:', style: TextStyle(fontWeight: FontWeight.bold)),
                                ...reserva.articulos.map((a) => Text('${a.cantidad}x ${a.nombre} - \$${a.precioUnitario}')),
                                if (esAdmin && reserva.estado == 'PENDIENTE') ...[
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () => reservaProv.updateReservaEstado(reserva, 'CONFIRMADA'),
                                        child: const Text('Confirmar'),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red[100]),
                                        onPressed: () => reservaProv.updateReservaEstado(reserva, 'CANCELADA'),
                                        child: const Text('Cancelar'),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
