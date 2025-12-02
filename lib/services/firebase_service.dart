import 'package:firebase_database/firebase_database.dart';
import '../models/hotel_model.dart';
import '../models/destination_model.dart';

class FirebaseService {
  static final DatabaseReference db = FirebaseDatabase.instance.ref();

  // --------------------------------------------------------------------------
  // 🏨 GET HOTELS
  // --------------------------------------------------------------------------
  static Future<List<Hotel>> getHotels() async {
    final snapshot = await db.child('hotels').get();
    List<Hotel> hotelList = [];

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);

      data.forEach((key, value) {
        final hotelData = Map<String, dynamic>.from(value);

        hotelList.add(Hotel(
          id: key, // ADDING ID
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

  // --------------------------------------------------------------------------
  // 🏛 GET DESTINATIONS
  // --------------------------------------------------------------------------
  static Future<List<Destination>> getDestinations() async {
    final snapshot = await db.child('destinations').get();
    List<Destination> destinationList = [];

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);

      data.forEach((key, value) {
        final destData = Map<String, dynamic>.from(value);

        destinationList.add(
          Destination(
            id: key, // 💥 FIXED — THIS MAKES FAVORITES WORK
            name: destData['name'] ?? '',
            description: destData['description'] ?? '',
            imageUrl: destData['imageUrl'] ?? '',
            lat: (destData['lat'] ?? 0).toDouble(),
            lng: (destData['lng'] ?? 0).toDouble(),
          ),
        );
      });
    }

    return destinationList;
  }

  // --------------------------------------------------------------------------
  // 🍴 FOOD SECTION (OPTIONAL IF ADDED)
  // --------------------------------------------------------------------------
  static Future<List<Map<String, dynamic>>> getFoodPlaces() async {
    final snapshot = await db.child('food').get();
    List<Map<String, dynamic>> foodList = [];

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      data.forEach((key, value) {
        final foodData = Map<String, dynamic>.from(value);

        foodList.add({
          "id": key,
          "name": foodData['name'] ?? '',
          "desc": foodData['desc'] ?? '',
          "image": foodData['image'] ?? '',
        });
      });
    }

    return foodList;
  }
}
