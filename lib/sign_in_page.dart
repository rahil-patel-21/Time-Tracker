import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:techaddict21/EmailSignIn.dart';
import 'package:techaddict21/Platform_Widget.dart';
import 'package:techaddict21/SignInPageBloc.dart';
import 'Auth.dart';
import 'sign_in_button.dart';
import 'social_sign_in_button.dart';

class SignInPage extends StatelessWidget {
  SignInPage({@required this.bLoC, @required this.isLoading});
  final SignInPageBloc bLoC;
  final bool isLoading;
  static Widget create(BuildContext context) {
    final authBase = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInPageBloc>(
          create: (_) =>
              SignInPageBloc(authBase: authBase, isLoading: isLoading),
          child: Consumer<SignInPageBloc>(
              builder: (context, bLoC, _) => SignInPage(
                    bLoC: bLoC,
                    isLoading: isLoading.value,
                  )),
        ),
      ),
    );
  }

  void _signInErrors(
      BuildContext context, PlatformException platformException) {
    PlatformExceptionAlert(
        title: 'Sign In Failed !', platformException: platformException);
  }

  void _signInAnonymously(BuildContext context) async {
    try {
      await bLoC.signInAnonymously();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _signInErrors(context, e);
      }
    }
  }

  void _signInWithGoogle(BuildContext context) async {
    try {
      await bLoC.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _signInErrors(context, e);
      }
    }
  }

  void _signInWithFacebook(BuildContext context) async {
    try {
      await bLoC.signInWithFacebook();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _signInErrors(context, e);
      }
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EmailSignIn(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 2.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 48.0,
            child: _loadingWidget(),
          ),
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: 'Sign in with Google',
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          SizedBox(height: 8.0),
          SocialSignInButton(
            assetName: 'images/facebook-logo.png',
            text: 'Sign in with Facebook',
            textColor: Colors.white,
            color: Color(0xFF334D92),
            onPressed: isLoading ? null : () => _signInWithFacebook(context),
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Sign in with email',
            textColor: Colors.white,
            color: Colors.teal[700],
            onPressed: isLoading ? null : () => _signInWithEmail(context),
          ),
          SizedBox(height: 8.0),
          Text(
            'or',
            style: TextStyle(fontSize: 14.0, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Go anonymous',
            textColor: Colors.black,
            color: Colors.lime[300],
            onPressed: isLoading ? null : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _loadingWidget() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Text(
        'Sign in',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.w600,
        ),
      );
    }
  }
}
