import 'package:flutter/material.dart';

void main() {
  runApp(const CrafLensApp());
}

class CrafLensApp extends StatelessWidget {
  const CrafLensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CrafLens Artisan Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const ArtisanDashboard(),
    );
  }
}

class ArtisanDashboard extends StatefulWidget {
  const ArtisanDashboard({super.key});

  @override
  State<ArtisanDashboard> createState() => _ArtisanDashboardState();
}

class _ArtisanDashboardState extends State<ArtisanDashboard> {
  // A temporary mock list of products until the Python backend is connected
  final List<Map<String, String>> _catalog = [
    {"title": "Terracotta Clay Pot", "tags": "Handmade, Pottery"},
    {"title": "Woven Bamboo Basket", "tags": "Eco-friendly, Storage"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Catalog'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: _catalog.length,
        itemBuilder: (context, index) {
          final product = _catalog[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.image, size: 50, color: Colors.grey),
              title: Text(product["title"]!),
              subtitle: Text("AI Tags: ${product["tags"]}"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Upload screen coming soon!')),
          );
        },
        icon: const Icon(Icons.add_a_photo),
        label: const Text('New Product'),
      ),
    );
  }
}