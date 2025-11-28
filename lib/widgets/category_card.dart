import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CategoryRow extends StatefulWidget {
  const CategoryRow({super.key});
  @override
  State<CategoryRow> createState() => _CategoryRowState();
}

class _CategoryRowState extends State<CategoryRow> {
  final DatabaseReference db = FirebaseDatabase.instance.ref('categories');
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() async {
    final snap = await db.get();
    if (snap.exists) {
      final data = Map<String, dynamic>.from(snap.value as Map);
      setState(() => categories = data.values
          .map((e) => Map<String, dynamic>.from(e))
          .toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox(height: 80);
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (_, i) {
          final cat = categories[i];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    IconData(cat['icon'], fontFamily: 'MaterialIcons'),
                    color: Colors.blue,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 5),
                Text(cat['label'],
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          );
        },
      ),
    );
  }
}
