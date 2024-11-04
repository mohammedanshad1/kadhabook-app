import 'package:flutter/material.dart';
import 'package:kadhabook/view/login_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cash Management App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(), // Start with the Login Page
    );
  }
}
