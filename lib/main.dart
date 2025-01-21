import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase_config.dart'; // Konfigurasi Supabase
import 'screens/login/login_screen.dart'; // Mengimpor LoginScreen
import 'screens/register/register_screen.dart'; // Mengimpor RegisterScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Inisialisasi Supabase dengan konfigurasi dari file lain
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
  } catch (e) {
    // Jika terjadi kesalahan saat inisialisasi
    debugPrint('Error initializing Supabase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UtbKos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Tambahkan navigasi berbasis rute
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}
