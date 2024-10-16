import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import '../domain/entities/app_user.dart';
import '../domain/repository/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      print("trying to logging in ");
      //attempt sign In
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: '',
      );
      print("sign in successful");
      log("${user.email}  of : ${user.name}With Id  : ${user.uid}");
      return user;
    } catch (error) {
      log("car");
    }
    return null;
  }

  @override
  Future<AppUser?> registerWithEmailPassword(
      String name, String email, String password) async {
    try {
      //attempt to register user In
      log("trying to register the  : $name : $email");
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: '',
      );
      log("${user.email} is registered as new user having name  :${user.name}");
      return user;
    }

    // catch any error....
    catch (error) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = firebaseAuth.currentUser;

    if (firebaseUser == null) {
      return null;
    }
    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email!,
      name: '',
    );
  }
}
