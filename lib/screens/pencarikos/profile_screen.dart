import 'package:flutter/material.dart';
import 'package:kosautb/screens/login/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String email;

  const ProfileScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 80),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
          ),
          const SizedBox(height: 20),

          // Menampilkan email pengguna dari login
          Text(
            email, // Menampilkan email dari parameter
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

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
                const Divider(), // Garis pembatas

                _buildProfileOption(
                  icon: Icons.help_outline,
                  title: 'Bantuan',
                  onTap: () {
                    // Tambahkan logika untuk navigasi ke halaman Bantuan
                  },
                ),
                const Divider(), // Garis pembatas

                _buildProfileOption(
                  icon: Icons.logout,
                  title: 'Keluar',
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                ),
                const Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
