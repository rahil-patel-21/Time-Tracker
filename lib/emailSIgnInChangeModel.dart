import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:techaddict21/Validators.dart';

import 'Auth.dart';
import 'emailSIgnInModelBloc.dart';

class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  EmailSignInChangeModel(
      {@required this.authBase,
      this.email = '',
      this.password = '',
      this.formType = FormType.signIn,
      this.isLoading = false,
      this.submitted = false});
  String email, password;
  FormType formType;
  bool isLoading, submitted;
  AuthBase authBase;

  Future<void> onSignInSubmit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (formType == FormType.signIn) {
        await authBase.signInwithEmailAndPassword(email, password);
      } else {
        await authBase.createUserWithEmailAndPassword(email, password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

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

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);

  void onSecondarySubmit() {
    final FormType formType =
        this.formType == FormType.signIn ? FormType.signUp : FormType.signIn;
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
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }
}

// class EmailSignInModelBLoc {
//   EmailSignInModelBLoc({@required this.authBase});
//   final AuthBase authBase;
//   final StreamController<EmailSignInChangeModel> _emailSignInModelController =
//       StreamController<EmailSignInChangeModel>();
//   Stream<EmailSignInChangeModel> get emailSignInModelStream =>
//       _emailSignInModelController.stream;
//   EmailSignInChangeModel _emailSignInModel = EmailSignInChangeModel();

//   void dispose() {
//     _emailSignInModelController.close();
//     updateWith(isLoading: false);
//   }

//   Future<void> onSignInSubmit() async {
//     updateWith(submitted: true, isLoading: true);
//     try {
//       if (_emailSignInModel.formType == FormType.signIn) {
//         await authBase.signInwithEmailAndPassword(
//             _emailSignInModel.email, _emailSignInModel.password);
//       } else {
//         await authBase.createUserWithEmailAndPassword(
//             _emailSignInModel.email, _emailSignInModel.password);
//       }
//     } catch (e) {
//       updateWith(isLoading: false);
//       rethrow;
//     }
//   }

//   void updateEmail(String email) => updateWith(email: email);
//   void updatePassword(String password) => updateWith(password: password);

//   void onSecondarySubmit() {
//     final FormType formType = _emailSignInModel.formType == FormType.signIn
//         ? FormType.signUp
//         : FormType.signIn;
//     updateWith(
//         email: '',
//         password: '',
//         submitted: false,
//         isLoading: false,
//         formType: formType);
//   }

//   void updateWith({
//     String email,
//     String password,
//     FormType formType,
//     bool isLoading,
//     bool submitted,
//   }) {
//     _emailSignInModel = _emailSignInModel.copyWith(
//         email: email,
//         password: password,
//         formType: formType,
//         isLoading: isLoading,
//         submitted: submitted);
//     _emailSignInModelController.add(_emailSignInModel);
//   }
// }
