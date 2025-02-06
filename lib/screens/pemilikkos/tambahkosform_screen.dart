import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TambahKosForm extends StatefulWidget {
  final String email;

  const TambahKosForm({super.key, required this.email});

  @override
  _TambahKosFormState createState() => _TambahKosFormState();
}

class _TambahKosFormState extends State<TambahKosForm> {
  final _formKey = GlobalKey<FormState>();
  final _supabase = Supabase.instance.client;

  final _namaKosController = TextEditingController();
  final _alamatKosController = TextEditingController();
  final _jumlahKamarController = TextEditingController();
  final _hargaSewaController = TextEditingController();
  final _fasilitasController = TextEditingController();

  String? _jenisKos;
  final List<String> _jenisKosOptions = ['Campur', 'Laki-laki', 'Perempuan'];

  Future<void> _simpanData() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _supabase.from('tambahkos').insert({
          'nama_kos': _namaKosController.text,
          'alamat_kos': _alamatKosController.text,
          'jumlah_kamar': int.parse(_jumlahKamarController.text),
          'harga_sewa': int.parse(_hargaSewaController.text),
          'jenis_kos': _jenisKos,
          'fasilitas': _fasilitasController.text,
          'email_pengguna': widget.email,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil disimpan!')),
        );
        _formKey.currentState!.reset();
        setState(() {
          _jenisKos = null;
        });

        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
            initialValue: widget.email,
            enabled: false,
            decoration: const InputDecoration(labelText: 'Email Pengguna'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _simpanData,
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
