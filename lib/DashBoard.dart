import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:techaddict21/JobModel.dart';
import 'package:techaddict21/Platform_Widget.dart';
import 'Auth.dart';
import 'FireStore.dart';

class DashBoard extends StatelessWidget {
  void _signOut(BuildContext context) async {
    final authBase = Provider.of<AuthBase>(context, listen: false);
    try {
      await authBase.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _createJob(BuildContext context) async {
    try {
      final dataBase = Provider.of<DataBase>(context, listen: false);
      await dataBase.createJob(Job(name: 'Free Lancing', ratePerHour: 100));
    } on PlatformException catch (e) {
      PlatformExceptionAlert(
        title: 'Operation Failed',
        platformException: e,
      ).show(context);
    }
  }

  Future<void> _signOutFinal(BuildContext context) async {
    final _confirmedResponse = await PlatformAlertDialog(
            title: 'Log Out',
            content: 'Are you Sure to Log Out ?',
            cancelConfirmationText: 'CANCEL',
            defaultActionText: 'LOG OUT')
        .show(context);
    if (_confirmedResponse == true) {
      _signOut(context);
    } else {
      print('False');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataBase = Provider.of<DataBase>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('DashBoard'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => _signOutFinal(context),
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.white, fontSize: 15.0),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _createJob(context), child: Icon(Icons.add)),
    );
  }
}
