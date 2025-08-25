import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/announcement_provider.dart';
import 'providers/favourites_provider.dart';
import 'providers/player_provider.dart';

import 'screens/auth_screen.dart';
import 'screens/shell_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/advertiser_screen.dart';

void main() {
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
            home: auth.isAuth
                ? _roleBasedHome(auth.role)
                : const AuthScreen(),
          );
        },
      ),
    );
  }

  Widget _roleBasedHome(String? role) {
    switch (role) {
      case 'admin':
        return const AdminScreen();
      case 'advertiser':
        return const AdvertiserScreen();
      default:
        return const ShellScreen(); // user
    }
  }
}
