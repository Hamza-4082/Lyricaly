// lib/screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../widgets/track_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _q = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final music = context.watch<MusicProvider>();
    final results = music.searchLocal(_q);

    return CustomScrollView(
      slivers: [
        const SliverAppBar(pinned: true, title: Text('Search')),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              onChanged: (v) => setState(() => _q = v),
              decoration: InputDecoration(
                hintText: 'What do you want to listen to?',
                filled: true,
                fillColor: const Color(0xFF1F1F1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
        if (music.isLoading)
          const SliverToBoxAdapter(
            child: Center(child: Padding(
                padding: EdgeInsets.all(24), child: CircularProgressIndicator())),
          )
        else
          SliverList.separated(
            itemCount: results.length,
            separatorBuilder: (_, __) => const SizedBox(height: 6),
            itemBuilder: (ctx, i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TrackTile(song: results[i]),
            ),
          ),
      ],
    );
  }
}
