import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/localization_service.dart';
import 'ai_assistant_screen.dart';


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

    // 🔥 update whole app language
    LocalizationService.updateLanguage(context, langCode);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            langCode == 'en'
                ? "Language changed to English 🇬🇧"
                : "भाषा हिंदी में बदल गई 🇮🇳"
        ),
        backgroundColor: const Color(0xFF1746A2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: const Color(0xFF1746A2),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        children: [

          _title("Profile"),

          _tile(Icons.person, "Edit Profile", "Name, phone & preferences", () {}),
          _tile(Icons.security, "Privacy & Safety", "Manage permissions", () {}),

          const SizedBox(height: 18),

          _title("Travel Preferences"),

          _tile(Icons.notifications, "Notifications", "Alerts & reminders", () {}),
          _tile(Icons.language, "App Language", "Select your preferred language", () {}),

          _languageSelector(),

          const SizedBox(height: 18),

          _title("Travel Tools"),

          _tile(Icons.flight_takeoff, "My Trips", "Upcoming & past trips", () {}),
          _tile(Icons.favorite, "Saved Places", "Your favourite destinations", () {}),
          _tile(Icons.map_outlined, "Download Offline Maps", "Use maps without internet", () {}),

          const SizedBox(height: 18),

          _title("Support"),

          _tile(Icons.support_agent, "Customer Support", "We respond within 5 minutes", () {}),
          _tile(Icons.chat_bubble_outline, "AI Travel Assistant", "Ask anything!", () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AIAssistantScreen()));
          }),

          const SizedBox(height: 18),

          _title("About"),

          _tile(Icons.info_outline, "About App", "Version 1.0.0 | Gwalior Darshan", () {}),
          _tile(Icons.privacy_tip_outlined, "Terms & Privacy", "Read policies", () {}),
        ],
      ),
    );
  }

  // --------------------- REUSABLE WIDGETS ---------------------

  Widget _title(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1746A2),
          )),
    );
  }

  Widget _tile(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF1746A2), size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
        onTap: onTap,
      ),
    );
  }

  Widget _languageSelector() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.public, color: Color(0xFF1746A2)),
        title: const Text("Choose Language"),
        trailing: DropdownButton<String>(
          value: _selectedLang,
          underline: Container(),
          items: const [
            DropdownMenuItem(value: 'en', child: Text('English 🇬🇧')),
            DropdownMenuItem(value: 'hi', child: Text('हिंदी 🇮🇳')),
          ],
          onChanged: (val) {
            if (val != null) _changeLanguage(val);
          },
        ),
      ),
    );
  }
}
