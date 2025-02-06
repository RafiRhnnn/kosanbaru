import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScreenBantuan extends StatefulWidget {
  final String email;

  const ScreenBantuan({super.key, required this.email});

  @override
  _ScreenBantuanState createState() => _ScreenBantuanState();
}

class _ScreenBantuanState extends State<ScreenBantuan> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate()) {
      final supabase = Supabase.instance.client;
      await supabase.from('laporan').insert({
        'nama': _nameController.text,
        'nomor_telepon': _phoneController.text,
        'email': _emailController.text,
        'pesan': _messageController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Laporan berhasil dikirim')),
      );
      _nameController.clear();
      _phoneController.clear();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bantuan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/images/logobaru.png', height: 100),
              const SizedBox(height: 20),
              const Text(
                'HUBUNGI KAMI',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const ListTile(
                leading: Icon(Icons.email, color: Colors.blue),
                title: Text('Email: mikhsanfura@gmail.com'),
              ),
              const ListTile(
                leading: Icon(Icons.phone, color: Colors.blue),
                title: Text('No Telepon: +62 813-9970-5979'),
              ),
              const SizedBox(height: 20),
              const Text('Formulir Laporan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Nama Kamu'),
                      validator: (value) =>
                          value!.isEmpty ? 'Masukkan nama' : null,
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration:
                          const InputDecoration(labelText: 'Nomor Telepon'),
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          value!.isEmpty ? 'Masukkan nomor telepon' : null,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      readOnly: true,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextFormField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          labelText: 'Tulis Pesan',
                          border: InputBorder.none,
                        ),
                        maxLines: 4,
                        validator: (value) =>
                            value!.isEmpty ? 'Masukkan pesan' : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Kirim'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
