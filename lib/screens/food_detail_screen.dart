import 'package:flutter/material.dart';

class FoodDetailScreen extends StatelessWidget {
  final Map<String, dynamic> food;
  const FoodDetailScreen({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(food['name']),
        backgroundColor: const Color(0xFF1746A2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(food['image'], fit: BoxFit.cover),
            const SizedBox(height: 12),
            Text(
              food['name'],
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 8),
            Text(food['desc']),
          ],
        ),
      ),
    );
  }
}
