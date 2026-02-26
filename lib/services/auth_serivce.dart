import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

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
      if (email.toLowerCase() == ADMIN_EMAIL && password == ADMIN_PASSWORD) {
        final snapshot = await _firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          _currentUser = UserModel.fromMap(snapshot.docs.first.data());
          notifyListeners();
          return true;
        } else {
          // Admin document missing
          return false;
        }
      }

      // 🔹 Regular User Login
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      final userDoc =
          await _firestore.collection('users').doc(credential.user!.uid).get();

      if (!userDoc.exists) return false;

      _currentUser = UserModel.fromMap(userDoc.data()!);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Login Error: $e");
      return false;
    }
  }

  // 🔹 Signup with Admin Check
  Future<String?> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // 🔹 Detect if Admin
      bool isAdmin =
          email.toLowerCase() == ADMIN_EMAIL && password == ADMIN_PASSWORD;

      // 🔹 Create Firebase Auth User
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // 🔹 Build UserModel
      _currentUser = UserModel(
        uid: credential.user!.uid,
        name: name,
        email: email,
        isAdmin: isAdmin,
      );

      // 🔹 Save to Firestore
      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(_currentUser!.toMap());

      notifyListeners();
      return credential.user!.uid;
    } catch (e) {
      debugPrint("Signup Error: $e");
      return null;
    }
  }

  // 🔹 Logout
  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
    await _auth.signOut();
  }
}
