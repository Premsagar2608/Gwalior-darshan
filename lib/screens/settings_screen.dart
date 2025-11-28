import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  String userName = "Guest User";
  String userEmail = "guest@gwaliordarshan.in";

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

    // Update dropdown instantly
    setState(() => _selectedLang = langCode);

    // 🔄 Update main app locale (affects entire app)
    GwaliorDarshan.setLocale(context, Locale(langCode));

    // 🔔 Notify Provider (rebuild all screens)
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    localeProvider.setLocale(Locale(langCode));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          langCode == 'en'
              ? 'Language changed to English 🇬🇧'
              : 'भाषा हिंदी में बदल गई 🇮🇳',
        ),
        backgroundColor: const Color(0xFF1746A2),
        duration: const Duration(seconds: 2),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        title: Text(
          loc?.translate('settings') ?? 'Profile & Settings',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1746A2),
        elevation: 0,
      ),

      // 🔹 Body
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🧑‍💼 Profile Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1746A2), Color(0xFF567ED3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.grey[700]),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userEmail,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Profile editing coming soon..."),
                        backgroundColor: Colors.white,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 🌍 Language Section
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.language, color: Color(0xFF1746A2)),
              title: const Text("Change Language"),
              subtitle: Text(
                _selectedLang == 'en' ? 'English' : 'हिंदी',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
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
          ),

          const SizedBox(height: 10),

          // 🏛 About App
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.info_outline, color: Color(0xFF1746A2)),
              title: const Text("About App"),
              subtitle: const Text(
                "Explore Gwalior’s rich heritage, culture, and history.",
              ),
              onTap: () => _showAboutDialog(context),
            ),
          ),

          const SizedBox(height: 10),

          // 🚪 Logout (placeholder)
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.logout, color: Color(0xFF1746A2)),
              title: const Text("Logout"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Logout functionality coming soon."),
                    backgroundColor: Color(0xFF1746A2),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ℹ️ About Dialog
  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: "Gwalior Darshan",
      applicationVersion: "v1.0.0",
      applicationIcon: const Icon(Icons.apartment, color: Color(0xFF1746A2)),
      children: const [
        Text(
          "Gwalior Darshan is your travel companion to explore "
              "the heritage and culture of the royal city of Gwalior.\n\n"
              "Built with ❤️ by Team Gwalior Darshan.",
        ),
      ],
    );
  }
}
