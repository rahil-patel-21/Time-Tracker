import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:techaddict21/Platform_Widget.dart';
import 'package:techaddict21/SignInButton.dart';
import 'package:techaddict21/Validators.dart';

import 'Auth.dart';
import 'emailSIgnInModelBloc.dart';
import 'EmailSignInFormBlocBased.dart';

class EmailSignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email Sign In'),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(child: EmailSignInFormBlocBased.create(context)),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}

// class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators {
//   @override
//   _EmailSignInFormState createState() => _EmailSignInFormState();
// }

// class _EmailSignInFormState extends State<EmailSignInForm> {
//   final emailFieldController = TextEditingController();
//   final passwordFieldController = TextEditingController();
//   final _emailFocusNode = FocusNode();
//   final _passwordFocusNode = FocusNode();
//   bool submitted = false;
//   bool _isLoading = false;

//   String get _email => emailFieldController.text;
//   String get _password => passwordFieldController.text;

//   FormType _formType = FormType.signIn;

//   void _onEmailNext() {
//     final _emailFocus = widget.emailValidator.isValid(_email)
//         ? _passwordFocusNode
//         : _emailFocusNode;
//     FocusScope.of(context).requestFocus(_emailFocus);
//   }

//   void onSecondarySubmit() {
//     setState(() {
//       submitted = false;
//       _formType =
//           _formType == FormType.signIn ? FormType.signUp : FormType.signIn;
//     });
//     emailFieldController.clear();
//     passwordFieldController.clear();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _emailFocusNode.dispose();
//     _passwordFocusNode.dispose();
//     emailFieldController.dispose();
//     passwordFieldController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final primaryText =
//         _formType == FormType.signIn ? 'Sign In' : 'Create An Account';
//     final secondaryText = _formType == FormType.signIn
//         ? 'New User ? Sign Up Here'
//         : 'Already Have An Account ? Sign In Here';

//     bool emailValid = submitted && !widget.emailValidator.isValid(_email);
//     bool passwordValid =
//         submitted && !widget.passwordValidator.isValid(_password);
//     bool activeButton = widget.emailValidator.isValid(_email) &&
//         widget.passwordValidator.isValid(_password) &&
//         !_isLoading;
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: <Widget>[
//           TextField(
//             onChanged: (emailText) {
//               _updateState();
//             },
//             focusNode: _emailFocusNode,
//             controller: emailFieldController,
//             decoration: InputDecoration(
//                 enabled: !_isLoading,
//                 labelText: 'Email',
//                 errorText: emailValid ? widget.emailValidError : null),
//             autocorrect: false,
//             keyboardType: TextInputType.emailAddress,
//             textInputAction: TextInputAction.next,
//             onEditingComplete: _onEmailNext,
//           ),
//           SizedBox(height: 5.0),
//           TextField(
//             onChanged: (passwordText) {
//               _updateState();
//             },
//             focusNode: _passwordFocusNode,
//             controller: passwordFieldController,
//             decoration: InputDecoration(
//                 enabled: !_isLoading,
//                 labelText: 'Password',
//                 errorText: passwordValid ? widget.passwordValidError : null),
//             obscureText: true,
//             textInputAction: TextInputAction.done,
//             onEditingComplete: () => onSignInSubmit(context),
//           ),
//           SizedBox(height: 16.0),
//           FormSubmitButton(
//             text: primaryText,
//             onPressed: () => activeButton ? onSignInSubmit(context) : null,
//           ),
//           FlatButton(
//             onPressed: !_isLoading ? onSecondarySubmit : null,
//             child: Text(secondaryText),
//           ),
//         ],
//       ),
//     );
//   }

//   void _updateState() {
//     setState(() {});
//   }
// }
