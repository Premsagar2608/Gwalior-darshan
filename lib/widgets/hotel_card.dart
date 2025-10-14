import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/hotel_model.dart';
import '../services/firebase_service.dart';

class HotelCard extends StatelessWidget {
  final Hotel hotel;
  const HotelCard({super.key, required this.hotel});

  Future<void> _openInGoogleMaps() async {
    final url = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=${hotel.lat},${hotel.lng}(${Uri.encodeComponent(hotel.name)})");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("❌ Could not launch Google Maps");
    }
  }

  Future<void> _bookHotel(BuildContext context) async {
    final TextEditingController nameCtrl = TextEditingController();
    final TextEditingController checkInCtrl = TextEditingController();
    final TextEditingController checkOutCtrl = TextEditingController();

    // Helper to open date picker
    Future<void> pickDate(BuildContext ctx, TextEditingController controller) async {
      final DateTime? picked = await showDatePicker(
        context: ctx,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2030),
        builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF7B1E1E),
              onPrimary: Colors.white,
              onSurface: Color(0xFF7B1E1E),
            ),
          ),
          child: child!,
        ),
      );
      if (picked != null) {
        controller.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      }
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text('Book ${hotel.name}',
            style: const TextStyle(color: Color(0xFF7B1E1E))),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                    labelText: 'Your Name', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: checkInCtrl,
                readOnly: true,
                onTap: () => pickDate(ctx, checkInCtrl),
                decoration: const InputDecoration(
                  labelText: 'Check-in Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today_rounded),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: checkOutCtrl,
                readOnly: true,
                onTap: () => pickDate(ctx, checkOutCtrl),
                decoration: const InputDecoration(
                  labelText: 'Check-out Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today_rounded),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7B1E1E),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              if (nameCtrl.text.isNotEmpty &&
                  checkInCtrl.text.isNotEmpty &&
                  checkOutCtrl.text.isNotEmpty) {
                await FirebaseService.addBooking(
                  nameCtrl.text,
                  hotel.name,
                  checkInCtrl.text,
                  checkOutCtrl.text,
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ Booking successful!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('⚠️ Please fill all fields'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
            child: const Text('Book Now'),
          ),
        ],
      ),
    );
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
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC5A020),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.hotel, color: Colors.white),
                  label: const Text(
                    "Book Now",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => _bookHotel(context),
                ),
                OutlinedButton.icon(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
