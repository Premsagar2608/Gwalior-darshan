import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const String key = "favorites";

  // ---------------------------------------------------------
  // CHECK IF PLACE IS FAVORITE
  // ---------------------------------------------------------
  static Future<bool> isFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList(key) ?? [];
    return favs.contains(id);
  }

  // ---------------------------------------------------------
  // ADD TO FAVORITES
  // ---------------------------------------------------------
  static Future<void> addFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList(key) ?? [];

    if (!favs.contains(id)) {
      favs.add(id);
      await prefs.setStringList(key, favs);
    }
  }

  // ---------------------------------------------------------
  // REMOVE FROM FAVORITES
  // ---------------------------------------------------------
  static Future<void> removeFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList(key) ?? [];

    favs.remove(id);
    await prefs.setStringList(key, favs);
  }

  // ---------------------------------------------------------
  // GET ALL FAVORITES
  // ---------------------------------------------------------
  static Future<List<String>> getAllFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }
}
