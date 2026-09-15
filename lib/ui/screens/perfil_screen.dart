import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.usuario;

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: user == null
          ? const Center(child: Text('No has iniciado sesión'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: user.logoUrl.isNotEmpty ? NetworkImage(user.logoUrl) : null,
                      child: user.logoUrl.isEmpty ? const Icon(Icons.person, size: 50) : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _InfoTile(label: 'Nombre', value: user.nombre),
                  _InfoTile(label: 'Email', value: user.email),
                  _InfoTile(label: 'Rol', value: user.rol),
                  if (user.rol == 'ADMIN') ...[
                    _InfoTile(label: 'Negocio', value: user.nombreNegocio),
                    _InfoTile(label: 'Teléfono', value: user.telefono),
                    _InfoTile(label: 'Ubicación', value: user.ubicacionNegocio),
                  ],
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red[100], foregroundColor: Colors.red),
                      onPressed: () async {
                        await auth.logout();
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: const Text('Cerrar Sesión'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Eliminar Cuenta'),
                            content: const Text('¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer.'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                              TextButton(
                                onPressed: () {
                                  // Implementation for delete account would go here
                                  // authProvider.deleteAccount();
                                  Navigator.pop(context);
                                },
                                child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text('Eliminar Cuenta'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
          const Divider(),
        ],
      ),
    );
  }
}
