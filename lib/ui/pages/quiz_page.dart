import 'package:flutter/material.dart';
import 'package:opentrivia/models/category.dart';
import 'package:opentrivia/models/question.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:opentrivia/models/score.dart';
import 'package:opentrivia/ui/pages/quiz_finished.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:opentrivia/ui/widgets/ScoreStorage.dart';
import 'package:audioplayers/audioplayers.dart';

class QuizPage extends StatefulWidget {
  final List<Question> questions;
  final Category? category;

  const QuizPage({Key? key, required this.questions, this.category})
      : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final TextStyle _questionStyle = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.white);

  int _currentIndex = 0;
  final Map<int, dynamic> _answers = {};
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final ScoreStorage storage = ScoreStorage();

  late AudioPlayer _audioPlayer; // Player pour la musique
  bool _isAudioLoading = false; // Indicateur de chargement audio

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playBackgroundMusic(); // Jouer la musique dès que la page est chargée
  }

  // Jouer la musique de fond
  void _playBackgroundMusic() async {
    setState(() {
      _isAudioLoading = true;
    });

    try {
      // Définir la source audio
      final source = AssetSource('assets/sounds/calm_sound.mp3');

      // Définir la source et jouer la musique
      await _audioPlayer.setSource(source);
      _audioPlayer.setReleaseMode(ReleaseMode.loop); // Loop the music
      await _audioPlayer.play(source); // Fournir la source comme argument
    } catch (e) {
      print("Erreur de lecture audio: $e");
    } finally {
      setState(() {
        _isAudioLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.stop(); // Arrêter la musique quand la page est fermée
  }

  @override
  Widget build(BuildContext context) {
    Question question = widget.questions[_currentIndex];
    final List<dynamic> options = question.incorrectAnswers!;
    if (!options.contains(question.correctAnswer)) {
      options.add(question.correctAnswer);
      options.shuffle();
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text(widget.category!.name),
          elevation: 0,
        ),
        body: Stack(
          children: <Widget>[
            ClipPath(
              clipper: WaveClipperTwo(),
              child: Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white70,
                        child: Text("${_currentIndex + 1}"),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          HtmlUnescape().convert(
                              widget.questions[_currentIndex].question!),
                          softWrap: true,
                          style: MediaQuery.of(context).size.width > 800
                              ? _questionStyle.copyWith(fontSize: 30.0)
                              : _questionStyle,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ...options.map((option) => RadioListTile(
                              title: Text(
                                HtmlUnescape().convert("$option"),
                                style: MediaQuery.of(context).size.width > 800
                                    ? TextStyle(fontSize: 30.0)
                                    : null,
                              ),
                              groupValue: _answers[_currentIndex],
                              value: option,
                              onChanged: (dynamic value) {
                                setState(() {
                                  _answers[_currentIndex] = option;
                                });
                              },
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: MediaQuery.of(context).size.width > 800
                              ? const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 64.0)
                              : null,
                        ),
                        child: Text(
                          _currentIndex == (widget.questions.length - 1)
                              ? "Submit"
                              : "Next",
                          style: MediaQuery.of(context).size.width > 800
                              ? TextStyle(fontSize: 30.0)
                              : null,
                        ),
                        onPressed: _nextSubmit,
                      ),
                    ),
                  ),
                  if (_isAudioLoading) // Indicateur de chargement audio
                    Center(child: CircularProgressIndicator()),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _nextSubmit() async {
    if (_answers[_currentIndex] == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("You must select an answer to continue."),
      ));
      return;
    }
    if (_currentIndex < (widget.questions.length - 1)) {
      setState(() {
        _currentIndex++;
      });
    } else {
      // Calculer le score final
      int score = 0;
      widget.questions.asMap().forEach((index, question) {
        if (question.correctAnswer == _answers[index]) {
          score++;
        }
      });

      // Sauvegarder le score
      final savedScore = Score(
        category: widget.category?.name ?? 'Unknown',
        difficulty: 'Medium', // Ajuste cela en fonction de ton application
        score: score,
      );
      await storage.saveScore(savedScore);

      // Naviguer vers la page de fin
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => QuizFinishedPage(
              questions: widget.questions, answers: _answers)));
    }
  }

  Future<bool> _onWillPop() async {
    final resp = await showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text(
                "Are you sure you want to quit the quiz? All your progress will be lost."),
            title: Text("Warning!"),
            actions: <Widget>[
              TextButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              TextButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        });
    return resp ?? false;
  }
}
