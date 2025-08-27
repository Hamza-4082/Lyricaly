import 'package:flutter/material.dart';
import 'package:lyricaly3/screens/announcement_screen.dart';
import 'favourites_screen.dart';


class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(pinned: true, title: Text('Your Library')),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _LibRow(
                  icon: Icons.favorite,
                  title: 'Favourites',
                  onTap: () => Navigator.of(context).pushNamed(FavouritesScreen.routeName),
                ),
                const SizedBox(height: 12),
                _LibRow(
                  icon: Icons.campaign,
                  title: 'Announcements',
                  onTap: () => Navigator.of(context).pushNamed(AnnouncementsScreen.routeName),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


class _LibRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _LibRow({required this.icon, required this.title, required this.onTap});


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1F1F1F),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            const Spacer(),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}