import 'package:flutter/material.dart';
import '../models/destination_model.dart';
import '../services/firebase_service.dart';
import '../services/favorite_service.dart';
import '../widgets/heritage_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Destination> favorites = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadFavs();
  }

  Future<void> _loadFavs() async {
    final favIds = await FavoriteService.getAllFavorites();
    final allDest = await FirebaseService.getDestinations();

    favorites = allDest.where((d) => favIds.contains(d.id)).toList();

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites",style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Color(0xFF1746A2),
        foregroundColor: Colors.white,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : favorites.isEmpty
          ? const Center(child: Text("No favorites added yet 😔"))
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (_, i) => HeritageCard(dest: favorites[i]),
      ),
    );
  }
}
