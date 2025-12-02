import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

class DestinationScreen extends StatefulWidget {
  const DestinationScreen({super.key});
  @override
  State<DestinationScreen> createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  List<Map<String, dynamic>> destinations = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDestinations();
  }

  Future<void> _loadDestinations() async {
    final ref = FirebaseDatabase.instance.ref('destinations');
    final snap = await ref.get();
    if (snap.exists) {
      final data = Map<String, dynamic>.from(snap.value as Map);
      destinations =
          data.values.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    setState(() => _loading = false);
  }

  Future<void> _openWeather(double lat, double lng) async {
    final url = Uri.parse(
        'https://www.google.com/search?q=weather+$lat,$lng'); // uses Google weather card
    if (await canLaunchUrl(url)) launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF0066FF)));
    }
    if (destinations.isEmpty) {
      return const Center(child: Text("No destinations found."));
    }

    return RefreshIndicator(
      onRefresh: _loadDestinations,
      child: ListView.builder(
        itemCount: destinations.length,
        itemBuilder: (_, i) {
          final d = destinations[i];
          return Card(
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(d['imageUrl'],
                        height: 180, width: double.infinity, fit: BoxFit.cover)),
                ListTile(
                  title: Text(d['name'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text(d['description']),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.pin_drop_outlined,),
                      label: const Text("View on Map"),
                      onPressed: () {
                        final url = Uri.parse(
                            "https://www.google.com/maps/search/?api=1&query=${d['lat']},${d['lng']}(${Uri.encodeComponent(d['name'])})");
                        launchUrl(url, mode: LaunchMode.externalApplication);
                      },
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.read_more, color: Colors.white),
                      label: const Text("Weather"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0066FF)),
                      onPressed: () => _openWeather(d['lat'], d['lng']),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }
}
