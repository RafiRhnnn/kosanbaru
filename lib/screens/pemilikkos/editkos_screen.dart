import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditKosForm extends StatefulWidget {
  final Map<String, dynamic> kosData;

  const EditKosForm({super.key, required this.kosData});

  @override
  _EditKosFormState createState() => _EditKosFormState();
}

class _EditKosFormState extends State<EditKosForm> {
  final _formKey = GlobalKey<FormState>();
  final _supabase = Supabase.instance.client;

  late TextEditingController _namaKosController;
  late TextEditingController _alamatKosController;
  late TextEditingController _jumlahKamarController;
  late TextEditingController _hargaSewaController;
  late TextEditingController _fasilitasController;

  String? _jenisKos;
  final List<String> _jenisKosOptions = ['Campur', 'Laki-laki', 'Perempuan'];

  @override
  void initState() {
    super.initState();
    _namaKosController =
        TextEditingController(text: widget.kosData['nama_kos']);
    _alamatKosController =
        TextEditingController(text: widget.kosData['alamat_kos']);
    _jumlahKamarController =
        TextEditingController(text: widget.kosData['jumlah_kamar'].toString());
    _hargaSewaController =
        TextEditingController(text: widget.kosData['harga_sewa'].toString());
    _fasilitasController =
        TextEditingController(text: widget.kosData['fasilitas']);
    _jenisKos = widget.kosData['jenis_kos'];
  }

  @override
  void dispose() {
    _namaKosController.dispose();
    _alamatKosController.dispose();
    _jumlahKamarController.dispose();
    _hargaSewaController.dispose();
    _fasilitasController.dispose();
    super.dispose();
  }

  Future<void> _updateData() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _supabase.from('tambahkos').update({
          'nama_kos': _namaKosController.text,
          'alamat_kos': _alamatKosController.text,
          'jumlah_kamar': int.parse(_jumlahKamarController.text),
          'harga_sewa': int.parse(_hargaSewaController.text),
          'jenis_kos': _jenisKos,
          'fasilitas': _fasilitasController.text,
        }).eq('id', widget.kosData['id']);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil diperbarui!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Kos - ${widget.kosData['nama_kos']}'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateData,
              child: const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
