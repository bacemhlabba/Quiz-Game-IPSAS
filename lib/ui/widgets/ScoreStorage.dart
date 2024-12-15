import 'package:opentrivia/models/score.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ScoreStorage {
  static const _key = 'scores';

  Future<void> saveScore(Score score) async {
    final prefs = await SharedPreferences.getInstance();
    final scores = await getScores();
    scores.add(score);
    final encodedScores = json.encode(scores.map((e) => e.toJson()).toList());
    prefs.setString(_key, encodedScores);
  }

  Future<List<Score>> getScores() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedScores = prefs.getString(_key);
    if (encodedScores == null) return [];
    final List decoded = json.decode(encodedScores);
    return decoded.map((e) => Score.fromJson(e)).toList();
  }

  Future<void> clearScores() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_key);
  }
}
