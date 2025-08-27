import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';


class NowPlayingBar extends StatelessWidget {
  const NowPlayingBar({super.key});


  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    final s = player.current;


    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF181818),
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          const _CoverBox(),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              s?.title ?? 'Nothing playing',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          IconButton(
            icon: Icon(player.isPlaying ? Icons.pause : Icons.play_arrow_rounded),
            onPressed: s == null
                ? null
                : () {
              player.isPlaying ? player.pause() : player.play(s);
            },
          ),
        ],
      ),
    );
  }
}


class _CoverBox extends StatelessWidget {
  const _CoverBox();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}