import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UploadScreen()),
          );
        },
        icon: const Icon(Icons.add_a_photo),
        label: const Text('New Product'),
      ),
    );
  }
}

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePhoto() async {
    // This triggers the native Android camera
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _imageFile = File(photo.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Product'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_imageFile != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(_imageFile!, height: 300, fit: BoxFit.cover),
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('No product photo captured yet.', style: TextStyle(fontSize: 16)),
              ),
            ElevatedButton.icon(
              onPressed: _takePhoto,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Open Camera'),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
            ),
            const SizedBox(height: 20),
            if (_imageFile != null)
              FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Image ready for API upload!')),
                  );
                },
                icon: const Icon(Icons.cloud_upload),
                label: const Text('Analyze & Upload'),
              ),
          ],
        ),
      ),
    );
  }
}