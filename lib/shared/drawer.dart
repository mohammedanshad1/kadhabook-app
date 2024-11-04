import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kadhabook/view/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Drawericon extends StatefulWidget {
  const Drawericon({super.key});

  @override
  _DrawericonState createState() => _DrawericonState();
}

class _DrawericonState extends State<Drawericon> {
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('userEmail') ?? 'Guest';
    });
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored data
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) =>
              LoginPage()), // Replace with your LoginPage widget
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: HexColor("303050"),
              border: const Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: HexColor("303050"),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userEmail ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: "Sora",
                      fontSize: 18,
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            title: const Text(
              "Home",
              style: TextStyle(fontFamily: "Sora"),
            ),
            leading: const Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(
              "Settings",
              style: TextStyle(fontFamily: "Sora"),
            ),
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          Container(
            color: HexColor("303050"),
            child: ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Sora",
                ),
              ),
              onTap: () async {
                await logout(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
