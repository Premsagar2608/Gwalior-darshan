import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home_screen.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final DatabaseReference _db = FirebaseDatabase.instance.ref("bookings");
  List<Map<String, dynamic>> _bookings = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    try {
      final snapshot = await _db.get();

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        _bookings = data.entries.map((entry) {
          final value = Map<String, dynamic>.from(entry.value);
          return {
            "id": entry.key,
            "name": value["name"] ?? "",
            "hotel": value["hotel"] ?? "",
            "checkIn": value["checkIn"] ?? "",
            "checkOut": value["checkOut"] ?? "",
          };
        }).toList();
      } else {
        _bookings = [];
      }
    } catch (e) {
      debugPrint("Error loading bookings: $e");
      _bookings = [];
    }

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Bookings"),
        backgroundColor: const Color(0xFF1746A2),
      ),
      body: _loading
          ? const Center(
        child: CircularProgressIndicator(color: Color(0xFF1746A2)),
      )
          : _bookings.isEmpty
          ? const Center(
        child: Text(
          "No bookings found.",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
      )
          : RefreshIndicator(
        onRefresh: _fetchBookings,
        child: ListView.builder(
          itemCount: _bookings.length,
          itemBuilder: (context, i) {
            final booking = _bookings[i];
            return Card(
              margin: const EdgeInsets.all(12),
              color: const Color(0xFFFFF8E1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              shadowColor: const Color(0xFF1746A2).withOpacity(0.3),
              child: ListTile(
                leading: const Icon(Icons.hotel,
                    color: Color(0xFF1746A2), size: 32),
                title: Text(
                  booking["hotel"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1746A2),
                  ),
                ),
                subtitle: Text(
                  "Guest: ${booking["name"]}\n"
                      "Check-in: ${booking["checkIn"]}\n"
                      "Check-out: ${booking["checkOut"]}",
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
