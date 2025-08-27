import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/songs.dart';
import '../providers/player_provider.dart';

class PlayerScreen extends StatelessWidget {
  final Song song;

  const PlayerScreen({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F1F1F),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Song title + artist
            Text(song.title,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(song.artist, style: const TextStyle(color: Colors.white70)),

            const SizedBox(height: 16),

            // Progress bar
            _ProgressBar(),

            const SizedBox(height: 12),

            // Controls row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: const Icon(Icons.shuffle), onPressed: () {}),
                const SizedBox(width: 8),
                IconButton(
                    icon: const Icon(Icons.skip_previous_rounded, size: 36),
                    onPressed: () {}),
                const SizedBox(width: 8),

                // Play / Pause button
                ElevatedButton(
                  onPressed: () {
                    player.isPlaying
                        ? player.pause()
                        : player.play(song); // ✅ fixed
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(10),
                  ),
                  child: Icon(
                      player.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow_rounded,
                      size: 36),
                ),

                const SizedBox(width: 8),
                IconButton(
                    icon: const Icon(Icons.skip_next_rounded, size: 36),
                    onPressed: () {}),
                const SizedBox(width: 8),
                IconButton(icon: const Icon(Icons.repeat), onPressed: () {}),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();

    final duration = player.duration;
    final position = player.position;

    return Column(
      children: [
        Slider(
          value: position.inSeconds.toDouble(),
          min: 0,
          max: duration.inSeconds.toDouble(),
          onChanged: (value) {
            player.seek(Duration(seconds: value.toInt()));
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_formatTime(position),
                style: const TextStyle(color: Colors.white70)),
            Text(_formatTime(duration),
                style: const TextStyle(color: Colors.white70)),
          ],
        )
      ],
    );
  }

  String _formatTime(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(1, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
