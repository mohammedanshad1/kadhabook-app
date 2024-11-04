import 'package:flutter/material.dart';
import 'package:kadhabook/view/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel with ChangeNotifier {
  String? _userId;
  String? _userEmail;

  String? get userId => _userId;
  String? get userEmail => _userEmail;

  Future<void> login(String email) async {
    // Perform login and get user ID and email
    _userId = 'exampleUserId'; // Fetch from your authentication logic
    _userEmail = email;

    // Save the user email in shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', _userEmail!);

    notifyListeners();
  }

  Future<void> loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    _userEmail = prefs.getString('userEmail');
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    // Clear user ID and email
    _userId = null;
    _userEmail = null;

    // Clear user email from shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');

    // Optionally, navigate to login screen or show a message
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LoginPage())); // Adjust the route as necessary
    notifyListeners();
  }
}
