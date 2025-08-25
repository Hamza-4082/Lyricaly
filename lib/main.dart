import 'package:flutter/material.dart';
import 'package:lyricaly3/providers/announcement_provider.dart';
import 'package:lyricaly3/providers/favourites_provider.dart';
import 'package:provider/provider.dart';
import 'package:lyricaly3/providers/music_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/auth_screen.dart';
import 'package:lyricaly3/screens/admin_screen.dart';
import 'package:lyricaly3/screens/advertiser_screen.dart';
import 'package:lyricaly3/screens/favourites_screen.dart';
import 'package:lyricaly3/screens/announcement_screen.dart';
import 'package:lyricaly3/screens/surveys_screen.dart'; // <-- ADD THIS IMPORT
import 'theme/app_theme.dart';
import 'screens/shell_screen.dart';
import 'providers/player_provider.dart';
import 'package:lyricaly3/providers/survey_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MusicProvider()),
        ChangeNotifierProvider(create: (_) => FavouritesProvider()),
        ChangeNotifierProvider(create: (_) => AnnouncementProvider()),
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
        ChangeNotifierProvider(create: (_) => SurveyProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) {
          return MaterialApp(
            title: 'Lyricaly',
            theme: AppTheme.dark().copyWith(
              scaffoldBackgroundColor: const Color(0xFF121212),
            ),
            debugShowCheckedModeBanner: false,
            home: auth.isAuth
                ? _getHomeScreen(auth.userRole)
                : const AuthScreen(),
            routes: {
              FavouritesScreen.routeName: (ctx) => const FavouritesScreen(),
              AnnouncementsScreen.routeName: (ctx) => const AnnouncementsScreen(),
              SurveysScreen.routeName: (ctx) => const SurveysScreen(), // <-- ADD THIS ROUTE
            },
          );
        },
      ),
    );
  }

  Widget _getHomeScreen(String? role) {
    switch (role) {
      case 'admin':
        return const AdminScreen();
      case 'advertiser':
        return const AdvertiserScreen();
      case 'user':
      default:
        return const UserHomeWithAnnouncements(); // wrapped shell
    }
  }
}

/// ✅ Wrapper around your ShellScreen that adds an AppBar with 📢 and 📝 button
class UserHomeWithAnnouncements extends StatelessWidget {
  const UserHomeWithAnnouncements({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lyricaly"),
        actions: [
          IconButton(
            icon: const Icon(Icons.campaign), // 📢 icon
            onPressed: () {
              Navigator.of(context).pushNamed(AnnouncementsScreen.routeName);
            },
          ),
          IconButton(
            icon: const Icon(Icons.poll), // 📝 surveys icon
            onPressed: () {
              Navigator.of(context).pushNamed(SurveysScreen.routeName);
            },
          ),
        ],
      ),
      body: const ShellScreen(), // your normal bottom tabs
    );
  }
}