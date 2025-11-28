import 'package:firebase_database/firebase_database.dart';
import '../models/hotel_model.dart';
import '../models/destination_model.dart';

class FirebaseService {
  static final DatabaseReference db = FirebaseDatabase.instance.ref();

  // --------------------------------------------------------------------------
  // 🏨 HOTELS SECTION
  // --------------------------------------------------------------------------

  static Future<List<Hotel>> getHotels() async {
    final snapshot = await db.child('hotels').get();
    List<Hotel> hotelList = [];

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      data.forEach((key, value) {
        final hotelData = Map<String, dynamic>.from(value);
        hotelList.add(Hotel(
          name: hotelData['name'] ?? '',
          rating: (hotelData['rating'] ?? 0).toDouble(),
          price: (hotelData['price'] ?? 0).toInt(),
          imageUrl: hotelData['imageUrl'] ?? '',
          lat: (hotelData['lat'] ?? 0).toDouble(),
          lng: (hotelData['lng'] ?? 0).toDouble(),
        ));
      });
    } else {
      // 🧩 Dummy Data if Firebase empty
      hotelList = [
        Hotel(
          name: "Taj Usha Kiran Palace",
          rating: 4.8,
          price: 9500,
          imageUrl:
          "https://img.freepik.com/free-photo/luxury-hotel-room-interior_23-2149289059.jpg",
          lat: 26.2133,
          lng: 78.1772,
        ),
        Hotel(
          name: "Hotel Landmark",
          rating: 4.3,
          price: 4800,
          imageUrl:
          "https://img.freepik.com/free-photo/beautiful-hotel-room-interior_23-2149153251.jpg",
          lat: 26.224,
          lng: 78.176,
        ),
      ];
    }
    return hotelList;
  }

  // --------------------------------------------------------------------------
  // 🏛 DESTINATIONS SECTION
  // --------------------------------------------------------------------------

  static Future<List<Destination>> getDestinations() async {
    final snapshot = await db.child('destinations').get();
    List<Destination> destinationList = [];

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      data.forEach((key, value) {
        final destData = Map<String, dynamic>.from(value);
        destinationList.add(Destination(
          name: destData['name'] ?? '',
          description: destData['description'] ?? '',
          imageUrl: destData['imageUrl'] ?? '',
          lat: (destData['lat'] ?? 0).toDouble(),
          lng: (destData['lng'] ?? 0).toDouble(),
        ));
      });
    } else {
      // 🧩 Dummy destinations
      destinationList = [
        Destination(
          name: "Gwalior Fort",
          description:
          "A majestic hill fort built by Raja Man Singh Tomar in the 8th century.",
          imageUrl:
          "https://img.freepik.com/free-photo/ancient-fortress-architecture_1232-1825.jpg",
          lat: 26.2235,
          lng: 78.1796,
        ),
        Destination(
          name: "Jai Vilas Palace",
          description:
          "A 19th-century palace showcasing a blend of Tuscan and Corinthian architecture.",
          imageUrl:
          "https://img.freepik.com/free-photo/beautiful-royal-palace-india_23-2149125851.jpg",
          lat: 26.2145,
          lng: 78.1827,
        ),
      ];
    }

    return destinationList;
  }

  // --------------------------------------------------------------------------
  // 🍴 FOOD SECTION (NEW)
  // --------------------------------------------------------------------------

  static Future<List<Map<String, dynamic>>> getFoodPlaces() async {
    final snapshot = await db.child('food').get();
    List<Map<String, dynamic>> foodList = [];

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      data.forEach((key, value) {
        final foodData = Map<String, dynamic>.from(value);
        foodList.add({
          "name": foodData['name'] ?? '',
          "desc": foodData['desc'] ?? '',
          "image": foodData['image'] ?? '',
        });
      });
    } else {
      // 🧩 Dummy data for food
      foodList = [
        {
          "name": "Indian Coffee House",
          "desc": "Classic south Indian snacks & coffee in vintage style.",
          "image":
          "https://img.freepik.com/free-photo/delicious-coffee-cup-wooden-table_23-2148325879.jpg",
        },
        {
          "name": "Shanky's Cafe",
          "desc": "Modern cafe near Phoolbagh with fusion food and shakes.",
          "image":
          "https://img.freepik.com/free-photo/cup-latte-with-cookies-table_23-2148234048.jpg",
        },
      ];
    }
    return foodList;
  }

  // --------------------------------------------------------------------------
  // 📖 BOOKINGS SECTION
  // --------------------------------------------------------------------------

  static Future<void> addBooking(
      String name, String hotel, String checkIn, String checkOut) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    await db.child('bookings/$id').set({
      'name': name,
      'hotel': hotel,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'timestamp': ServerValue.timestamp,
    });
  }

  // --------------------------------------------------------------------------
  // 🔁 REALTIME STREAMS (Optional)
  // --------------------------------------------------------------------------

  static Stream<List<Hotel>> hotelStream() {
    return db.child('hotels').onValue.map((event) {
      final hotels = <Hotel>[];
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        data.forEach((key, value) {
          final hotelData = Map<String, dynamic>.from(value);
          hotels.add(Hotel(
            name: hotelData['name'] ?? '',
            rating: (hotelData['rating'] ?? 0).toDouble(),
            price: (hotelData['price'] ?? 0).toInt(),
            imageUrl: hotelData['imageUrl'] ?? '',
            lat: (hotelData['lat'] ?? 0).toDouble(),
            lng: (hotelData['lng'] ?? 0).toDouble(),
          ));
        });
      }
      return hotels;
    });
  }

  static Stream<List<Destination>> destinationStream() {
    return db.child('destinations').onValue.map((event) {
      final destinations = <Destination>[];
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        data.forEach((key, value) {
          final destData = Map<String, dynamic>.from(value);
          destinations.add(Destination(
            name: destData['name'] ?? '',
            description: destData['description'] ?? '',
            imageUrl: destData['imageUrl'] ?? '',
            lat: (destData['lat'] ?? 0).toDouble(),
            lng: (destData['lng'] ?? 0).toDouble(),
          ));
        });
      }
      return destinations;
    });
  }
}
