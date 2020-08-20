import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  User({@required this.userID});
  final String userID;
}

abstract class AuthBase {
  Stream<User> get onAuthStateChanged;
  Future<User> currentUser();
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<User> signInwithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(String email, String password);
  Future<User> signInAnonymously();
  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  User _firebaseUser(FirebaseUser _firebaseUser) {
    if (_firebaseUser == null) {
      return null;
    }
    return User(userID: _firebaseUser.uid);
  }

  @override
  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_firebaseUser);
  }

  @override
  Future<User> currentUser() async {
    final user = await _firebaseAuth.currentUser();
    return _firebaseUser(user);
  }

  @override
  Future<User> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final googleSignInAuthentication =
          await googleSignInAccount.authentication;
      if (googleSignInAuthentication.accessToken != null &&
          googleSignInAuthentication.idToken != null) {
        final authResult = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.getCredential(
              idToken: googleSignInAuthentication.idToken,
              accessToken: googleSignInAuthentication.accessToken),
        );
        return _firebaseUser(authResult.user);
      } else {
        throw PlatformException(
          code: 'GOOGLE_SIGN_IN_AUTHENTICATION_TOKEN_IS_MISSING',
          message: 'Google Sign In Authentication Token is Missing',
        );
      }
    } else {
      throw PlatformException(
        code: 'SIGN_IN_PROCESS_ABORTED',
        message: 'Sign in Process Aborted',
      );
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    final facebookLogIn = FacebookLogin();
    final facebookLogInAuthentication =
        await facebookLogIn.logInWithReadPermissions(
      ['public_profile'],
    );
    if (facebookLogInAuthentication.accessToken != null) {
      final authResult = await _firebaseAuth.signInWithCredential(
        FacebookAuthProvider.getCredential(
            accessToken: facebookLogInAuthentication.accessToken.token),
      );
      return _firebaseUser(authResult.user);
    } else {
      throw PlatformException(
        code: 'SIGN_IN_PROCESS_ABORTED',
        message: 'Sign in Process Aborted',
      );
    }
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _firebaseUser(authResult.user);
  }

  @override
  Future<User> signInwithEmailAndPassword(String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _firebaseUser(authResult.user);
  }

  @override
  Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _firebaseUser(authResult.user);
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final facebookLogIn = FacebookLogin();
    await facebookLogIn.logOut();
    await _firebaseAuth.signOut();
  }
}
