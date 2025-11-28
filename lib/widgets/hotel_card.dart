import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/hotel_model.dart';

class HotelCard extends StatelessWidget {
  final Hotel hotel;
  const HotelCard({super.key, required this.hotel});

  // ✅ WhatsApp booking function (with BuildContext)
  Future<void> _openWhatsApp(BuildContext context, Hotel hotel) async {
    const phone = "919981863663";
    final message = Uri.encodeComponent(
        "Hello 👋, I would like to book a room at ${hotel.name} in Gwalior.");

    final whatsappUri = Uri.parse("whatsapp://send?phone=$phone&text=$message");
    final webUri = Uri.parse("https://wa.me/$phone?text=$message");

    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Unable to open WhatsApp. Please check installation."),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      debugPrint("❌ WhatsApp launch error: $e");
    }
  }



  // ✅ Open in Google Maps
  Future<void> _openInGoogleMaps() async {
    final url = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=${hotel.lat},${hotel.lng}(${Uri.encodeComponent(hotel.name)})");
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
          // 🖼 Hotel image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/placeholder.jpg',
              image: hotel.imageUrl,
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

          // 🏨 Hotel name, price, rating
          ListTile(
            title: Text(
              hotel.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF7B1E1E),
              ),
            ),
            subtitle: Text(
              '⭐ ${hotel.rating}   ₹${hotel.price}/night',
              style: const TextStyle(color: Colors.black54),
            ),
          ),

          const SizedBox(height: 2),

          // 🔘 Buttons row
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // ✅ WhatsApp booking button (smaller)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 6), // smaller
                    minimumSize: const Size(120, 36),
                  ),
                  icon: const FaIcon(FontAwesomeIcons.whatsapp,
                      color: Colors.white, size: 20),
                  label: const Text(
                    "Book Now",
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  onPressed: () => _openWhatsApp(context, hotel),
                ),

                // 🗺 Open Google Maps
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF7B1E1E)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 6),
                    minimumSize: const Size(120, 36),
                  ),
                  icon: const Icon(Icons.map,
                      color: Color(0xFF7B1E1E), size: 20),
                  label: const Text(
                    "Open in Maps",
                    style: TextStyle(color: Color(0xFF7B1E1E), fontSize: 13),
                  ),
                  onPressed: _openInGoogleMaps,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
