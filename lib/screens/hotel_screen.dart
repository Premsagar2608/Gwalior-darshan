import 'package:flutter/material.dart';
import '../models/hotel_model.dart';
import '../widgets/hotel_card.dart';
import '../services/firebase_service.dart';

class HotelScreen extends StatefulWidget {
  const HotelScreen({super.key});

  @override
  State<HotelScreen> createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
  List<Hotel> _hotels = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHotels();
  }

  Future<void> _loadHotels() async {
    try {
      final hotels = await FirebaseService.getHotels();
      setState(() {
        _hotels = hotels;
        _loading = false;
      });
    } catch (e) {
      print('Error fetching hotels: $e');
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF7B1E1E)));
    }

    if (_hotels.isEmpty) {
      return const Center(child: Text('No hotels found.'));
    }

    return RefreshIndicator(
      onRefresh: _loadHotels,
      child: ListView.builder(
        itemCount: _hotels.length,
        itemBuilder: (context, index) {
          return HotelCard(hotel: _hotels[index]);
        },
      ),
    );
  }
}
