import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:kosautb/screens/pencarikos/pesan_screen.dart';
import 'home_screen.dart';
import 'pesanan_screen.dart';
import 'profile_screen.dart';

class PencariKosScreen extends StatefulWidget {
  final String email; // [Tambahan Baru] Tambahkan properti email

  const PencariKosScreen({
    super.key,
    required this.email, // [Tambahan Baru]
  });

  @override
  State<PencariKosScreen> createState() => _PencariKosScreenState();
}

class _PencariKosScreenState extends State<PencariKosScreen> {
  int _currentIndex = 0;

  void _showKosDetail(Map<String, dynamic> kosData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(kosData['nama_kos'] ?? 'Detail Kos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/kosan.jpg'),
              const SizedBox(height: 8),
              Text('Alamat: ${kosData['alamat_kos'] ?? ''}'),
              Text('Jumlah Kamar: ${kosData['jumlah_kamar'] ?? ''}'),
              Text('Harga Sewa: Rp ${kosData['harga_sewa'] ?? ''}/bulan'),
              Text('Jenis Kos: ${kosData['jenis_kos'] ?? ''}'),
              Text('Fasilitas: ${kosData['fasilitas'] ?? ''}'),
              Text('Email Pemilik: ${kosData['email_pengguna'] ?? ''}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
            TextButton(
              onPressed: () {
                // [Tambahan Baru] Navigasi ke PesanScreen dengan mengirimkan email
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PesanScreen(
                      kosData: kosData,
                      email: widget.email, // [Tambahan Baru]
                    ),
                  ),
                );
              },
              child: const Text('Pesan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onKosTap: _showKosDetail),
      PesananScreen(email: widget.email), // Kirim email ke PesananScreen
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencari Kos'),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavyBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Home'),
            activeColor: Colors.blue,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.message),
            title: const Text('Pesanan'),
            activeColor: Colors.pink,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.person),
            title: const Text('Profile'),
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
