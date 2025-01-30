import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_snackbar.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final roleController = TextEditingController();

    final authService = AuthService();

    Future<void> registerUser() async {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final role = roleController.text.trim();

      if (email.isEmpty || password.isEmpty || role.isEmpty) {
        CustomSnackbar.show(
          context,
          'Please complete all fields',
        );
        return;
      }

      final errorMessage = await authService.registerUser(
        email: email,
        password: password,
        role: role,
      );

      if (errorMessage != null) {
        CustomSnackbar.show(context, errorMessage);
        return;
      }

      CustomSnackbar.show(
        context,
        'Registration successful!',
        isError: false,
      );
      Navigator.pop(context);
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey, Colors.brown],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Image.asset(
                      'assets/images/logobaru.png',
                      height: 150,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: roleController.text.isEmpty
                                ? null
                                : roleController.text,
                            onChanged: (value) {
                              roleController.text = value ?? '';
                            },
                            items: const [
                              DropdownMenuItem(
                                value: 'pemilik',
                                child: Text('Pemilik'),
                              ),
                              DropdownMenuItem(
                                value: 'pencari',
                                child: Text('Pencari'),
                              ),
                            ],
                            decoration: const InputDecoration(
                              labelText: 'Role (pemilik/pencari)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: registerUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Sudah mempunyai akun? Silahkan login",
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
        ),
      ),
    );
  }
}
