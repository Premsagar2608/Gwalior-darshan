import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/destination_model.dart';
import '../models/hotel_model.dart';
import '../widgets/heritage_card.dart';
import '../widgets/hotel_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Destination> _destinations = [];
  List<Hotel> _hotels = [];
  List<dynamic> _results = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final destinations = await FirebaseService.getDestinations();
    final hotels = await FirebaseService.getHotels();
    setState(() {
      _destinations = destinations;
      _hotels = hotels;
      _results = [];
      _loading = false;
    });
  }

  void _search(String query) {
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }

    final lower = query.toLowerCase();

    final filteredDest = _destinations
        .where((d) => d.name.toLowerCase().contains(lower))
        .toList();
    final filteredHotels =
    _hotels.where((h) => h.name.toLowerCase().contains(lower)).toList();

    setState(() => _results = [...filteredDest, ...filteredHotels]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search",style: const TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFF1746A2),
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onChanged: _search,
              decoration: InputDecoration(
                hintText: "Search places or hotels...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _results.isEmpty
                  ? const Center(
                child: Text(
                  "No results yet. Try searching!",
                  style: TextStyle(color: Colors.black54),
                ),
              )
                  : ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, i) {
                  final item = _results[i];
                  if (item is Destination) {
                    return Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 8),
                      child: HeritageCard(dest: item),
                    );
                  } else if (item is Hotel) {
                    return Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 8),
                      child: HotelCard(hotel: item),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
