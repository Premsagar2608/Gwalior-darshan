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
  bool _loading = true;

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
        _loading = false;
      });
    } catch (e) {
      debugPrint('❌ Error loading destinations: $e');
      setState(() => _loading = false);
    }
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

    return RefreshIndicator(
      onRefresh: _fetchDestinations,
      child: ListView.builder(
        itemCount: _destinations.length,
        itemBuilder: (context, i) => HeritageCard(dest: _destinations[i]),
      ),
    );
  }
}
