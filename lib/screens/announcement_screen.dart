import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/announcement_provider.dart';
import '../providers/auth_provider.dart';

class AnnouncementsScreen extends StatefulWidget {
  static const String routeName = "/announcements";
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      if (auth.token != null) {
        Provider.of<AnnouncementProvider>(context, listen: false)
            .fetchAnnouncements(token: auth.token);
      }
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Announcements")),
      body: Consumer<AnnouncementProvider>(
        builder: (ctx, announcementProvider, child) {
          if (announcementProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final announcements = announcementProvider.announcements;
          if (announcements.isEmpty) {
            return const Center(
              child: Text("No announcements yet."),
            );
          }
          return ListView.builder(
            itemCount: announcements.length,
            itemBuilder: (ctx, i) {
              final announcement = announcements[i];
              return Card(
                margin: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                child: ListTile(
                  title: Text(announcement.text),
                  subtitle: Text(
                    DateTime.fromMillisecondsSinceEpoch(
                        announcement.timestamp)
                        .toString(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}