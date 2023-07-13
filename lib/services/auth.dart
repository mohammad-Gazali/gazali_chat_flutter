import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gazali_chat/services/firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;

  static User? get user => _auth.currentUser;
  static Stream<User?> get userStream => _auth.authStateChanges();

  static Future<void> googleLogin() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(authCredential);

      if (userCredential.user != null) {
        // creating document in "users" collection in firestore
        FirestoreService.addUserDocument(
            userId: userCredential.user!.uid,
            name: userCredential.user?.displayName ?? '',
            email: userCredential.user?.email ?? '');
      }
    } on FirebaseAuthException catch (err) {
      debugPrint(err.message);
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  static Future<void> login({required String email, required String password}) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> createUser({
    required String email,
    required String password,
    required String name,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user != null) {
      userCredential.user?.updateDisplayName(name);

      // creating document in "users" collection in firestore
      FirestoreService.addUserDocument(
        userId: userCredential.user!.uid,
        name: name,
        email: email,
      );
    }
  }

  static Future<void> signOut() {
    return _auth.signOut();
  }

  static Future<void> updateDisplayName(String name) async {
    if (user?.displayName == name) return;
    try {
      await _auth.currentUser?.updateDisplayName(name);

      // editing user document in "users" collection in firestore
      return FirestoreService.editNameUserDocument(
          id: _auth.currentUser?.uid, newName: name);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
