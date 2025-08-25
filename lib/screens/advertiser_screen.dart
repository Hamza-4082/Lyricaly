import 'package:flutter/material.dart';

class AdvertiserScreen extends StatelessWidget {
  const AdvertiserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Advertiser Panel")),
      body: const Center(
        child: Text(
          "Welcome Advertiser! Here you can manage your ads and campaigns.",
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
