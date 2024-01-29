import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import '../models/UserModel.dart';

class AuthServiceProvider with ChangeNotifier {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _currentUser;
  User? get currentUser => _currentUser;

  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().asyncMap(_fetchUserData);
  }

  Future<User?> _fetchUserData(auth.User? firebaseUser) async {
    if (firebaseUser == null) {
      return null;
    }

    var snapshot =
        await _firestore.collection('users').doc(firebaseUser.uid).get();
    var userData = snapshot.data();

    bool hasCompletedSetup = userData?['hasCompletedSetup'] ?? false;
    String? selectedInterest = userData?['selectedInterest'];

    _currentUser = User(firebaseUser.uid, firebaseUser.email,
        hasCompletedSetup: hasCompletedSetup,
        selectedInterest: selectedInterest);

    return _currentUser;
  }

  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final firebaseUser = credential.user;

      if (firebaseUser != null) {
        await _firestore.collection('users').doc(firebaseUser.uid).set({
          'email': firebaseUser.email,
          'hasCompletedSetup': false, // default value for new users
        });

        return _fetchUserData(firebaseUser);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return _fetchUserData(credential.user);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> updateUserInterest(String userId, String interest) async {
    await _firestore.collection('users').doc(userId).update({
      'selectedInterest': interest,
    });

    if (_currentUser != null) {
      _currentUser!.selectedInterest = interest;
      notifyListeners();
    }
  }

  Future<void> completeSetup(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'hasCompletedSetup': true,
    });

    if (_currentUser != null) {
      _currentUser!.hasCompletedSetup = true;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
