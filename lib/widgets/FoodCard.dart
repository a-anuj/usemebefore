import 'package:flutter/material.dart';
import 'package:usemebefore/widgets/foodItem.dart';

class FoodCard extends StatelessWidget {
  const FoodCard({super.key, required this.food});
  final FoodItem food;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onInverseSurface,
      margin: const EdgeInsets.all(12),
      child: Padding(
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
    );
  }
}
