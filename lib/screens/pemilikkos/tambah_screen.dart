import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TambahScreen extends StatefulWidget {
  final String email;

  const TambahScreen({super.key, required this.email});

  @override
  _TambahScreenState createState() => _TambahScreenState();
}

class _TambahScreenState extends State<TambahScreen> {
  final _formKey = GlobalKey<FormState>();
  final _supabase = Supabase.instance.client;

  // Input Controllers
  final _namaKosController = TextEditingController();
  final _alamatKosController = TextEditingController();
  final _jumlahKamarController = TextEditingController();
  final _hargaSewaController = TextEditingController();
  final _fasilitasController = TextEditingController();

  // Jenis Kos
  String? _jenisKos;
  final List<String> _jenisKosOptions = ['Campur', 'Laki-laki', 'Perempuan'];

  Future<void> _simpanData() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _supabase.from('tambahkos').insert({
          'nama_kos': _namaKosController.text,
          'alamat_kos': _alamatKosController.text,
          'jumlah_kamar': int.parse(_jumlahKamarController.text),
          'harga_sewa': double.parse(_hargaSewaController.text),
          'jenis_kos': _jenisKos,
          'fasilitas': _fasilitasController.text,
          'email_pengguna': widget.email, // Menggunakan email dari login
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil disimpan!')),
        );
        _formKey.currentState!.reset();
        setState(() {
          _jenisKos = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Kosan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaKosController,
                decoration: const InputDecoration(labelText: 'Nama Kos'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama kos harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _alamatKosController,
                decoration: const InputDecoration(labelText: 'Alamat Kos'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat kos harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _jumlahKamarController,
                decoration:
                    const InputDecoration(labelText: 'Jumlah Kamar Tersedia'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah kamar harus diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _hargaSewaController,
                decoration:
                    const InputDecoration(labelText: 'Harga Sewa per Bulan'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga sewa harus diisi';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _jenisKos,
                items: _jenisKosOptions.map((String jenis) {
                  return DropdownMenuItem<String>(
                    value: jenis,
                    child: Text(jenis),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Jenis Kos'),
                onChanged: (value) {
                  setState(() {
                    _jenisKos = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Pilih jenis kos';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fasilitasController,
                decoration: const InputDecoration(labelText: 'Fasilitas'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Fasilitas harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: widget.email, // Email dari login
                enabled: false, // Tidak dapat diubah oleh pengguna
                decoration: const InputDecoration(labelText: 'Email Pengguna'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _simpanData,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
