import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:opentrivia/generated/l10n.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:opentrivia/models/category.dart';
import 'package:opentrivia/ui/pages/LeaderboardPage.dart';
import 'package:opentrivia/ui/pages/SettingsPage.dart';
import 'package:opentrivia/ui/widgets/notification_service.dart'; // Importer le service de notifications
import 'package:opentrivia/ui/widgets/quiz_options.dart';

class HomePage extends StatelessWidget {
  final Function(bool) onThemeChanged;
  final Function(Locale) onLanguageChanged;
  final NotificationService
      notificationService; // Ajouter le service de notifications

  HomePage({
    Key? key,
    required this.onThemeChanged,
    required this.onLanguageChanged,
    required this.notificationService, // Initialiser le service de notifications
  }) : super(key: key);

  final List<Color> tileColors = [
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.indigo,
    Colors.lightBlue,
    Colors.amber,
    Colors.deepOrange,
    Colors.red,
    Colors.brown
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).app_title),
        elevation: 4.0,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black.withOpacity(0.8)
            : Colors.blueAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.leaderboard),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LeaderboardPage()),
              );
            },
          ),
          Switch(
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (value) {
              onThemeChanged(value);
            },
          ),
          PopupMenuButton<Locale>(
            onSelected: (Locale locale) {
              onLanguageChanged(locale);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: Locale('en', ''), child: Text(S.of(context).english)),
              PopupMenuItem(
                  value: Locale('fr', ''), child: Text(S.of(context).french)),
              PopupMenuItem(
                  value: Locale('ar', ''), child: Text(S.of(context).arabic)),
            ],
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    onSoundChanged: (value) {
                      // Gérer l'activation/désactivation du son ici
                    },
                    onNotificationChanged: (value) {
                      // Gérer l'activation/désactivation des notifications
                    },
                    isSoundEnabled: true, // Par défaut, le son est activé
                    isNotificationEnabled:
                        true, // Par défaut, les notifications sont activées
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.green],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              height: 200,
            ),
          ),
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    S.of(context).select_category,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 1000
                        ? 7
                        : MediaQuery.of(context).size.width > 600
                            ? 5
                            : 3,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    _buildCategoryItem,
                    childCount: categories.length,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Exemple d'envoi de notification lorsque l'utilisateur clique sur le bouton
          notificationService.showNotification(
            title: 'Welcome to IPSAS Quiz!',
            body: 'Get ready to test your knowledge!',
          );
        },
        child: Icon(Icons.notifications),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, int index) {
    Category category = categories[index];
    return MaterialButton(
      elevation: 8.0,
      highlightElevation: 10.0,
      onPressed: () => _categoryPressed(context, category),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.grey.shade800,
      textColor: Colors.white70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (category.icon != null) Icon(category.icon, size: 40),
          if (category.icon != null) SizedBox(height: 10.0),
          AutoSizeText(
            category.name,
            minFontSize: 12.0,
            textAlign: TextAlign.center,
            maxLines: 3,
            wrapWords: false,
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  _categoryPressed(BuildContext context, Category category) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => BottomSheet(
        builder: (_) => QuizOptionsDialog(category: category),
        onClosing: () {},
      ),
    );
  }
}
