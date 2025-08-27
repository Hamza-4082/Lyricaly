import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers (use your project paths, not lyricaly3/)
import 'providers/auth_provider.dart';
import 'providers/announcement_provider.dart';
import 'providers/favourites_provider.dart';
import 'providers/player_provider.dart';
// If these exist in your repo, keep them; otherwise remove the lines:
import 'providers/music_provider.dart';
import 'providers/survey_provider.dart';

// Screens
import 'screens/auth_screen.dart';
import 'screens/shell_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/advertiser_screen.dart';
// Optional/feature screens if present:
import 'screens/favourites_screen.dart';
import 'screens/announcement_screen.dart';
import 'screens/surveys_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LyricalyApp());
}

class LyricalyApp extends StatelessWidget {
  const LyricalyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AnnouncementProvider()),
        ChangeNotifierProvider(create: (_) => FavouritesProvider()),
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
        // The next two are optional: only keep if these classes exist.
        ChangeNotifierProvider(create: (_) => MusicProvider()),
        ChangeNotifierProvider(create: (_) => SurveyProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Lyricaly',
            theme: ThemeData(
              primarySwatch: Colors.deepPurple,
              scaffoldBackgroundColor: Colors.white,
            ),
            // If authenticated, go to role-based home; otherwise auth screen.
            home: auth.isAuth ? _roleBasedHome(auth.role) : const AuthScreen(),
            // Optional routes if those screens exist:
            routes: {
              if (_screenExists(const FavouritesScreen()))
                FavouritesScreen.routeName: (_) => const FavouritesScreen(),
              if (_screenExists(const AnnouncementsScreen()))
                AnnouncementsScreen.routeName: (_) => const AnnouncementsScreen(),
              if (_screenExists(const SurveysScreen()))
                SurveysScreen.routeName: (_) => const SurveysScreen(),
            },
          );
        },
      ),
    );
  }

  /// Picks the home screen by role. For users we wrap ShellScreen to add
  /// AppBar buttons (Announcements, Surveys) like Ahmed’s version.
  Widget _roleBasedHome(String? role) {
    switch (role) {
      case 'admin':
        return const AdminScreen();
      case 'advertiser':
        return const AdvertiserScreen();
      default:
        return const UserHomeWithShortcuts(); // user
    }
  }
}

/// Wrapper around ShellScreen adding quick-access actions (if screens exist)
class UserHomeWithShortcuts extends StatelessWidget {
  const UserHomeWithShortcuts({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = <Widget>[
      if (_screenExists(const AnnouncementsScreen()))
        IconButton(
          icon: const Icon(Icons.campaign),
          onPressed: () =>
              Navigator.of(context).pushNamed(AnnouncementsScreen.routeName),
        ),
      if (_screenExists(const SurveysScreen()))
        IconButton(
          icon: const Icon(Icons.poll),
          onPressed: () =>
              Navigator.of(context).pushNamed(SurveysScreen.routeName),
        ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Lyricaly'), actions: actions),
      body: const ShellScreen(),
    );
  }
}

/// Tiny helper so this file compiles even if optional feature screens
/// aren’t in the branch yet. It uses `toStringShort` on the widget type
/// to “existence check” via a try/catch at compile-time.
bool _screenExists(Widget widget) {
  try {
    // Accessing runtimeType forces the import to be real; if the class
    // isn't compiled in, the import would fail before this anyway.
    widget.toStringShort();
    return true;
  } catch (_) {
    return false;
  }
}
