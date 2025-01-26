import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PesananScreen extends StatefulWidget {
  final String email; // Email pengguna yang login

  const PesananScreen({super.key, required this.email});

  @override
  State<PesananScreen> createState() => _PesananScreenState();
}

class _PesananScreenState extends State<PesananScreen> {
  List<Map<String, dynamic>> _pesananList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPesanan();
  }

  Future<void> _fetchPesanan() async {
    try {
      // Ambil data pesanan berdasarkan email pengguna
      final response = await Supabase.instance.client
          .from('pesanan')
          .select()
          .eq('email_pemilik', widget.email) // Filter berdasarkan email
          .order('created_at', ascending: false);

      setState(() {
        _pesananList = response.cast<Map<String, dynamic>>();
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data pesanan: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _hapusPesanan(int id) async {
    try {
      await Supabase.instance.client.from('pesanan').delete().eq('id', id);
      setState(() {
        _pesananList.removeWhere((pesanan) => pesanan['id'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pesanan berhasil dihapus.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus pesanan: $e')),
      );
    }
  }

  void _konfirmasiHapusPesanan(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda yakin ingin menghapus pesanan ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                _hapusPesanan(id); // Hapus pesanan
              },
              child: const Text('Iya'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pesananList.isEmpty
              ? const Center(child: Text('Belum ada pesanan.'))
              : ListView.builder(
                  itemCount: _pesananList.length,
                  itemBuilder: (context, index) {
                    final pesanan = _pesananList[index];

                    // Logika menghitung total harga
                    final hargaSewa = pesanan['harga_sewa'] is int
                        ? pesanan['harga_sewa']
                        : int.tryParse(pesanan['harga_sewa'].toString()) ?? 0;

                    final berapaBulan = pesanan['berapa_bulan'] is int
                        ? pesanan['berapa_bulan']
                        : int.tryParse(pesanan['berapa_bulan'].toString()) ?? 0;

                    final totalHarga = hargaSewa * berapaBulan;

                    return Dismissible(
                      key: ValueKey(pesanan['id']),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        _konfirmasiHapusPesanan(pesanan['id']);
                        return false; // Jangan langsung hapus, tunggu konfirmasi
                      },
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Card(
                        margin: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Nama Pemesan: ${pesanan['nama_pemesan']}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('Nama Kos: ${pesanan['nama_kos']}'),
                                    Text(
                                        'Alamat Kos: ${pesanan['alamat_kos']}'),
                                    Text(
                                        'Jumlah Kamar: ${pesanan['jumlah_kamar']}'),
                                    Text(
                                        'Jumlah Bulan: ${pesanan['berapa_bulan']}'),
                                    Text(
                                        'Tanggal Survey: ${pesanan['tanggal_survey']}'),
                                    Text('Email: ${pesanan['email']}'),
                                    Text('Harga Sewa /Bulan: Rp $hargaSewa'),
                                    Text(
                                      'Total Harga Sewa : Rp $totalHarga',
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Image.asset(
                                'assets/images/kosan.jpg', // Ganti dengan gambar Anda
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
