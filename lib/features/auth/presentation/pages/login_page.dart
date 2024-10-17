/* 

Login page
Ont this page, an exixting user can login with their:
- email
- password

--------------------------------------------

Once the user succesfully logged in , they will be redirected to home page.

If user Does not have account yet, they can go to the register page from here to create one.

*/

import 'package:flutter/material.dart';
import 'package:minigram/features/auth/data/firebase_auth_repo.dart';
import 'package:minigram/features/auth/presentation/pages/main_page.dart';
import 'package:minigram/features/auth/presentation/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  final TextEditingController __emailcntrl = TextEditingController();
  final TextEditingController _passcntrl = TextEditingController();
  final FirebaseAuthRepo _fbaseauthrepo = FirebaseAuthRepo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[200], // Light background color
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock,
                size: 80,
                color: Colors.grey[600], // Lock icon color
              ),
              const SizedBox(height: 20),
              Text(
                "Welcome back, you've been missed!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 30),
              // Email TextField
              TextField(
                controller: __emailcntrl,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Password TextField
              TextField(
                controller: _passcntrl,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    child: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle login action
                    _fbaseauthrepo.loginWithEmailPassword(
                        __emailcntrl.text, _passcntrl.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const HomeScreen()), // Replace MainPage with your actual page class
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Bottom "Not a member? Register now" text
              GestureDetector(
                onTap: () {
                  // Navigate to Register page
                },
                child: RichText(
                  text: TextSpan(
                    text: "Not a member? ",
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                    children: [
                      TextSpan(
                        onEnter: (event) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage()));
                        },
                        text: "Register now",
                        style: const TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
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

// Sample RegisterPage for navigation
// class RegisterPage extends StatelessWidget {
//   const RegisterPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Register")),
//       body: const Center(child: Text("Registration Page")),
//     );
//   }
// }
