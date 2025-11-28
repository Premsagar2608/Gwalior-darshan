import 'package:flutter/material.dart';
import '../models/hotel_model.dart';

class HotelDetailScreen extends StatelessWidget {
  final Hotel hotel;
  const HotelDetailScreen({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hotel.name),
        backgroundColor: const Color(0xFF1746A2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(hotel.imageUrl, fit: BoxFit.cover),
            const SizedBox(height: 12),
            Text(
              hotel.name,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 8),
            Text('Hotel'),
          ],
        ),
      ),
    );
  }
}
