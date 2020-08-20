import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:techaddict21/Auth.dart';
import 'package:techaddict21/Platform_Widget.dart';
import 'package:techaddict21/SignInButton.dart';
import 'emailSIgnInModelBloc.dart';

class EmailSignInFormBlocBased extends StatefulWidget {
  EmailSignInFormBlocBased({@required this.bLoc});
  final EmailSignInModelBLoc bLoc;

  static Widget create(BuildContext context) {
    final AuthBase authBase = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInModelBLoc>(
      create: (context) => EmailSignInModelBLoc(authBase: authBase),
      child: Consumer<EmailSignInModelBLoc>(
        builder: (context, bLoc, _) => EmailSignInFormBlocBased(bLoc: bLoc),
      ),
      dispose: (context, bLoc) => bLoc.dispose(),
    );
  }

  @override
  _EmailSignInFormBlocBasedState createState() =>
      _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
  final emailFieldController = TextEditingController();
  final passwordFieldController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  void _onEmailNext(EmailSignInModel emailSignInModel) {
    final _emailFocus =
        emailSignInModel.emailValidator.isValid(emailSignInModel.email)
            ? _passwordFocusNode
            : _emailFocusNode;
    FocusScope.of(context).requestFocus(_emailFocus);
  }

  void onSecondarySubmit() {
    widget.bLoc.onSecondarySubmit();
    emailFieldController.clear();
    passwordFieldController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    emailFieldController.dispose();
    passwordFieldController.dispose();
  }

  Future<void> onSignInSubmit() async {
    try {
      await widget.bLoc.onSignInSubmit();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlert(title: 'Sign in Failed', platformException: e)
          .show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bLoc.emailSignInModelStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          final EmailSignInModel emailSignInModel = snapshot.data;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  onChanged: widget.bLoc.updateEmail,
                  focusNode: _emailFocusNode,
                  controller: emailFieldController,
                  decoration: InputDecoration(
                      enabled: !emailSignInModel.isLoading,
                      labelText: 'Email',
                      errorText: emailSignInModel.emailValid
                          ? emailSignInModel.emailValidError
                          : null),
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => _onEmailNext(emailSignInModel),
                ),
                SizedBox(height: 5.0),
                TextField(
                  onChanged: widget.bLoc.updatePassword,
                  focusNode: _passwordFocusNode,
                  controller: passwordFieldController,
                  decoration: InputDecoration(
                      enabled: !emailSignInModel.isLoading,
                      labelText: 'Password',
                      errorText: emailSignInModel.passwordValid
                          ? emailSignInModel.passwordValidError
                          : null),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onEditingComplete: () => widget.bLoc.onSignInSubmit(),
                ),
                SizedBox(height: 16.0),
                FormSubmitButton(
                  text: emailSignInModel.primaryText,
                  onPressed: () => emailSignInModel.activeButton
                      ? widget.bLoc.onSignInSubmit()
                      : null,
                ),
                FlatButton(
                  onPressed:
                      !emailSignInModel.isLoading ? onSecondarySubmit : null,
                  child: Text(emailSignInModel.secondaryText),
                ),
              ],
            ),
          );
        });
  }
}
