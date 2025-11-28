import 'package:flutter/material.dart';
import '../models/destination_model.dart';

class PlaceDetailScreen extends StatelessWidget {
  final Destination destination;
  const PlaceDetailScreen({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(destination.name),
        backgroundColor: const Color(0xFF1746A2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(destination.imageUrl, fit: BoxFit.cover),
            const SizedBox(height: 12),
            Text(
              destination.name,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 8),
            Text(destination.description),
          ],
        ),
      ),
    );
  }
}
