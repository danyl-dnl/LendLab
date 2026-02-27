import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'theme.dart';
import 'screens/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('darkMode') ?? true; // Default to dark

  runApp(IdeaLabApp(isDarkMode: isDarkMode));
}

class IdeaLabApp extends StatefulWidget {
  final bool isDarkMode;
  const IdeaLabApp({super.key, required this.isDarkMode});

  static _IdeaLabAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_IdeaLabAppState>()!;

  @override
  State<IdeaLabApp> createState() => _IdeaLabAppState();
}

class _IdeaLabAppState extends State<IdeaLabApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() async {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _themeMode == ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IDEALab Component Borrowing',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: const LoginScreen(),
    );
  }
}
