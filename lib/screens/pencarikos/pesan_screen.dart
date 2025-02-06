import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PesanScreen extends StatefulWidget {
  final Map<String, dynamic> kosData;
  final String email;

  const PesanScreen({
    super.key,
    required this.kosData,
    required this.email,
  });

  @override
  State<PesanScreen> createState() => _PesanScreenState();
}

class _PesanScreenState extends State<PesanScreen> {
  final _namaPemesanController = TextEditingController();
  final _jumlahKamarController = TextEditingController();
  final _tanggalSurveyController = TextEditingController();
  final _berapaBulanController = TextEditingController();
  final _statusController = TextEditingController(text: 'pending');

  Future<void> _pesanKosan() async {
    final namaPemesan = _namaPemesanController.text;
    final jumlahKamar = int.tryParse(_jumlahKamarController.text);
    final tanggalSurvey = _tanggalSurveyController.text;
    final berapaBulan = _berapaBulanController.text;
    final status = _statusController.text;

    if (namaPemesan.isEmpty ||
        jumlahKamar == null ||
        tanggalSurvey.isEmpty ||
        berapaBulan.isEmpty) {
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
        'berapa_bulan': berapaBulan,
        'email': widget.email,
        'nama_kos': widget.kosData['nama_kos'],
        'alamat_kos': widget.kosData['alamat_kos'],
        'harga_sewa': widget.kosData['harga_sewa'],
        'email_pemilik': widget.kosData['email_pengguna'],
        'status': status,
      }).select();

      if (response.isEmpty) {
        throw Exception('Data tidak berhasil disimpan.');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pesanan berhasil dibuat!')),
      );

      _namaPemesanController.clear();
      _jumlahKamarController.clear();
      _berapaBulanController.clear();
      _tanggalSurveyController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membuat pesanan: $e')),
      );
    }
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _tanggalSurveyController.text =
            pickedDate.toIso8601String().split('T')[0];
      });
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
              Text(
                'Pesan kos: ${widget.kosData['nama_kos']}',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          'assets/images/kosan.jpg',
                          width: 120,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Alamat: ${widget.kosData['alamat_kos']}',
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Jenis Kos: ${widget.kosData['jenis_kos'] ?? ''}',
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Fasilitas: ${widget.kosData['fasilitas'] ?? ''}',
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Email Pemilik: ${widget.kosData['email_pengguna'] ?? ''}',
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Harga: Rp ${widget.kosData['harga_sewa']}/bulan',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        controller: _berapaBulanController,
                        decoration: const InputDecoration(
                          labelText: 'Jumlah Bulan',
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _selectDate,
                        child: AbsorbPointer(
                          child: TextField(
                            controller: _tanggalSurveyController,
                            decoration: const InputDecoration(
                              labelText: 'Tanggal Survey (YYYY-MM-DD)',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: widget.email,
                        enabled: false,
                        decoration:
                            const InputDecoration(labelText: 'Email Pengguna'),
                      ),
                      TextFormField(
                        controller: _statusController,
                        enabled: false,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: _pesanKosan,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text('Konfirmasi Pesanan'),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
