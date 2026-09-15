import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'ui/providers/auth_provider.dart';
import 'ui/providers/inventario_provider.dart';
import 'ui/providers/carrito_provider.dart';
import 'ui/providers/reserva_provider.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/catalogo_screen.dart';
import 'ui/screens/carrito_screen.dart';
import 'ui/screens/perfil_screen.dart';
import 'ui/screens/mis_reservas_screen.dart';
import 'ui/screens/estadisticas_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => InventarioProvider()),
        ChangeNotifierProvider(create: (_) => CarritoProvider()),
        ChangeNotifierProvider(create: (_) => ReservaProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PartyStock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _clientScreens = [
    const CatalogoScreen(),
    const CarritoScreen(),
    const MisReservasScreen(),
    const PerfilScreen(),
  ];

  final List<Widget> _adminScreens = [
    const CatalogoScreen(),
    const MisReservasScreen(),
    const EstadisticasScreen(),
    const PerfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    
    if (auth.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    if (!auth.isAuthenticated) {
      return const LoginScreen();
    }

    final esAdmin = auth.usuario?.rol == 'ADMIN';
    final screens = esAdmin ? _adminScreens : _clientScreens;

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: esAdmin
            ? const [
                NavigationDestination(icon: Icon(Icons.home), label: 'Inventario'),
                NavigationDestination(icon: Icon(Icons.list_alt), label: 'Pedidos'),
                NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Estadísticas'),
                NavigationDestination(icon: Icon(Icons.person), label: 'Perfil'),
              ]
            : const [
                NavigationDestination(icon: Icon(Icons.home), label: 'Catálogo'),
                NavigationDestination(icon: Icon(Icons.shopping_cart), label: 'Carrito'),
                NavigationDestination(icon: Icon(Icons.history), label: 'Mis Reservas'),
                NavigationDestination(icon: Icon(Icons.person), label: 'Perfil'),
              ],
      ),
    );
  }
}
