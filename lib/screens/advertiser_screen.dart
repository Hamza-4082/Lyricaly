import 'package:flutter/material.dart';

class AdvertiserScreen extends StatelessWidget {
  const AdvertiserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Advertiser Dashboard")),
      body: const Center(
        child: Text("Advertiser features: post ads"),
      ),
    );
  }
}
