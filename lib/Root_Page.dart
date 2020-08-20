import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'FireStore.dart';
import 'sign_in_page.dart';
import 'DashBoard.dart';
import 'Auth.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBase = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder(
      stream: authBase.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          return user == null
              ? SignInPage.create(context)
              : Provider<DataBase>(
                  create: (_) => FirestoreDataBase(userID: user.userID),
                  child: DashBoard());
        } else {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}
