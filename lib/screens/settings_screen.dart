import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/localization_service.dart';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLang = 'en';

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
  }

  Future<void> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLang = prefs.getString('languageCode') ?? 'en';
    });
  }

  Future<void> _changeLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', langCode);

    setState(() => _selectedLang = langCode);

    // ✅ use GwaliorDarshan instead of MyApp
    GwaliorDarshan.setLocale(context, Locale(langCode));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          langCode == 'en'
              ? 'Language changed to English 🇬🇧'
              : 'भाषा हिंदी में बदल गई 🇮🇳',
        ),
        backgroundColor: const Color(0xFF7B1E1E),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc?.translate('settings') ?? 'Settings'),
        backgroundColor: const Color(0xFF7B1E1E),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.language, color: Color(0xFF7B1E1E)),
            title: Text(loc?.translate('language') ?? 'Change Language'),
            subtitle: Text(_selectedLang == 'en' ? 'English' : 'हिंदी'),
            trailing: DropdownButton<String>(
              value: _selectedLang,
              underline: Container(),
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'hi', child: Text('हिंदी')),
              ],
              onChanged: (val) {
                if (val != null) _changeLanguage(val);
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Color(0xFF7B1E1E)),
            title: const Text('About App'),
            subtitle:
            const Text('Explore Gwalior’s rich culture and heritage.'),
          ),
        ],
      ),
    );
  }
}
