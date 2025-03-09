import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_app/modules/feed/feed_screen.dart';
import 'package:social_media_app/modules/settings/settings_screen.dart';

import '../../constants/app_constants.dart';
import '../../constants/string_constants.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0; // Track the selected tab
  SharedPreferences? _prefs;

  final List<Widget> _pages = [FeedScreen(), SettingsScreen()];

  @override
  void initState() {
    super.initState();
    _initSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: AppConstants.posts),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: AppConstants.settings),
        ],
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  // Function to handle tab change
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _initSharedPref() async {
    _prefs = await SharedPreferences.getInstance();
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection(StringConstants.users)
            .doc(user.uid)
            .get();
        final String username =
            doc[StringConstants.username] ?? AppConstants.anonymous;
        await _prefs?.setString(StringConstants.username, username);
        Future.delayed(const Duration(seconds: 1));
      }
    });
  }
}
