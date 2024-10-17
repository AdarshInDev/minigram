import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minigram/features/auth/data/firebase_auth_repo.dart';
import 'package:minigram/features/auth/presentation/pages/login_page.dart';


import '../../domain/entities/app_user.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuthRepo _fbaserepo = FirebaseAuthRepo();
  AppUser? _currentUser;

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Sign out the user from Firebase
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const LoginPage()), // Redirect to login page
      );
    } catch (e) {
      // Handle logout errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error logging out: ${e.toString()}'),
        ),
      );
    }
  }

  fetchUSer() async {
    _currentUser = await _fbaserepo.getCurrentUser();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUSer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the HomeScreen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Profile picture
            const Center(
              child: CircleAvatar(
                radius: 80,
                
              ),
            ),
            const SizedBox(height: 20),

            // Username
            const Text(
              "Test User",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Email
            Text(
              _currentUser == null ? "" : _currentUser!.email,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Bio
            const Text(
              'This is a short bio or description of the user. Add something about yourself here.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // Profile actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                 
                    print('Edit Profile Pressed');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  child: const Text('Edit Profile'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _logout(context); // Calls the logout function
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  child: const Text('Logout'),
                ),
              ],
            ),
          ],
        ),
      ), 
    );
  }
}
