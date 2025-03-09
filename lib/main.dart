import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_app/utils/const_routes.dart';
import 'constants/app_constants.dart';
import 'constants/string_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _initSharedPref();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchUsername(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return MaterialApp(
          title: AppConstants.socialMediaApp,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: snapshot.data == null
              ? ConstRoutes.login
              : ConstRoutes.dashboard,
          onGenerateRoute: generateRoute,
        );
      },
    );
  }

  void _initSharedPref() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<String?> _fetchUsername() async {
    return _prefs?.getString(StringConstants.username);
  }
}
