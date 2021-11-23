import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthBase {
  Stream<User?> authChanges();
  User? get user;
  // Future<User?> signInAnonymously();
  // Future<User?> signInWithGoogle();
  Future<void> signOut();
  // Future<User?> signInWithFacebook();
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

  // @override
  // Future<User?> signInAnonymously() async {
  //   final userCredential = await _firebaseAuth.signInAnonymously();
  //   return userCredential.user;
  // }

  // @override
  // Future<User?> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //     final GoogleSignInAuthentication? googleAuth =
  //         await googleUser!.authentication;

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth!.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //     final userCredentials =
  //         await _firebaseAuth.signInWithCredential(credential);
  //     return userCredentials.user;
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

  // @override
  // Future<User?> signInWithFacebook() async {
  //   try {
  //     final LoginResult result = await FacebookAuth.instance.login();
  //     if (result.status == LoginStatus.success) {
  //       final OAuthCredential credential =
  //           FacebookAuthProvider.credential(result.accessToken!.token);

  //       final userCredentials =
  //           await FirebaseAuth.instance.signInWithCredential(credential);
  //       return userCredentials.user;
  //     }
  //     return null;
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

  @override
  Future<void> signOut() async {
    // final googleSignIn = GoogleSignIn();
    // await googleSignIn.signOut();
    // await FacebookAuth.instance.logOut();

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
