import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:techaddict21/Auth.dart';
import 'package:techaddict21/Platform_Widget.dart';
import 'package:techaddict21/SignInButton.dart';
import 'emailSIgnInChangeModel.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  EmailSignInFormChangeNotifier({@required this.model});
  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final AuthBase authBase = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (context) => EmailSignInChangeModel(authBase: authBase),
      child: Consumer<EmailSignInChangeModel>(
        builder: (context, model, _) =>
            EmailSignInFormChangeNotifier(model: model),
      ),
    );
  }

  @override
  _EmailSignInFormChangeNotifierState createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  EmailSignInChangeModel get model => widget.model;
  final emailFieldController = TextEditingController();
  final passwordFieldController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  void _onEmailNext() {
    final _emailFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(_emailFocus);
  }

  void onSecondarySubmit() {
    model.onSecondarySubmit();
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
      await model.onSignInSubmit();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlert(title: 'Sign in Failed', platformException: e)
          .show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            onChanged: model.updateEmail,
            focusNode: _emailFocusNode,
            controller: emailFieldController,
            decoration: InputDecoration(
                enabled: !model.isLoading,
                labelText: 'Email',
                errorText: model.emailValid ? model.emailValidError : null),
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onEditingComplete: () => _onEmailNext(),
          ),
          SizedBox(height: 5.0),
          TextField(
            onChanged: model.updatePassword,
            focusNode: _passwordFocusNode,
            controller: passwordFieldController,
            decoration: InputDecoration(
                enabled: !model.isLoading,
                labelText: 'Password',
                errorText:
                    model.passwordValid ? model.passwordValidError : null),
            obscureText: true,
            textInputAction: TextInputAction.done,
            onEditingComplete: () => model.onSignInSubmit(),
          ),
          SizedBox(height: 16.0),
          FormSubmitButton(
            text: model.primaryText,
            onPressed: () => model.activeButton ? model.onSignInSubmit() : null,
          ),
          FlatButton(
            onPressed: !model.isLoading ? onSecondarySubmit : null,
            child: Text(model.secondaryText),
          ),
        ],
      ),
    );
  }
}
