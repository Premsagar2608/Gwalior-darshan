import 'package:flutter/material.dart';
import '../models/destination_model.dart';

import '../screens/destination/destination_details_screen.dart';
import '../services/favorite_service.dart';

class HeritageCard extends StatefulWidget {
  final Destination dest;

  const HeritageCard({super.key, required this.dest});

  @override
  State<HeritageCard> createState() => _HeritageCardState();
}

class _HeritageCardState extends State<HeritageCard> {
  bool isFav = false;

  @override
  void initState() {
    super.initState();
    _loadFavorite();
  }

  Future<void> _loadFavorite() async {
    bool fav = await FavoriteService.isFavorite(widget.dest.id);
    setState(() => isFav = fav);
  }

  Future<void> _toggleFavorite() async {
    if (isFav) {
      await FavoriteService.removeFavorite(widget.dest.id);
    } else {
      await FavoriteService.addFavorite(widget.dest.id);
    }
    setState(() => isFav = !isFav);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  widget.dest.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: _toggleFavorite,
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.4),
                    ),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      size: 26,
                      color: isFav ? Colors.red : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.dest.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1746A2)),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.dest.description.length > 90
                      ? widget.dest.description.substring(0, 90) + "..."
                      : widget.dest.description,
                ),
                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DestinationDetailsScreen(destination: widget.dest)),
                      );
                    },
                    child: const Text("Read More"),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
