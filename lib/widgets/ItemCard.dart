import 'package:flutter/material.dart';
import 'package:usemebefore/widgets/Item.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.food});
  final Item food;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onInverseSurface,
      margin: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼 Image part
          if (food.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                food.imageUrl,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image),
              ),
            ),
          // 📝 Text part
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(food.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("Expires on: ${food.expiryDate}"),
                Text("Storage: ${food.storage}"),
                Text("Note: ${food.note}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
