import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PesanScreen extends StatefulWidget {
  final Map<String, dynamic> kosData;

  const PesanScreen({super.key, required this.kosData});

  @override
  State<PesanScreen> createState() => _PesanScreenState();
}

class _PesanScreenState extends State<PesanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaPemesanController = TextEditingController();
  final _tanggalSurveyController = TextEditingController();
  final _jumlahKamarController = TextEditingController();
  final _emailPemesanController = TextEditingController();

  Future<void> _konfirmasiPesanan() async {
    if (_formKey.currentState!.validate()) {
      final supabase = Supabase.instance.client;

      try {
        // Kirim data ke Supabase
        final response = await supabase.from('pesanan_kos').insert({
          'nama_pemesan': _namaPemesanController.text,
          'tanggal_survey': _tanggalSurveyController.text,
          'jumlah_kamar': int.tryParse(_jumlahKamarController.text) ?? 1,
          'email_pemesan': _emailPemesanController.text,
          'kos_id': widget.kosData['id'], // Asumsikan kos memiliki ID
        });

        // Debug respons untuk melihat hasil
        print('Response: $response');

        // Tangani kasus respons sukses
        if (response != null && response is Map<String, dynamic>) {
          if (response.containsKey('error') && response['error'] != null) {
            // Jika ada error dalam response
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Gagal memesan: ${response['error']['message']}'),
              ),
            );
          } else {
            // Jika berhasil tanpa error
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Pesanan berhasil dibuat!')),
            );
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          }
        } else {
          // Jika respons tidak valid atau tidak terduga
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Terjadi kesalahan yang tidak terduga')),
          );
        }
      } catch (e) {
        // Menangani kesalahan lain
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesan Kos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pesan kos: ${widget.kosData['nama_kos']}',
                  style: const TextStyle(fontSize: 18)),
              Image.asset('assets/images/kosan.jpg'),
              const SizedBox(height: 8),
              Text('Alamat: ${widget.kosData['alamat_kos'] ?? ''}'),
              Text('Jumlah Kamar: ${widget.kosData['jumlah_kamar'] ?? ''}'),
              Text(
                  'Harga Sewa: Rp ${widget.kosData['harga_sewa'] ?? ''}/bulan'),
              Text('Jenis Kos: ${widget.kosData['jenis_kos'] ?? ''}'),
              Text('Fasilitas: ${widget.kosData['fasilitas'] ?? ''}'),
              Text('Email Pemilik: ${widget.kosData['email_pengguna'] ?? ''}'),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _namaPemesanController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Pemesan',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama pemesan wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _tanggalSurveyController,
                      decoration: const InputDecoration(
                        labelText: 'Tanggal Survey (YYYY-MM-DD)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tanggal survey wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _jumlahKamarController,
                      decoration: const InputDecoration(
                        labelText: 'Jumlah Kamar',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Jumlah kamar wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailPemesanController,
                      decoration: const InputDecoration(
                        labelText: 'Email Pemesan',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email pemesan wajib diisi';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Email tidak valid';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _konfirmasiPesanan,
                child: const Text('Konfirmasi Pesanan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaPemesanController.dispose();
    _tanggalSurveyController.dispose();
    _jumlahKamarController.dispose();
    _emailPemesanController.dispose();
    super.dispose();
  }
}
