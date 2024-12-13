import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for rootBundle
import 'package:get/get.dart';
import 'package:vitap/Services/Controller/LoginController.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginController = Get.put(LoginController());
  final TextEditingController usernamController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool loading = false;
  String message = '';

  void login() async {
    if (usernamController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      final bool? agreed = await _showTermsAndConditionsDialog(context);
      if (agreed != true) {
        setState(() {
          message = 'You must agree to the terms and conditions to proceed.';
          loading = false;
        });
        return;
      }

      setState(() => loading = true);

      loginController
          .login(usernamController.text, passwordController.text, context)
          .then((value) {
        log(value['profile'].toString());
        setState(() {
          message = loginController.message.value;
          loading = false;
          usernamController.clear();
          passwordController.clear();
          FocusScope.of(context).unfocus();
        });
      });
    } else {
      setState(() {
        message = "Please enter all fields";
      });
    }
  }

  Future<String> loadTermsAndConditions() async {
    return await rootBundle.loadString('assets/terms_and_conditions.txt');
  }

  Future<bool?> _showTermsAndConditionsDialog(BuildContext context) async {
    final termsAndConditions = await loadTermsAndConditions();

    // Split the content into lines
    final lines = termsAndConditions.split('\n');

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Terms and Conditions'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: lines.map((line) {
                // Check if the line is a heading (starts with "### ")
                if (line.startsWith('### ')) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      line.replaceFirst('### ', ''),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      line,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14.0,
                        color: Colors.black87,
                      ),
                    ),
                  );
                }
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User did not agree
              },
              child: const Text('Decline'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User agreed
              },
              child: const Text('Agree'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  _buildTitle(),
                  const SizedBox(height: 24.0),
                  _buildTextField(
                    controller: usernamController,
                    hintText: 'Enter your registration no',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16.0),
                  if (message.isNotEmpty)
                    Text(message, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 24.0),
                  _buildLoginButton(),
                ],
              ),
            ),
            if (loading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text(
          'VIT-AP',
          style: TextStyle(
            color: Colors.white,
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Welcome back',
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(
          'Sign in to access your account',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: login,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: Colors.blue,
        elevation: 5,
      ),
      child: const Text(
        'Next',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
