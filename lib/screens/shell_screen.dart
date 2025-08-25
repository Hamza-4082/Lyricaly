import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'library_screen.dart';
import '../widgets/now_playing_bar.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/music_provider.dart';



class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});


  @override
  State<ShellScreen> createState() => _ShellScreenState();
}


class _ShellScreenState extends State<ShellScreen> {
  int _index = 0;
  final _pages = const [HomeScreen(), SearchScreen(), LibraryScreen()];


  @override
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final auth = context.read<AuthProvider>();
      context.read<MusicProvider>().fetchSongs(token: auth.token);
    });
  }


  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const NowPlayingBar(),
            BottomNavigationBar(
              currentIndex: _index,
              onTap: (i) => setState(() => _index = i),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
                BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Your Library'),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
