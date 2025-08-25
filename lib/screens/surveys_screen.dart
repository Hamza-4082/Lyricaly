import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/survey_provider.dart';
import '../providers/auth_provider.dart';

class SurveysScreen extends StatefulWidget {
  static const String routeName = "/surveys";
  const SurveysScreen({super.key});

  @override
  State<SurveysScreen> createState() => _SurveysScreenState();
}

class _SurveysScreenState extends State<SurveysScreen> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      if (auth.token != null) {
        Provider.of<SurveyProvider>(context, listen: false)
            .fetchSurveys(token: auth.token);
      }
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Surveys")),
      body: Consumer<SurveyProvider>(
        builder: (ctx, surveyProvider, child) {
          if (surveyProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final surveys = surveyProvider.surveys;
          if (surveys.isEmpty) {
            return const Center(child: Text("No surveys yet."));
          }
          return ListView.builder(
            itemCount: surveys.length,
            itemBuilder: (ctx, i) {
              final survey = surveys[i];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(survey.question),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...survey.options.map((opt) => Text("• $opt")),
                      Text("Posted: ${DateTime.fromMillisecondsSinceEpoch(survey.timestamp)}"),
                    ],
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