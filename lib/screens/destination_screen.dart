import 'package:flutter/material.dart';
import '../models/destination_model.dart';
import '../services/firebase_service.dart';
import '../widgets/heritage_card.dart';

class DestinationScreen extends StatefulWidget {
  const DestinationScreen({super.key});

  @override
  State<DestinationScreen> createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  List<Destination> _destinations = [];
  List<Destination> _filteredDestinations = [];
  bool _loading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchDestinations();
  }

  Future<void> _fetchDestinations() async {
    try {
      final data = await FirebaseService.getDestinations();
      setState(() {
        _destinations = data;
        _filteredDestinations = data;
        _loading = false;
      });
    } catch (e) {
      debugPrint('❌ Error loading destinations: $e');
      setState(() => _loading = false);
    }
  }

  void _filterSearch(String query) {
    setState(() {
      _filteredDestinations = _destinations
          .where((d) =>
      d.name.toLowerCase().contains(query.toLowerCase()) ||
          d.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF7B1E1E)),
      );
    }

    if (_destinations.isEmpty) {
      return const Center(
        child: Text(
          "No destinations found.",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Popular Destinations",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF7B1E1E),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchDestinations,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Search Bar
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _searchController,
                onChanged: _filterSearch,
                decoration: InputDecoration(
                  hintText: "Search destinations...",
                  prefixIcon:
                  const Icon(Icons.search, color: Color(0xFF7B1E1E)),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, color: Color(0xFF7B1E1E)),
                    onPressed: () {
                      _searchController.clear();
                      _filterSearch('');
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF7B1E1E)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                    const BorderSide(color: Color(0xFF7B1E1E), width: 1),
                  ),
                ),
              ),
            ),

            // 🏰 List of Destinations
            Expanded(
              child: _filteredDestinations.isEmpty
                  ? const Center(
                child: Text(
                  "No matching destinations found.",
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
              )
                  : ListView.builder(
                itemCount: _filteredDestinations.length,
                itemBuilder: (context, i) =>
                    HeritageCard(dest: _filteredDestinations[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
