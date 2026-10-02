import 'dart:io';
import 'login_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

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
      home: const LoginScreen(),
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
  Widget _buildTag(String label, BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      side: BorderSide.none,
    );
  }

class _UploadScreenState extends State<UploadScreen> {
  File? _imageFile;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  // Controllers for the new text fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _imageFile = File(photo.path);
      });
    }
  }

  Future<void> _uploadToServer() async {
    if (_imageFile == null) return;

    // Basic validation
    if (_titleController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title and price.')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      var uri = Uri.parse('http://192.168.1.17:8000/upload');
      var request = http.MultipartRequest('POST', uri);

      // Attach the image
      request.files.add(await http.MultipartFile.fromPath('file', _imageFile!.path));

      // Attach the text data for Greeshman's backend
      request.fields['title'] = _titleController.text;
      request.fields['price'] = _priceController.text;

      var response = await request.send().timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Upload successful! AI tagging complete.')),
          );
          Navigator.pop(context); // Go back to dashboard after success
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload failed. Server returned: ${response.statusCode}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Network error. Is the Python server running?')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Draft Listing'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Preview Area
            GestureDetector(
              onTap: _takePhoto,
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid),
                ),
                child: _imageFile != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(_imageFile!, fit: BoxFit.cover),
                )
                    : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Tap to take product photo', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Product Details Form
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Product Title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Price (₹)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.currency_rupee),
              ),
            ),
            const SizedBox(height: 24),

            // AI Tags Placeholder
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.auto_awesome, color: Colors.deepOrange),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'AI tags (material, category, etc.) will auto-generate here after upload.',
                      style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            _isUploading
                ? const Center(child: CircularProgressIndicator())
                : FilledButton.icon(
              onPressed: _uploadToServer,
              icon: const Icon(Icons.cloud_upload),
              label: const Text('Analyze & Publish'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}