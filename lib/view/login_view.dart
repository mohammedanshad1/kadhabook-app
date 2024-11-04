import 'package:flutter/material.dart';
import 'package:kadhabook/view/transaction_view.dart';
import 'package:kadhabook/widgets/custom_button.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

final pb = PocketBase('http://10.0.2.2:8090');

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _balanceController = TextEditingController();

  // Future<void> _registerUser() async {
  //   final body = <String, dynamic>{
  //     "username": _usernameController.text,
  //     "email": _emailController.text,
  //     "phone": _phoneController.text,
  //     "total_balance": double.tryParse(_balanceController.text) ?? 0,
  //   };

  //   try {
  //     final record = await pb.collection('Users_Collection').create(body: body);
  //     print('User registered: ${record.collectionName}');
  //     // Navigate to home screen after successful registration
  //     Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //             builder: (_) => TransactionAddingView(userId: record.id)));
  //   } catch (e) {
  //     print('Error registering user: $e');
  //   }
  // }
Future<void> _registerUser() async {
  final body = <String, dynamic>{
    "username": _usernameController.text,
    "email": _emailController.text,
    "phone": _phoneController.text,
    "total_balance": double.tryParse(_balanceController.text) ?? 0,
  };

  try {
    final record = await pb.collection('Users_Collection').create(body: body);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userId', record.id);
    await prefs.setString('userEmail', _emailController.text);
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => TransactionAddingView(userId: record.id),
      ),
    );
  } catch (e) {
    print('Error registering user: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                  labelText: 'Username', border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),
            TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                    labelText: 'Email', border: OutlineInputBorder())),
            SizedBox(height: 20),
            TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                    labelText: 'Phone', border: OutlineInputBorder())),
            SizedBox(height: 20),
            TextField(
                controller: _balanceController,
                decoration: const InputDecoration(
                    labelText: 'Total Balance', border: OutlineInputBorder()),
                keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            CustomButton(
              buttonName: "Continue",
              onTap: () {
                _registerUser(); // Call the function with parentheses
              },
              buttonColor: Colors.blue,
              height: 40,
              width: 100,
            )
          ],
        ),
      ),
    );
  }
}
