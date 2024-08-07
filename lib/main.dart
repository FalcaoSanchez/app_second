import 'package:app_second/autenticacion/login.dart';
import 'package:app_second/vistas/agenda.dart';
import 'package:app_second/vistas/alimentacion.dart';
import 'package:app_second/vistas/fotografias.dart';
import 'package:app_second/vistas/recordatorio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

// Punto de entrada de la aplicación
Future<void> main() async {
  // Asegura que todas las interacciones con Flutter se inicialicen correctamente
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase con las opciones específicas de la plataforma actual
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Ejecuta la aplicación
  runApp(const MyApp());
}

// Widget principal de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo', // Título de la aplicación
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true, // Usa Material Design 3
      ),
      // Establece la página principal de la aplicación
      home: const AuthWrapper(), // Cambia a AuthWrapper para gestionar el estado de autenticación
    );
  }
}

// Widget que envuelve la autenticación para mostrar la pantalla adecuada
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Escucha los cambios en el estado de autenticación
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Mientras se espera la respuesta de Firebase
          return const Center(child: CircularProgressIndicator()); // Muestra un indicador de carga
        } else if (snapshot.hasData) {
          // Si hay un usuario autenticado
          return const MyHomePage(title: 'Bienvenido!! :)'); // Muestra la página principal
        } else {
          // Si no hay usuario autenticado
          return Login(); // Muestra la página de login
        }
      },
    );
  }
}

// Widget de la página principal
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title; // Título de la página principal

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary, // Color de fondo de la AppBar
        title: Text(title), // Título de la AppBar
      ),
      drawer: const MyDrawer(), // Barra lateral (drawer)
      body: const Center(child: SizedBox()), // Cuerpo de la página principal, actualmente vacío
    );
  }
}

// Widget para la barra lateral (drawer)
class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple, // Color del fondo del header
            ),
            child: Text(
              'Menú',
              style: TextStyle(
                color: Colors.white, // Color del texto
                fontSize: 24, // Tamaño del texto
              ),
            ),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.photo_library,
            text: 'Fotografías',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Fotos()),
            ),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.alarm,
            text: 'Recordatorios',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RecordatoriosPage()),
            ),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.contact_page,
            text: 'Contactos',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Agenda()),
            ),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.fastfood,
            text: 'Alimentación',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Alimentacion()),
            ),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.logout,
            text: 'Cerrar Sesión',
            onTap: () async {
              await FirebaseAuth.instance.signOut(); // Cierra la sesión de Firebase
            },
          ),
        ],
      ),
    );
  }

  // Método auxiliar para construir un ítem del drawer
  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon), // Icono del ítem
      title: Text(text), // Texto del ítem
      onTap: onTap, // Acción al tocar el ítem
    );
  }
}

