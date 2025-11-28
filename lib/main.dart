import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/splash_screen.dart';
import 'services/localization_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  final savedLang = prefs.getString('languageCode') ?? 'en';

  runApp(GwaliorDarshan(initialLocale: Locale(savedLang)));
}

class GwaliorDarshan extends StatefulWidget {
  final Locale initialLocale;
  const GwaliorDarshan({super.key, required this.initialLocale});

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
            theme: ThemeData(
              fontFamily: 'Poppins',
              primaryColor: const Color(0xFF1746A2),
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF1746A2),
                secondary: Color(0xFFFFC93C),
              ),
            ),
            locale: localeProvider.locale ?? _locale,
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
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
