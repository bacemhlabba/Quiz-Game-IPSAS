import 'package:flutter/material.dart';
import 'package:opentrivia/models/score.dart';
import 'package:opentrivia/ui/widgets/ScoreStorage.dart';

class LeaderboardPage extends StatelessWidget {
  final ScoreStorage storage = ScoreStorage();

  LeaderboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<List<Score>>(
          future: storage.getScores(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error loading scores'));
            }

            final scores = snapshot.data ?? [];
            if (scores.isEmpty) {
              return Center(
                  child: Text('No scores available',
                      style: TextStyle(fontSize: 18.0, color: Colors.white)));
            }

            // Trier les scores par ordre décroissant
            scores.sort((a, b) => b.score.compareTo(a.score));

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: scores.length,
              itemBuilder: (context, index) {
                final score = scores[index];
                return Card(
                  elevation: 5.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    leading:
                        Icon(Icons.star, color: Colors.deepPurple, size: 30),
                    title: Text(
                      "${score.category} (${score.difficulty})",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    trailing: Text(
                      "${score.score}",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await storage.clearScores();
          (context as Element).reassemble(); // Rafraîchir la vue
        },
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.delete),
        tooltip: 'Clear Scores',
      ),
    );
  }
}
