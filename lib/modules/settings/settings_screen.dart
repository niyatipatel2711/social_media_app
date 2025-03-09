import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_app/base/baseSnackBar.dart';
import '../../constants/app_constants.dart';
import '../../constants/string_constants.dart';
import '../../utils/const_routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final User? _user = FirebaseAuth.instance.currentUser;
  SharedPreferences? _prefs;
  String? _username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.settings),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: _initSharedPref(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
                SizedBox(height: 10),
                Text(_username ?? AppConstants.anonymous,
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text(_user?.email ?? AppConstants.noEmail,
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _logout(context),
                  child: Text(AppConstants.logout),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future _initSharedPref() async {
    _prefs = await SharedPreferences.getInstance();
    _getUsername();
  }

  void _getUsername() {
    _username = _prefs?.getString(StringConstants.username);
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    _prefs?.remove(StringConstants.username);
    if (context.mounted) {
      baseError(
          errorText: AppConstants.loggedOutSuccessfully, context: context);
      // Navigate back to Login Screen (replace with your login route)
      Navigator.pushReplacementNamed(context, ConstRoutes.login);
    }
  }
}
