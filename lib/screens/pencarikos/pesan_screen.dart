import 'package:flutter/material.dart';

class PesanScreen extends StatelessWidget {
  final Map<String, dynamic> kosData;

  const PesanScreen({super.key, required this.kosData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesan Kos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pesan kos: ${kosData['nama_kos']}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Alamat: ${kosData['alamat_kos']}'),
            Text('Harga: Rp ${kosData['harga_sewa']}/bulan'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika pemesanan di sini
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pesanan berhasil dibuat!')),
                );
              },
              child: const Text('Konfirmasi Pesanan'),
            ),
          ],
        ),
      ),
    );
  }
}
