import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthBase {
  Stream<User?> authChanges();
  User? get user;
  Future<void> signOut();
  Future<void> forgetPassword(String email);
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<User?> createAccountWithEmailAndPassword(
      String email, String password);
}

class Auth extends AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  User? get user => _firebaseAuth.currentUser!;

  @override
  Stream<User?> authChanges() => _firebaseAuth.authStateChanges();

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> forgetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<User?> createAccountWithEmailAndPassword(
      String email, String? password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password.toString());

    return userCredential.user;
  }

  @override
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithCredential(
      EmailAuthProvider.credential(email: email, password: password),
    );
    return userCredential.user;
  }
}
