import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PesananScreen extends StatefulWidget {
  final String email;

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
      final response = await Supabase.instance.client
          .from('pesanan')
          .select()
          .eq('email_pemilik', widget.email)
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

  Future<void> _updateStatus(int id, String newStatus) async {
    try {
      await Supabase.instance.client
          .from('pesanan')
          .update({'status': newStatus}).eq('id', id);

      setState(() {
        final pesanan =
            _pesananList.firstWhere((pesanan) => pesanan['id'] == id);
        pesanan['status'] = newStatus;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status berhasil diperbarui.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui status: $e')),
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
                Navigator.of(context).pop();
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _hapusPesanan(id);
              },
              child: const Text('Iya'),
            ),
          ],
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pesananList.isEmpty
              ? const Center(child: Text('Belum ada pesanan.'))
              : ListView.builder(
                  itemCount: _pesananList.length,
                  itemBuilder: (context, index) {
                    final pesanan = _pesananList[index];

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
                        return false;
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
                                    Row(
                                      children: [
                                        const Text('Status: '),
                                        DropdownButton<String>(
                                          value: [
                                            'Disetujui',
                                            'Ditolak',
                                            'Pending'
                                          ].contains(pesanan['status'])
                                              ? pesanan['status']
                                              : 'Pending',
                                          items: [
                                            'Disetujui',
                                            'Ditolak',
                                            'Pending'
                                          ].map((status) {
                                            Color statusColor;
                                            switch (status) {
                                              case 'Disetujui':
                                                statusColor = Colors.green;
                                                break;
                                              case 'Ditolak':
                                                statusColor = Colors.red;
                                                break;
                                              case 'Pending':
                                                statusColor = Colors.yellow;
                                                break;
                                              default:
                                                statusColor = Colors.black;
                                                break;
                                            }

                                            return DropdownMenuItem(
                                              value: status,
                                              child: Text(
                                                status,
                                                style: TextStyle(
                                                    color: statusColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            if (newValue != null) {
                                              _updateStatus(
                                                  pesanan['id'], newValue);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Image.asset(
                                'assets/images/kosan.jpg',
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
