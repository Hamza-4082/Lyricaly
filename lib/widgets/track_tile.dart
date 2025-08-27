import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/songs.dart';
import '../screens/player_screen.dart';
import '../providers/player_provider.dart';


class TrackTile extends StatelessWidget {
  final Song song;
  const TrackTile({super.key, required this.song});


  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: const Color(0xFF1F1F1F),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      leading: Container(
        width: 48, height: 48,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(song.artist, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70)),
      trailing: const Icon(Icons.more_vert),
      onTap: () async {
        final player = context.read<PlayerProvider>();
        // Try to play, but don't block navigation if there's a network hiccup
        player.play(song).catchError((e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not play: $e')),
          );
        });
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => PlayerScreen(song: song)),
        );
      },
    );
  }

}