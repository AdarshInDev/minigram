import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:minigram/features/auth/data/firebase_auth_repo.dart';
import 'package:minigram/features/auth/presentation/pages/login_page.dart';
import 'package:minigram/firebase_options.dart';

import 'features/auth/presentation/pages/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuthRepo _fbaserepo = FirebaseAuthRepo();

  @override
  Widget build(BuildContext context) {
    // Using FutureBuilder to handle async check of user login status
    return MaterialApp(
      title: 'Your App Name',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: _fbaserepo.getCurrentUser(), // Check if a user is logged in
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading spinner while the Firebase auth is checking
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error fetching user status"));
          } else if (snapshot.hasData && snapshot.data != null) {
            // If user is logged in, show the main page
            return const HomeScreen(); // Change to your main page
          } else {
            // If user is not logged in, show the login page
            return const LoginPage(); // Change to your login page
          }
        },
      ),
    );
  }
}
