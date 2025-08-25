import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../widgets/section_header.dart';
import '../widgets/track_tile.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final music = context.watch<MusicProvider>();
    final songs = music.songs; // ensure your provider exposes this


    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: const Text('Good evening'),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Recently played'),
                const SizedBox(height: 8),
                if (songs.isEmpty)
                  const Text(
                      'No songs yet.', style: TextStyle(color: Colors.white70))
                else
                  ListView.separated(
                    itemCount: songs.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, __) => const SizedBox(height: 6),
                    itemBuilder: (ctx, i) => TrackTile(song: songs[i]),
                  ),
                const SizedBox(height: 16),
                const SectionHeader(title: 'Made for you'),
                const SizedBox(height: 8),
                const _SimpleGrid(count: 6),
                const SizedBox(height: 24),
              ],
            ),
          ),
        )
      ],
    );
  }
}


class _SimpleGrid extends StatelessWidget {
  final int count;

  const _SimpleGrid({required this.count});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 3.4,
      ),
      itemBuilder: (ctx, i) =>
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F1F),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(child: Text('Playlist', maxLines: 2, overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
    );
  }
}