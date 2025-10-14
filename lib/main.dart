import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gwalior_darshan/screens/splash_screen.dart';
import 'package:gwalior_darshan/services/localization_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // ✅ Load the previously selected language (default: English)
  final prefs = await SharedPreferences.getInstance();
  final savedLang = prefs.getString('languageCode') ?? 'en';

  runApp(GwaliorDarshan(initialLocale: Locale(savedLang)));
}

class GwaliorDarshan extends StatefulWidget {
  final Locale initialLocale;
  const GwaliorDarshan({super.key, required this.initialLocale});

  // ✅ This allows SettingsScreen to trigger language change dynamically
  static void setLocale(BuildContext context, Locale newLocale) {
    final _GwaliorDarshanState? state =
    context.findAncestorStateOfType<_GwaliorDarshanState>();
    state?.setLocale(newLocale);
  }

  @override
  State<GwaliorDarshan> createState() => _GwaliorDarshanState();
}

class _GwaliorDarshanState extends State<GwaliorDarshan> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
  }

  void setLocale(Locale locale) {
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocaleProvider()..setLocale(_locale),
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, _) {
          return MaterialApp(
            title: 'Gwalior Darshan',
            debugShowCheckedModeBanner: false,

            // 🏰 Royal Heritage Theme
            theme: ThemeData(
              primaryColor: const Color(0xFF7B1E1E),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFFC5A020),
                primary: const Color(0xFF7B1E1E),
                secondary: const Color(0xFFC5A020),
              ),
              fontFamily: 'Poppins',
              scaffoldBackgroundColor: const Color(0xFFF5F0E6),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF7B1E1E),
                foregroundColor: Colors.white,
                centerTitle: true,
              ),
            ),

            // 🌐 Localization
            locale: _locale,
            supportedLocales: const [
              Locale('en'),
              Locale('hi'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
