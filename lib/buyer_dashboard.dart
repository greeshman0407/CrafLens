import 'package:flutter/material.dart';

class BuyerDashboard extends StatefulWidget {
  const BuyerDashboard({super.key});

  @override
  State<BuyerDashboard> createState() => _BuyerDashboardState();
}

class _BuyerDashboardState extends State<BuyerDashboard> {
  // Dummy data for the marketplace feed
  final List<Map<String, dynamic>> _marketItems = [
    {"title": "Terracotta Clay Pot", "artisan": "Ramesh K.", "price": "₹450", "tags": "Handmade, Pottery"},
    {"title": "Woven Bamboo Basket", "artisan": "Lakshmi S.", "price": "₹300", "tags": "Eco-friendly, Storage"},
    {"title": "Hand-painted Wooden Toy", "artisan": "Channapatna Crafts", "price": "₹600", "tags": "Wooden, Toys"},
    {"title": "Embroidered Shawl", "artisan": "Kullu Weavers", "price": "₹1200", "tags": "Textile, Winter"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CrafLens Marketplace'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () {}),
        ],
      ),
      // A GridView makes it look like a real shopping catalog
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 items per row
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75, // Makes the cards taller than they are wide
        ),
        itemCount: _marketItems.length,
        itemBuilder: (context, index) {
          final item = _marketItems[index];
          return Card(
            elevation: 3,
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Placeholder for the product image
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          item["title"],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis
                      ),
                      Text(
                          "By: ${item["artisan"]}",
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700)
                      ),
                      const SizedBox(height: 4),
                      Text(
                          item["price"],
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}