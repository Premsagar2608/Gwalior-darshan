import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/destination_model.dart';
import '../services/weather_service.dart';

class HeritageCard extends StatelessWidget {
  final Destination dest;
  const HeritageCard({required this.dest});

  Future<void> _showWeather(BuildContext context) async {
    final data = await WeatherService.getWeather(dest.lat, dest.lng);
    if (data == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to fetch weather ❌')),
      );
      return;
    }

    final temp = data['main']['temp'].toString();
    final desc = data['weather'][0]['description'];
    final humidity = data['main']['humidity'].toString();
    final icon = data['weather'][0]['icon'];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(dest.name,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B1E1E))),
            const SizedBox(height: 10),
            Image.network(
              'https://openweathermap.org/img/wn/$icon@2x.png',
              height: 80,
            ),
            Text(
              "$desc".toUpperCase(),
              style: const TextStyle(fontSize: 16),
            ),
            Text("🌡 Temperature: $temp°C"),
            Text("💧 Humidity: $humidity%"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Image.network(dest.imageUrl,
              height: 200, width: double.infinity, fit: BoxFit.cover),
          ListTile(
            title: Text(dest.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(dest.description),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Scaffold(
                      appBar: AppBar(title: Text(dest.name)),
                      body: GoogleMap(
                        initialCameraPosition: CameraPosition(
                            target: LatLng(dest.lat, dest.lng), zoom: 14),
                        markers: {
                          Marker(
                              markerId: MarkerId(dest.name),
                              position: LatLng(dest.lat, dest.lng))
                        },
                      ),
                    ),
                  ),
                ),
                icon: const Icon(Icons.map, color: Colors.amber),
                label: const Text("View on Map"),
              ),
              TextButton.icon(
                onPressed: () => _showWeather(context),
                icon: const Icon(Icons.wb_sunny, color: Colors.orange),
                label: const Text("Check Weather"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
