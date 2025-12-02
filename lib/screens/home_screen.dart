import 'package:flutter/material.dart';
import 'package:gwalior_darshan/screens/destination/place_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../models/destination_model.dart';
import '../models/hotel_model.dart';
import '../screens/search_screen.dart';
import 'setting/settings_screen.dart';
import '../screens/favorites_screen.dart';
import '../services/firebase_service.dart';
import '../services/localization_service.dart';
import '../widgets/food_card.dart';
import '../widgets/heritage_card.dart';
import '../widgets/hotel_card.dart';
import 'food/food_detail_screen.dart';
import 'hotel/hotel_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _loading = true;
  List<Destination> _places = [];
  List<Hotel> _hotels = [];
  List<Map<String, dynamic>> _food = [];

  final List<String> _categories = ['Places', 'Hotels', 'Food', 'All'];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final places = await FirebaseService.getDestinations();
      final hotels = await FirebaseService.getHotels();
      await Future.delayed(const Duration(seconds: 1)); // simulate load

      if (!mounted) return;
      setState(() {
        _places = places;
        _hotels = hotels;
        _food = [
          {
            "name": "Shanky's Cafe",
            "image":
            "https://img.freepik.com/free-photo/top-view-delicious-burger-meal_23-2148782048.jpg",
            "desc": "Best burgers & snacks near Gwalior Fort"
          },
          {
            "name": "Kwality Restaurant",
            "image":
            "https://img.freepik.com/free-photo/indian-food-platter_23-2148747718.jpg",
            "desc": "Authentic North Indian cuisine"
          },
        ];
        // 🔥 SHUFFLE LISTS
        _places.shuffle();
        _hotels.shuffle();
        _food.shuffle();
        _loading = false;
      });
    } catch (e) {
      debugPrint("❌ Error fetching data: $e");
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1746A2),
        title: Text(
          loc?.translate('Gwalior Darshan') ?? "Gwalior Darshan",
          style: const TextStyle(
            fontSize: 23,
            fontFamily: 'Mainfont',
            fontWeight: FontWeight.w500,
            color: Colors.white,
            letterSpacing: 0.9,
          ),
        ),

        // RIGHT SIDE ICONS
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Help & Support"),
                  content: const Text(
                    "For queries, contact support@gwaliordarshan.in",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),

        backgroundColor: const Color(0xFFF4F6F8),

      // ✅ BODY
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // 🏷 Category Chips
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _categories.length,
                itemBuilder: (context, i) {
                  final selected = _selectedIndex == i;
                  final label = loc?.translate(_categories[i].toLowerCase()) ??
                      _categories[i];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIndex = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF1746A2)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: selected
                            ? [
                          BoxShadow(
                            color: const Color(0xFF1746A2)
                                .withOpacity(0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          )
                        ]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          label,
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // 🌍 Dynamic Category View
            Expanded(
              child: RefreshIndicator(
                color: Color(0xFF1746A2),
                onRefresh: () async {
                  setState(() => _loading = true);
                  await _fetchData();   // Re-fetch + shuffle
                },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: Tween(
                      begin: const Offset(0.1, 0),
                      end: Offset.zero,
                    ).animate(anim),
                    child: child,
                  ),
                ),
                child: _loading
                    ? _buildShimmer()
                    : _buildCategoryContent(_categories[_selectedIndex]),
              ),
            ),
            ),
          ],
        ),
      ),

      // 🌊 Bottom Nav Bar (Localized)
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: const Color(0xFF1746A2),
        unselectedItemColor: Colors.grey,
        onTap: (i) {
          switch (i) {
            case 1:
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()));
              break;
            case 2:
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const FavoritesScreen()));
              break;
            case 3:
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()));
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: loc?.translate('hotel') ?? 'Home',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search_outlined),
            label: loc?.translate('search') ?? 'Search',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: loc?.translate('favourites') ?? 'favourites',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_2),
            label: loc?.translate('profile') ?? 'Profile',
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CATEGORY CONTENT
  // ---------------------------------------------------------------------------
  Widget _buildCategoryContent(String category) {
    if (_loading) return _buildShimmer();

    switch (category) {
      case 'Places':
        return _places.isEmpty
            ? _emptyState()
            : _buildList(_places.map((e) => HeritageCard(dest: e)).toList());
      case 'Hotels':
        return _hotels.isEmpty
            ? _emptyState()
            : _buildList(_hotels.map((e) => HotelCard(hotel: e)).toList());
      case 'Food':
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.restaurant_menu, size: 60, color: Color(0xFF1746A2)),
                SizedBox(height: 12),
                Text(
                  "🍴 Coming Soon!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1746A2),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Exciting food destinations are being added soon.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        );

      case 'All':
      // show only category summary cards (one per category)
        final List<Map<String, dynamic>> categoryCards = [
          {
            "title": "Explore Places",
            "image": _places.isNotEmpty
                ? _places.first.imageUrl
                : "https://img.freepik.com/free-photo/ancient-indian-fort.jpg",
            "category": "Places",
          },
          {
            "title": "Top Hotels",
            "image": _hotels.isNotEmpty
                ? _hotels.first.imageUrl
                : "https://img.freepik.com/free-photo/luxury-hotel-room.jpg",
            "category": "Hotels",
          },
          {
            "title": "Delicious Food",
            "image": _food.isNotEmpty
                ? _food.first["image"]
                : "https://img.freepik.com/free-photo/indian-food-platter_23-2148747718.jpg",
            "category": "Food",
          },
        ];

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: categoryCards.length,
          itemBuilder: (context, index) {
            final card = categoryCards[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  // Switch to the selected category
                  _selectedIndex = _categories.indexOf(card["category"]);
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(18)),
                      child: Image.network(
                        card["image"],
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 160,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image_not_supported, size: 40),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            card["title"],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1746A2),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              size: 16, color: Color(0xFF1746A2)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );

      default:
        return _emptyState();
    }
  }

  Widget _emptyState() => const Center(
    child: Text(
      "No data available.",
      style: TextStyle(color: Colors.grey, fontSize: 16),
    ),
  );

  Widget _buildList(List<Widget> widgets) {
    return ListView.builder(
      key: ValueKey(_selectedIndex),
      itemCount: widgets.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemBuilder: (context, i) => widgets[i],
    );
  }

  // ---------------------------------------------------------------------------
  // SHIMMER
  // ---------------------------------------------------------------------------
  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 4,
      padding: const EdgeInsets.all(16),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 160,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FOOD CARD
  // ---------------------------------------------------------------------------
  Widget _foodCard(Map<String, dynamic> food) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.network(
              food['image'],
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 140,
                color: Colors.grey.shade200,
                child: const Icon(Icons.broken_image, size: 40),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food['name'] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1746A2),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  food['desc'] ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => _showDetails(food['name']),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1746A2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      "View Details",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDetails(String name) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(name),
        content: const Text("Detailed view coming soon..."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}