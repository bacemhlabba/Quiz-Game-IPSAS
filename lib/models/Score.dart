class Score {
  final String category;
  final String difficulty;
  final int score;

  Score(
      {required this.category, required this.difficulty, required this.score});

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'difficulty': difficulty,
      'score': score,
    };
  }

  static Score fromJson(Map<String, dynamic> json) {
    return Score(
      category: json['category'],
      difficulty: json['difficulty'],
      score: json['score'],
    );
  }
}
