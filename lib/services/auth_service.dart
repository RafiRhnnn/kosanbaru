import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  /// **Register User**
  /// Mendaftarkan pengguna baru dengan email, password, dan role.
  Future<String?> registerUser({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      // Insert data ke tabel 'users'
      final response = await _client.from('users').insert({
        'email': email,
        'password': password,
        'role': role,
        'created_at': DateTime.now().toIso8601String(),
      }).select(); // Gunakan select() untuk mendapatkan data hasil insert

      // Periksa apakah ada data yang berhasil dimasukkan
      if (response.isEmpty) {
        return 'Registration failed. No data was inserted.';
      }

      // Registrasi berhasil
      return null;
    } catch (e) {
      // Tangani error runtime
      return 'Unexpected error: $e';
    }
  }

  /// **Login User**
  /// Memeriksa kredensial login (email dan password) dan mengembalikan role pengguna.
  Future<Map<String, dynamic>?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('email', email)
          .eq('password', password)
          .limit(1)
          .maybeSingle();

      if (response == null) {
        return null; // Login gagal
      }
      return response; // Berhasil, mengembalikan data pengguna
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}
