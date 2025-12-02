import 'package:flutter/material.dart';
import '../../models/hotel_model.dart';
import '../../services/firebase_service.dart';
import '../../widgets/hotel_card.dart';

class HotelScreen extends StatefulWidget {
  const HotelScreen({super.key});

  @override
  State<HotelScreen> createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Hotel> allHotels = [];
  List<Hotel> filteredHotels = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHotels();
  }

  Future<void> _loadHotels() async {
    final hotels = await FirebaseService.getHotels();
    setState(() {
      allHotels = hotels;
      filteredHotels = hotels;
      isLoading = false;
    });
  }

  void _filterSearch(String query) {
    setState(() {
      filteredHotels = allHotels
          .where((h) => h.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hotels in Gwalior"),
        backgroundColor: const Color(0xFF7B1E1E),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              onChanged: _filterSearch,
              decoration: InputDecoration(
                hintText: "Search hotels...",
                prefixIcon:
                const Icon(Icons.search, color: Color(0xFF7B1E1E)),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 0, horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                  const BorderSide(color: Color(0xFF7B1E1E)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: Color(0xFF7B1E1E), width: 1),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredHotels.length,
              itemBuilder: (context, i) =>
                  HotelCard(hotel: filteredHotels[i]),
            ),
          ),
        ],
      ),
    );
  }
}
