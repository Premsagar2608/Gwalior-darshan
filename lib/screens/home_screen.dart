import 'package:flutter/material.dart';
import 'destination_screen.dart';
import 'hotel_screen.dart';
import 'booking_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  final List<Widget> _pages = [
    DestinationScreen(),
    HotelScreen(),
    BookingScreen(),
    SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gwalior Darshan'),
        backgroundColor: const Color(0xFF7B1E1E),
      ),
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        selectedItemColor: const Color(0xFFC5A020),
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.temple_hindu), label: 'Destinations'),
          BottomNavigationBarItem(
              icon: Icon(Icons.hotel), label: 'Hotels'),
          BottomNavigationBarItem(
              icon: Icon(Icons.book_online), label: 'Bookings'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
