import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';          // for GwaliorDarshan.setLocale
import 'home_screen.dart';      // your hotel screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initLanguageAndFlow();
  }

  /// 🔹 Check if language is already selected, else show popup
  Future<void> _initLanguageAndFlow() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString('languageCode');

    if (savedLang == null) {
      // First time → show language selector dialog
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showLanguageDialog();
      });
    } else {
      // Already selected → apply and go to Home
      GwaliorDarshan.setLocale(context, Locale(savedLang));
      _startNavigation();
    }
  }

  /// 🔹 Show language selection popup (Hindi / English)
  void _showLanguageDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // must choose language
      builder: (_) => AlertDialog(
        title: const Text("Choose Language"),
        content: const Text("Please select your preferred language."),
        actions: [
          TextButton(
            onPressed: () => _onLanguageSelected('en'),
            child: const Text("English 🇬🇧"),
          ),
          TextButton(
            onPressed: () => _onLanguageSelected('hi'),
            child: const Text("हिंदी 🇮🇳"),
          ),
        ],
      ),
    );
  }

  /// 🔹 Save choice, update app locale, go to Home
  Future<void> _onLanguageSelected(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', code);

    // apply to whole app
    GwaliorDarshan.setLocale(context, Locale(code));

    if (mounted) Navigator.pop(context); // close dialog
    _startNavigation();
  }

  /// 🔹 Navigate to Home after small delay (for splash feel)
  void _startNavigation() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🔵 Background Image (full screen)
          Positioned.fill(
            child: Image.asset(
              'assets/images/gwalior_fort.jpg',  // <-- your local image path
              fit: BoxFit.cover,
            ),
          ),

          /// 🔵 Dark overlay (optional, for better text visibility)
          Container(
            color: Colors.black.withOpacity(0.3),
          ),

          /// 🔵 Foreground content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(height: 20),
                Text(
                  'Welcome to Gwalior',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }
}
