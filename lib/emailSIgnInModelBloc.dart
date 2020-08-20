import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:techaddict21/Validators.dart';

import 'Auth.dart';

enum FormType {
  signIn,
  signUp,
}

class EmailSignInModel with EmailAndPasswordValidators {
  EmailSignInModel(
      {this.email = '',
      this.password = '',
      this.formType = FormType.signIn,
      this.isLoading = false,
      this.submitted = false});
  final String email, password;
  final FormType formType;
  final bool isLoading, submitted;

  String get primaryText {
    return formType == FormType.signIn ? 'Sign In' : 'Create An Account';
  }

  String get secondaryText {
    return formType == FormType.signIn
        ? 'New User ? Sign Up Here'
        : 'Already Have An Account ? Sign In Here';
  }

  bool get emailValid {
    return submitted && !emailValidator.isValid(email);
  }

  bool get passwordValid {
    return submitted && !passwordValidator.isValid(password);
  }

  bool get activeButton {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  EmailSignInModel copyWith({
    String email,
    String password,
    FormType formType,
    bool isLoading,
    bool submitted,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }
}

class EmailSignInModelBLoc {
  EmailSignInModelBLoc({@required this.authBase});
  final AuthBase authBase;
  final StreamController<EmailSignInModel> _emailSignInModelController =
      StreamController<EmailSignInModel>();
  Stream<EmailSignInModel> get emailSignInModelStream =>
      _emailSignInModelController.stream;
  EmailSignInModel _emailSignInModel = EmailSignInModel();

  void dispose() {
    _emailSignInModelController.close();
    updateWith(isLoading: false);
  }

  Future<void> onSignInSubmit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (_emailSignInModel.formType == FormType.signIn) {
        await authBase.signInwithEmailAndPassword(
            _emailSignInModel.email, _emailSignInModel.password);
      } else {
        await authBase.createUserWithEmailAndPassword(
            _emailSignInModel.email, _emailSignInModel.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);

  void onSecondarySubmit() {
    final FormType formType = _emailSignInModel.formType == FormType.signIn
        ? FormType.signUp
        : FormType.signIn;
    updateWith(
        email: '',
        password: '',
        submitted: false,
        isLoading: false,
        formType: formType);
  }

  void updateWith({
    String email,
    String password,
    FormType formType,
    bool isLoading,
    bool submitted,
  }) {
    _emailSignInModel = _emailSignInModel.copyWith(
        email: email,
        password: password,
        formType: formType,
        isLoading: isLoading,
        submitted: submitted);
    _emailSignInModelController.add(_emailSignInModel);
  }
}
