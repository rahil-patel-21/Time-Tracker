import 'dart:async';

import 'package:flutter/foundation.dart';

import 'Auth.dart';

class SignInPageBloc {
  SignInPageBloc({@required this.authBase});

  final AuthBase authBase;
  final StreamController<bool> _isLoadingController = StreamController<bool>();

  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose() {
    _setIsLoading(false);
    _isLoadingController.close();
  }

  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      _setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      _setIsLoading(false);
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
