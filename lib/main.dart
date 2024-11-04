import 'package:flutter/material.dart';
import 'package:kadhabook/view/login_view.dart';
import 'package:kadhabook/view/transaction_view.dart';
import 'package:kadhabook/viewmodel/login_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  String? userId = prefs.getString('userId');

  runApp(MyApp(
    isLoggedIn: isLoggedIn,
    userId: userId,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? userId;
  final String? userEmail;

  MyApp({required this.isLoggedIn, this.userId, this.userEmail});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => LoginViewModel(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'KadhaBook',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: isLoggedIn && userId != null
              ? TransactionAddingView(userId: userId!)
              : LoginPage(),
        ));
  }
}
