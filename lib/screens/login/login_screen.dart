import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_text_field.dart';
// import '../../widgets/custom_snackbar.dart';
import '../register/register_screen.dart';
import '../pemilikkos/pemilikkos_screen.dart';
import '../pencarikos/pencarikos_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    final authService = AuthService();

    Future<void> loginUser() async {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter both email and password')),
        );
        return;
      }

      final response = await authService.loginUser(
        email: email,
        password: password,
      );

      if (response == null || response['error'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Incorrect credentials.')),
        );
        return;
      }

      final role = response['role'];
      final userEmail = response['email'];

      if (role == 'pemilik') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PemilikKosScreen(email: userEmail),
          ),
        );
      } else if (role == 'pencari') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PencariKosScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid role. Please try again.')),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey, // Mengubah background menjadi abu-abu
      appBar: AppBar(
        backgroundColor: Colors.grey, // AppBar juga berwarna abu-abu
        elevation: 0,
        title: const Center(
          child: Text(
            'Login',
            style: TextStyle(
              fontWeight: FontWeight.bold, // Membuat teks Login menjadi tebal
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo di atas
              Center(
                child: Image.asset(
                  'assets/images/logoutbkos.png', // Path logo Anda
                  height: 150, // Logo lebih besar
                ),
              ),
              const SizedBox(height: 30),

              // Card untuk form dan tombol
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: emailController,
                        label: 'Email',
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: passwordController,
                        label: 'Password',
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: loginUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.blue, // Tombol dengan warna biru
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Belum mempunyai akun? Sign up",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
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
