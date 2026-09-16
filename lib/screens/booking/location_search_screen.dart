import 'package:flutter/material.dart';

class LocationSearchScreen extends StatelessWidget {
  const LocationSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search location')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Where to?',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
