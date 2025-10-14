import 'package:firebase_database/firebase_database.dart';
import '../models/hotel_model.dart';
import '../models/destination_model.dart';

class FirebaseService {
  static final DatabaseReference db = FirebaseDatabase.instance.ref();

  // --------------------------------------------------------------------------
  // 🏨 HOTELS SECTION
  // --------------------------------------------------------------------------

  /// Fetch all hotels from Firebase
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
    }
    return hotelList;
  }

  /// Add a booking to Firebase
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
  // 🏛 DESTINATIONS SECTION
  // --------------------------------------------------------------------------

  /// Fetch all destinations from Firebase
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
    }
    return destinationList;
  }

  // --------------------------------------------------------------------------
  // 🔁 (Optional) REALTIME STREAMS
  // --------------------------------------------------------------------------

  /// Real-time stream for hotels (auto-updates without refresh)
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

  /// Real-time stream for destinations
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
