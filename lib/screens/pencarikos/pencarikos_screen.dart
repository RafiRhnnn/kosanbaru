import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:kosautb/screens/pencarikos/pesan_screen.dart';
import 'home_screen.dart';
import 'pesanan_screen.dart';
import 'profile_screen.dart';

class PencariKosScreen extends StatefulWidget {
  const PencariKosScreen({super.key});

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
              onPressed: () =>
                  Navigator.pop(context), // Aksi untuk tombol "Tutup"
              child: const Text('Tutup'),
            ),
            TextButton(
              onPressed: () {
                // Aksi untuk tombol "Pesan", navigasi ke halaman pesan_screen.dart
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PesanScreen(kosData: kosData), // Kirim data kos
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
      const PesananScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencari Kos'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                setState(() => _currentIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Pesanan'),
              onTap: () {
                setState(() => _currentIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                setState(() => _currentIndex = 2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
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
