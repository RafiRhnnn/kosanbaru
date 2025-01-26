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
          .eq('email', widget.email) // Filter berdasarkan email
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
      backgroundColor: Colors.grey, // Warna background estetik
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
                        margin: const EdgeInsets.all(12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/kosan.jpg', // Ganti dengan gambar Anda
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      pesanan['nama_pemesan'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      pesanan['nama_kos'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text('Alamat: ${pesanan['alamat_kos']}',
                                        style: const TextStyle(fontSize: 14)),
                                    Text(
                                        'Jumlah Kamar: ${pesanan['jumlah_kamar']}',
                                        style: const TextStyle(fontSize: 14)),
                                    Text(
                                        'Tanggal Survey: ${pesanan['tanggal_survey']}',
                                        style: const TextStyle(fontSize: 14)),
                                    Text('Harga Sewa/Bulan: Rp $hargaSewa',
                                        style: const TextStyle(fontSize: 14)),
                                    Text(
                                      'Total Harga: Rp $totalHarga',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
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
