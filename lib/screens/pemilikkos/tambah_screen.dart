// tambah_screen.dart
import 'package:flutter/material.dart';
import 'tambahkosform_screen.dart';

class TambahScreen extends StatelessWidget {
  final String email;

  const TambahScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Kosan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TambahKosForm(email: email),
      ),
    );
  }
}
