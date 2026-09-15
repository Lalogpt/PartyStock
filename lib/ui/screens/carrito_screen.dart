import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/carrito_provider.dart';
import '../providers/reserva_provider.dart';
import '../../domain/models/reserva.dart';

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _direccionCalle = TextEditingController();
  final _direccionColonia = TextEditingController();
  final _direccionCP = TextEditingController();
  final _direccionMunicipio = TextEditingController();
  final _telefono = TextEditingController();
  
  DateTime _fechaInicio = DateTime.now().add(const Duration(days: 1));
  DateTime _fechaFin = DateTime.now().add(const Duration(days: 2));
  String _metodoPago = 'EFECTIVO';

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: _fechaInicio, end: _fechaFin),
    );
    if (picked != null) {
      setState(() {
        _fechaInicio = picked.start;
        _fechaFin = picked.end;
      });
    }
  }

  void _finalizarPedido() async {
    if (!_formKey.currentState!.validate()) return;
    
    final carrito = Provider.of<CarritoProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final reservaProv = Provider.of<ReservaProvider>(context, listen: false);

    if (carrito.itemCount == 0) return;

    final numDias = _fechaFin.difference(_fechaInicio).inDays;
    final reserva = Reserva(
      usuarioId: auth.usuario?.id ?? '',
      fechaInicioMillis: _fechaInicio.millisecondsSinceEpoch,
      fechaFinMillis: _fechaFin.millisecondsSinceEpoch,
      total: carrito.totalAmount * (numDias > 0 ? numDias : 1),
      articulos: carrito.items.values.toList(),
      direccionCalle: _direccionCalle.text,
      direccionColonia: _direccionColonia.text,
      direccionCP: _direccionCP.text,
      direccionMunicipio: _direccionMunicipio.text,
      telefonoContacto: _telefono.text,
      metodoPago: _metodoPago,
      numDias: numDias > 0 ? numDias : 1,
    );

    try {
      await reservaProv.createReserva(reserva);
      carrito.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pedido realizado con éxito')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final carrito = Provider.of<CarritoProvider>(context);
    final total = carrito.totalAmount;
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Carrito')),
      body: carrito.itemCount == 0
          ? const Center(child: Text('El carrito está vacío'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: carrito.items.length,
                    itemBuilder: (context, index) {
                      final item = carrito.items.values.elementAt(index);
                      return ListTile(
                        title: Text(item.nombre),
                        subtitle: Text('\$${item.precioUnitario} x ${item.cantidad}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => carrito.removeOneItem(item.muebleId),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => carrito.incrementItem(item.muebleId),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => carrito.removeItem(item.muebleId),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Rango de fechas'),
                    subtitle: Text('${dateFormat.format(_fechaInicio)} - ${dateFormat.format(_fechaFin)}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectDateRange(context),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Datos de Entrega', style: Theme.of(context).textTheme.titleLarge),
                        TextFormField(
                          controller: _direccionCalle,
                          decoration: const InputDecoration(labelText: 'Calle y Número'),
                          validator: (value) => value!.isEmpty ? 'Requerido' : null,
                        ),
                        TextFormField(
                          controller: _direccionColonia,
                          decoration: const InputDecoration(labelText: 'Colonia'),
                          validator: (value) => value!.isEmpty ? 'Requerido' : null,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _direccionCP,
                                decoration: const InputDecoration(labelText: 'C.P.'),
                                keyboardType: TextInputType.number,
                                validator: (value) => value!.isEmpty ? 'Requerido' : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: _direccionMunicipio,
                                decoration: const InputDecoration(labelText: 'Municipio'),
                                validator: (value) => value!.isEmpty ? 'Requerido' : null,
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: _telefono,
                          decoration: const InputDecoration(labelText: 'Teléfono de Contacto'),
                          keyboardType: TextInputType.phone,
                          validator: (value) => value!.isEmpty ? 'Requerido' : null,
                        ),
                        DropdownButtonFormField<String>(
                          value: _metodoPago,
                          decoration: const InputDecoration(labelText: 'Método de Pago'),
                          items: ['EFECTIVO', 'TRANSFERENCIA', 'TARJETA'].map((val) {
                            return DropdownMenuItem(value: val, child: Text(val));
                          }).toList(),
                          onChanged: (val) => setState(() => _metodoPago = val!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Total: \$${total * (_fechaFin.difference(_fechaInicio).inDays > 0 ? _fechaFin.difference(_fechaInicio).inDays : 1)}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _finalizarPedido,
                    child: const Text('Confirmar Pedido'),
                  ),
                ],
              ),
            ),
    );
  }
}
