import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techaddict21/Auth.dart';
import 'Root_Page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Time Tracker',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: RootPage(),
      ),
    );
  }
}
