import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/music_provider.dart';
import '../providers/favourites_provider.dart';
import '../providers/announcement_provider.dart';
import '../providers/survey_provider.dart';
import 'announcement_screen.dart';
import 'favourites_screen.dart';
import 'surveys_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final music = Provider.of<MusicProvider>(context, listen: false);
    final fav = Provider.of<FavouritesProvider>(context, listen: false);
    final ann = Provider.of<AnnouncementProvider>(context, listen: false);
    final survey = Provider.of<SurveyProvider>(context, listen: false);

    music.fetchSongs(token: auth.token);
    ann.fetchAnnouncements(token: auth.token);
    survey.fetchSurveys(token: auth.token);
    if (auth.userId != null && auth.token != null) {
      fav.loadFavourites(userId: auth.userId!, token: auth.token!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final music = Provider.of<MusicProvider>(context);
    final fav = Provider.of<FavouritesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.campaign),
            tooltip: "Announcements",
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AnnouncementsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.poll),
            tooltip: "Surveys",
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SurveysScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: "Favourites",
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const FavouritesScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () => auth.logout(),
          ),
        ],
      ),
      body: music.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: music.songs.length,
        itemBuilder: (ctx, i) {
          final s = music.songs[i];
          final isFav = fav.isFavourite(s.id);
          return ListTile(
            leading: const Icon(Icons.music_note),
            title: Text(s.title),
            subtitle: Text(s.artist),
            trailing: IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : null,
              ),
              onPressed: () {
                if (auth.userId != null && auth.token != null) {
                  Provider.of<FavouritesProvider>(context, listen: false)
                      .toggleFavourite(
                    songId: s.id,
                    userId: auth.userId!,
                    token: auth.token!,
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}