import 'package:flutter/material.dart';
import 'dart:async'; // Untuk mengatur durasi splash screen
import 'login/login_screen.dart'; // Mengimpor LoginScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigasi ke LoginScreen setelah beberapa detik
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gambar logo
            Image.asset(
              'assets/images/logobaru.png', // Path ke gambar logo Anda
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            // Animasi loading bar
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: LinearProgressIndicator(
                color: Color.fromARGB(255, 112, 23, 185),
                backgroundColor: Colors.grey, // Warna latar belakang
                minHeight: 5, // Tinggi dari loading bar
              ),
            ),
          ],
        ),
      ),
    );
  }
}
