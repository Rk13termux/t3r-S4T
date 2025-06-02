import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/user_model.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final user = await _loadUser();
  runApp(MyApp(initialUser: user));
}

Future<UserModel?> _loadUser() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  if (token != null && token.isNotEmpty) {
    return UserModel(
      id: prefs.getString('userId') ?? '',
      username: prefs.getString('username') ?? '',
      email: prefs.getString('email') ?? '',
      role: prefs.getString('role') ?? 'free',
      token: token,
    );
  }
  return null;
}

class MyApp extends StatelessWidget {
  final UserModel? initialUser;

  const MyApp({super.key, required this.initialUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tienda de Scripts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF262729), // Fondo gris oscuro
        primaryColor: const Color(0xFF3489fe), // Azul para botones/títulos
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF262729),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3489fe),
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: initialUser != null ? '/home' : '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => HomeScreen(user: initialUser),
      },
    );
  }
}
