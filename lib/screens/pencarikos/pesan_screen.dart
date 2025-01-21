import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PesanScreen extends StatefulWidget {
  final Map<String, dynamic> kosData;

  const PesanScreen({
    super.key,
    required this.kosData,
  });

  @override
  State<PesanScreen> createState() => _PesanScreenState();
}

class _PesanScreenState extends State<PesanScreen> {
  final _namaPemesanController = TextEditingController();
  final _jumlahKamarController = TextEditingController();
  final _tanggalSurveyController = TextEditingController();
  final _emailController = TextEditingController();

  Future<void> _pesanKosan() async {
    final namaPemesan = _namaPemesanController.text;
    final jumlahKamar = int.tryParse(_jumlahKamarController.text);
    final tanggalSurvey = _tanggalSurveyController.text;
    final email = _emailController.text;

    if (namaPemesan.isEmpty ||
        jumlahKamar == null ||
        tanggalSurvey.isEmpty ||
        email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua field dengan benar!')),
      );
      return;
    }

    try {
      final response = await Supabase.instance.client.from('pesanan').insert({
        'nama_pemesan': namaPemesan,
        'jumlah_kamar': jumlahKamar,
        'tanggal_survey': tanggalSurvey,
        'email': email,
        'nama_kos': widget.kosData['nama_kos'],
        'alamat_kos': widget.kosData['alamat_kos'],
      });

      // Periksa apakah response gagal
      if (response != null &&
          response is Map &&
          response.containsKey('error')) {
        throw Exception(response['error']['message']);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pesanan berhasil dibuat!')),
      );

      // Reset form
      _namaPemesanController.clear();
      _jumlahKamarController.clear();
      _tanggalSurveyController.clear();
      _emailController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membuat pesanan: $e')),
      );
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
              Text('Alamat: ${widget.kosData['alamat_kos']}'),
              Text('Harga: Rp ${widget.kosData['harga_sewa']}/bulan'),
              Text('Jenis Kos: ${widget.kosData['jenis_kos'] ?? ''}'),
              Text('Fasilitas: ${widget.kosData['fasilitas'] ?? ''}'),
              Text('Email Pemilik: ${widget.kosData['email_pengguna'] ?? ''}'),
              const SizedBox(height: 16),
              TextField(
                controller: _namaPemesanController,
                decoration: const InputDecoration(
                  labelText: 'Nama Pemesan',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _jumlahKamarController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Kamar',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _tanggalSurveyController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Survey (YYYY-MM-DD)',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pesanKosan,
                child: const Text('Konfirmasi Pesanan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
