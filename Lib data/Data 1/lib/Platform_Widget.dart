import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

abstract class PlatformWidget extends StatelessWidget {
  Widget buildCupertinoWidget(BuildContext context);
  Widget buildMaterialWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return buildCupertinoWidget(context);
    }
    return buildMaterialWidget(context);
  }
}

// class PlatformAlertDialog extends PlatformWidget {
  PlatformAlertDialog(
      {@required this.title,
      @required this.content,
      @required this.defaultActionText,
      this.cancelConfirmationText})
      : assert(title != null && content != null && defaultActionText != null);
  final String title, content, defaultActionText, cancelConfirmationText;

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog(
            context: context, builder: (context) => this)
        : await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (contex) => this);
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        cancelConfirmationText != null
            ? CupertinoDialogAction(
                child: Text(cancelConfirmationText),
                onPressed: () => Navigator.of(context).pop(false),
              )
            : null,
        CupertinoDialogAction(
          child: Text(defaultActionText),
          onPressed: () => Navigator.of(context).pop(true),
        )
      ],
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        cancelConfirmationText != null
            ? FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(cancelConfirmationText))
            : null,
        FlatButton(
          child: Text(defaultActionText),
          onPressed: () => Navigator.of(context).pop(true),
        )
      ],
    );
  }
}

class PlatformExceptionAlert extends PlatformAlertDialog {
  PlatformExceptionAlert(
      {@required this.title, @required this.platformException})
      : super(
            title: title,
            content: _platformException(platformException),
            defaultActionText: 'Try Again');
  final String title;
  final PlatformException platformException;

  static String _platformException(PlatformException platformException) {
    return _platformExceptionErrors[platformException.code] ??
        platformException.message;
  }

  static Map<String, String> _platformExceptionErrors = {
    'ERROR_WEAK_PASSWORD':
        "Password is Not Strong Enough, Please Try Again With Strong Password.",
    'ERROR_EMAIL_ALREADY_IN_USE':
        "This Email is Already Been Registered With Us With Different Account",
    'ERROR_WRONG_PASSWORD': "Input Credentials Are Wrong",
    'ERROR_INVALID_CREDENTIAL': "Email Address is Invalid",
    'ERROR_USER_NOT_FOUND': "Input Credentials Are Wrong",
    'ERROR_USER_DISABLED': "This Account is Banned to Use Our Services",
    'ERROR_WRONG_PASSWORD': "Input Credentials Are Wrong",

    ///  * `ERROR_INVALID_EMAIL` - If the email address is malformed.

    /// ///  * `ERROR_INVALID_CREDENTIAL` - If the [email] address is malformed.
    ///  ///  * `ERROR_INVALID_EMAIL` - If the [email] address is malformed.
    ///  * `ERROR_USER_NOT_FOUND` - If there is no user corresponding to the given [email] address.
    ///  ///  * `ERROR_NOT_ALLOWED` - Indicates that email and email sign-in link
    ///      accounts are not enabled. Enable them in the Auth section of the
    ///      Firebase console.
    ///  * `ERROR_DISABLED` - Indicates the user's account is disabled.
    ///  * `ERROR_INVALID` - Indicates the email address is invalid.
    ///  ///  * `ERROR_INVALID_EMAIL` - If the [email] address is malformed.
    ///  * `ERROR_WRONG_PASSWORD` - If the [password] is wrong.
    ///  * `ERROR_USER_NOT_FOUND` - If there is no user corresponding to the given [email] address, or if the user has been deleted.
    ///  * `ERROR_USER_DISABLED` - If the user has been disabled (for example, in the Firebase console)
    ///  * `ERROR_TOO_MANY_REQUESTS` - If there was too many attempts to sign in as this user.
    ///  * `ERROR_OPERATION_NOT_ALLOWED` - Indicates that Email & Password accounts are not enabled.
  };
}
