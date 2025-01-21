import 'package:flutter/material.dart';
import 'package:kosautb/screens/login/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Foto Profil
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
          ),

          const SizedBox(height: 20),

          // Nama Pengguna
          const Text(
            'Nama Pengguna',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          // Email Pengguna
          const Text(
            'user@example.com',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 20),

          // Informasi tambahan (opsional)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildProfileOption(
                  icon: Icons.person,
                  title: 'Edit Profil',
                  onTap: () {
                    // Tambahkan logika untuk navigasi ke halaman Edit Profil
                  },
                ),
                _buildProfileOption(
                  icon: Icons.help_outline,
                  title: 'Bantuan',
                  onTap: () {
                    // Tambahkan logika untuk navigasi ke halaman Bantuan
                  },
                ),
                _buildProfileOption(
                  icon: Icons.logout,
                  title: 'Keluar',
                  onTap: () {
                    // Logika untuk logout
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                      (route) => false, // Menghapus semua rute sebelumnya
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk item opsi di halaman profil
  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
