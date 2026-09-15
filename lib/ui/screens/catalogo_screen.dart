import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/auth_provider.dart';
import '../providers/inventario_provider.dart';
import '../providers/carrito_provider.dart';
import '../../domain/models/mueble.dart';
import 'agregar_mueble_screen.dart';

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  String _filtroCategoria = 'Todos';
  final List<String> _categorias = ['Todos', 'Sillas', 'Mesas', 'Carpas', 'Inflables', 'Vajilla', 'Otros'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InventarioProvider>(context, listen: false).fetchMuebles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final inventario = Provider.of<InventarioProvider>(context);
    final carrito = Provider.of<CarritoProvider>(context, listen: false);
    final esAdmin = auth.usuario?.rol == 'ADMIN';

    final mueblesFiltrados = _filtroCategoria == 'Todos'
        ? inventario.muebles
        : inventario.muebles.where((m) => m.categoria == _filtroCategoria).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Muebles'),
        actions: [
          if (esAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AgregarMuebleScreen()),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: _categorias.map((cat) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FilterChip(
                    label: Text(cat),
                    selected: _filtroCategoria == cat,
                    onSelected: (selected) {
                      setState(() {
                        _filtroCategoria = cat;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: inventario.isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: mueblesFiltrados.length,
                    itemBuilder: (context, index) {
                      final mueble = mueblesFiltrados[index];
                      return _MuebleCard(
                        mueble: mueble,
                        esAdmin: esAdmin,
                        onAddToCart: () {
                          carrito.addItem(mueble, 1);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Agregado al carrito')),
                          );
                        },
                        onEdit: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AgregarMuebleScreen(mueble: mueble),
                          ),
                        ),
                        onDelete: () => inventario.deleteMueble(mueble.id, mueble.imageUrls),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _MuebleCard extends StatelessWidget {
  final Mueble mueble;
  final bool esAdmin;
  final VoidCallback onAddToCart;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MuebleCard({
    required this.mueble,
    required this.esAdmin,
    required this.onAddToCart,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: mueble.imageUrls.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: mueble.imageUrls.first,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  )
                : Container(color: Colors.grey[300], child: const Icon(Icons.image)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mueble.nombre, style: Theme.of(context).textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('\$${mueble.precioAlquiler} ${mueble.esVenta ? 'Venta' : 'Día'}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                Text('Negocio: ${mueble.nombreNegocio}', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (esAdmin) ...[
                      IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: onEdit),
                      IconButton(icon: const Icon(Icons.delete, size: 20), onPressed: onDelete),
                    ] else
                      IconButton(icon: const Icon(Icons.add_shopping_cart, size: 20), onPressed: onAddToCart),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
