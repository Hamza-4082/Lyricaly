import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/music_provider.dart';
import '../providers/announcement_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/music_provider.dart';
import '../providers/announcement_provider.dart';
import '../providers/survey_provider.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  // Song controllers
  final _title = TextEditingController();
  final _artist = TextEditingController();
  final _audioUrl = TextEditingController();

  // Announcement controller
  final _announce = TextEditingController();

  // Survey controllers
  final _surveyQuestion = TextEditingController();
  final List<TextEditingController> _surveyOptions = [
    TextEditingController(),
    TextEditingController(),
  ];

  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    final auth = Provider.of<AuthProvider>(context, listen: false);
    Provider.of<MusicProvider>(context, listen: false)
        .fetchSongs(token: auth.token);
    Provider.of<AnnouncementProvider>(context, listen: false)
        .fetchAnnouncements(token: auth.token);
    Provider.of<SurveyProvider>(context, listen: false)
        .fetchSurveys(token: auth.token);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final music = Provider.of<MusicProvider>(context);
    final ann = Provider.of<AnnouncementProvider>(context);
    final survey = Provider.of<SurveyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add New Song
            const Text("Add New Song",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: _title, decoration: const InputDecoration(labelText: "Song Title")),
            TextField(controller: _artist, decoration: const InputDecoration(labelText: "Artist")),
            TextField(controller: _audioUrl, decoration: const InputDecoration(labelText: "Audio URL")),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                if (_title.text.isEmpty ||
                    _artist.text.isEmpty ||
                    _audioUrl.text.isEmpty ||
                    auth.token == null) return;

                await Provider.of<MusicProvider>(context, listen: false)
                    .addSong(
                  title: _title.text.trim(),
                  artist: _artist.text.trim(),
                  audioUrl: _audioUrl.text.trim(),
                  token: auth.token!,
                );
                _title.clear();
                _artist.clear();
                _audioUrl.clear();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Song added')));
                }
              },
              child: const Text("Add Song"),
            ),

            const Divider(height: 32),

            // Post Announcement
            const Text("Post Announcement",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: _announce,
              decoration: const InputDecoration(labelText: "Announcement"),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                if (_announce.text.isEmpty ||
                    auth.token == null ||
                    auth.userId == null) return;

                await Provider.of<AnnouncementProvider>(context, listen: false)
                    .addAnnouncement(
                  text: _announce.text.trim(),
                  authorId: auth.userId!,
                  token: auth.token!,
                );
                _announce.clear();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Announcement posted')));
                }
              },
              child: const Text("Post"),
            ),

            const Divider(height: 32),

            // Create Survey
            const Text("Create Survey",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: _surveyQuestion,
              decoration: const InputDecoration(labelText: "Survey Question"),
            ),
            ..._surveyOptions.asMap().entries.map((entry) => Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: entry.value,
                    decoration: InputDecoration(labelText: "Option ${entry.key + 1}"),
                  ),
                ),
                if (_surveyOptions.length > 2)
                  IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () {
                      setState(() {
                        _surveyOptions.removeAt(entry.key);
                      });
                    },
                  ),
              ],
            )),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _surveyOptions.add(TextEditingController());
                    });
                  },
                  child: const Text("Add Option"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final question = _surveyQuestion.text.trim();
                    final options = _surveyOptions
                        .map((c) => c.text.trim())
                        .where((o) => o.isNotEmpty)
                        .toList();
                    if (question.isEmpty ||
                        options.length < 2 ||
                        auth.token == null ||
                        auth.userId == null) return;
                    await Provider.of<SurveyProvider>(context, listen: false)
                        .addSurvey(
                      question: question,
                      options: options,
                      authorId: auth.userId!,
                      token: auth.token!,
                    );
                    _surveyQuestion.clear();
                    for (var c in _surveyOptions) {
                      c.clear();
                    }
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Survey created')));
                    }
                  },
                  child: const Text("Post Survey"),
                ),
              ],
            ),

            const Divider(height: 32),

            // Existing Songs
            const Text("Existing Songs",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (music.isLoading)
              const Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ),
            ...music.songs.map(
                  (s) => ListTile(
                leading: const Icon(Icons.music_note),
                title: Text(s.title),
                subtitle: Text(s.artist),
                dense: true,
              ),
            ),

            const Divider(height: 32),

            // Announcements
            const Text("Announcements",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (ann.isLoading)
              const Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ),
            ...ann.announcements.map(
                  (a) => ListTile(
                leading: const Icon(Icons.campaign),
                title: Text(a.text),
                subtitle: Text(
                    DateTime.fromMillisecondsSinceEpoch(a.timestamp).toString()),
                dense: true,
              ),
            ),

            const Divider(height: 32),

            // Surveys
            const Text("Surveys",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (survey.isLoading)
              const Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ),
            ...survey.surveys.map(
                  (s) => Card(
                child: ListTile(
                  title: Text(s.question),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...s.options.map((opt) => Text("• $opt")),
                      Text("Posted: ${DateTime.fromMillisecondsSinceEpoch(s.timestamp)}"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}