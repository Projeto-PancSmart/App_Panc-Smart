import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show debugPrint;

import '../models/user.dart';

class AuthService {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User _userFromFirebase(fb.User? user) {
    if (user == null) return User(uid: '', email: '', name: '');
    return User(
      uid: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
    );
  }

  Stream<User?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  Future<User?> signIn(String email, String password) async {
    try {
      final fb.UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromFirebase(result.user);
    } catch (e) {
      debugPrint('Erro no login: $e');
      return null;
    }
  }

  Future<User?> register(String email, String password, String name) async {
    try {
      final fb.UserCredential result =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final fb.User? user = result.user;
      if (user != null) {
        await user.updateDisplayName(name);
        await user.reload();
        final fb.User? freshUser = _auth.currentUser;
        try {
          final uidToWrite = freshUser?.uid ?? user.uid;
          var success = false;
          for (var attempt = 1; attempt <= 4; attempt++) {
            try {
              await _firestore.collection('usuarios').doc(uidToWrite).set({
                'uid': uidToWrite,
                'nome': name,
                'email': email,
                'createdAt': FieldValue.serverTimestamp(),
              });
              success = true;
              break;
            } on FirebaseException catch (e) {
              if (e.code == 'permission-denied') {
                debugPrint('Attempt $attempt: permission-denied, retrying...');
                await Future.delayed(Duration(milliseconds: 200 * attempt));
                continue;
              }
              debugPrint(
                  'Firestore error when saving user: ${e.code} ${e.message}');
              break;
            }
          }
          if (!success) {
            debugPrint(
                'Failed to save user document after retries; user exists in Auth but document missing.');
          }
        } catch (e) {
          debugPrint('Unexpected error when saving user doc: $e');
        }
      }
      return _userFromFirebase(user);
    } on fb.FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException ao registrar: ${e.code} ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Erro ao registrar: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('Erro ao sair: $e');
    }
  }
  
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint('Erro ao enviar e-mail de recuperação: $e');
    }
  }
  fb.User? get currentFirebaseUser => _auth.currentUser;
}
