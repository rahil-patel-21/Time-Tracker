import 'dart:async';

import 'package:flutter/foundation.dart';

import 'Auth.dart';

class SignInPageBloc {
  SignInPageBloc({@required this.authBase, @required this.isLoading});

  final AuthBase authBase;
  final ValueNotifier<bool> isLoading;

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<User> signInAnonymously() async =>
      await _signIn(authBase.signInAnonymously);
  Future<User> signInWithGoogle() async =>
      await _signIn(authBase.signInWithGoogle);
  Future<User> signInWithFacebook() async =>
      await _signIn(authBase.signInWithFacebook);
}
