import 'package:flutter/material.dart';

class FavouritesScreen extends StatelessWidget {
  static const String routeName = "/favourites"; // ✅ added routeName

  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favourites")),
      body: const Center(
        child: Text("Your favourite lyrics will appear here."),
      ),
    );
  }
}
