import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/destination_model.dart';

class HeritageCard extends StatelessWidget {
  final Destination dest;
  const HeritageCard({super.key, required this.dest});

  Future<void> _openInGoogleMaps() async {
    final url = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=${dest.lat},${dest.lng}(${Uri.encodeComponent(dest.name)})");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("❌ Could not launch Google Maps");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      color: const Color(0xFFFFF8E1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 5,
      shadowColor: const Color(0xFF7B1E1E).withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/placeholder.jpg',
              image: dest.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              imageErrorBuilder: (_, __, ___) => Container(
                height: 200,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, size: 40),
              ),
            ),
          ),

          ListTile(
            title: Text(
              dest.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF7B1E1E),
              ),
            ),
            subtitle: Text(
              dest.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Center(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF7B1E1E)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.map, color: Color(0xFF7B1E1E)),
                label: const Text(
                  "Open in Google Maps",
                  style: TextStyle(color: Color(0xFF7B1E1E)),
                ),
                onPressed: _openInGoogleMaps,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
