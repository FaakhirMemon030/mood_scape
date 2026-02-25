import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  bool get isAdmin => _currentUser?.isAdmin ?? false;

  // 🔹 Login
  Future<bool> login(String email, String password) async {
    try {
      // 🔹 Default Admin Login
      if (email == "admin@moodscope.com" && password == "moodscope12##") {
        final snapshot = await _firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          final data = snapshot.docs.first.data();
          _currentUser = UserModel.fromMap(data);
          notifyListeners();
          return true;
        } else {
          // Admin document missing in Firestore
          return false;
        }
      }

      // 🔐 Regular Firebase Auth
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      final userDoc =
          await _firestore.collection('users').doc(credential.user!.uid).get();

      if (!userDoc.exists) {
        // User document missing
        return false;
      }

      _currentUser = UserModel.fromMap(userDoc.data()!);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Login Error: $e");
      return false;
    }
  }

  // 🔹 Signup
  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      _currentUser = UserModel(
        uid: credential.user!.uid,
        name: name,
        email: email,
        isAdmin: false,
      );

      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(_currentUser!.toMap());

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Signup Error: $e");
      return false;
    }
  }

  // 🔹 Logout
  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
    await _auth.signOut();
  }
}
