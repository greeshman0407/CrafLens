import 'package:flutter/material.dart';
import 'buyer_dashboard.dart';
import 'main.dart'; // To navigate to ArtisanDashboard after login

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLogin = true; // Toggles between Login and Sign Up
  String _selectedRole = 'Artisan'; // Default role

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      print("Action: ${_isLogin ? 'Login' : 'Sign Up'}");
      print("Email: $email | Role: $_selectedRole");

      // Route based on the selected role
      if (_selectedRole == 'Artisan') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ArtisanDashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BuyerDashboard()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Welcome Back' : 'Create Account'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/Craflens_logo.png',
                  height: 100, // Adjust this size if it looks too big or small on your Realme screen
                ),
                const SizedBox(height: 20),
                Text(
                  'CrafLens',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                // Role Selector
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'Artisan', label: Text('Artisan')),
                    ButtonSegment(value: 'Buyer', label: Text('Commercial Buyer')),
                  ],
                  selected: {_selectedRole},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      _selectedRole = newSelection.first;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) => value!.isEmpty ? 'Enter your email' : null,
                ),
                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) => value!.isEmpty ? 'Enter your password' : null,
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    onPressed: _submitForm,
                    child: Text(_isLogin ? 'Login' : 'Sign Up', style: const TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 16),

                // Toggle Login/Signup
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(_isLogin
                      ? "Don't have an account? Sign Up"
                      : "Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}