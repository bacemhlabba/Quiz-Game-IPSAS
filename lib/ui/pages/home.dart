import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:opentrivia/generated/l10n.dart'; // Import the generated localization file
import 'package:auto_size_text/auto_size_text.dart';
import 'package:opentrivia/models/category.dart';
import 'package:opentrivia/ui/widgets/quiz_options.dart';

class HomePage extends StatelessWidget {
  final Function(bool) onThemeChanged;
  final Function(Locale) onLanguageChanged;

  HomePage(
      {Key? key, required this.onThemeChanged, required this.onLanguageChanged})
      : super(key: key);

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
        title: Text(S.of(context).app_title), // Localized app title
        elevation: 0,
        actions: <Widget>[
          Switch(
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (value) {
              onThemeChanged(value); // Pass the theme change back to MyApp
            },
          ),
          // Adding a language change button in AppBar
          PopupMenuButton<Locale>(
            onSelected: (Locale locale) {
              onLanguageChanged(locale); // Pass language change to MyApp
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: Locale('en', ''),
                child:
                    Text(S.of(context).english), // Localized text for English
              ),
              PopupMenuItem(
                value: Locale('fr', ''),
                child: Text(S.of(context).french), // Localized text for French
              ),
              PopupMenuItem(
                value: Locale('ar', ''),
                child: Text(S.of(context).arabic), // Localized text for Arabic
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
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
                    S.of(context).select_category, // Localized text
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0),
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
                        mainAxisSpacing: 10.0),
                    delegate: SliverChildBuilderDelegate(
                      _buildCategoryItem,
                      childCount: categories.length,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, int index) {
    Category category = categories[index];
    return MaterialButton(
      elevation: 1.0,
      highlightElevation: 1.0,
      onPressed: () => _categoryPressed(context, category),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.grey.shade800,
      textColor: Colors.white70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (category.icon != null) Icon(category.icon),
          if (category.icon != null) SizedBox(height: 5.0),
          AutoSizeText(
            category.name,
            minFontSize: 10.0,
            textAlign: TextAlign.center,
            maxLines: 3,
            wrapWords: false,
          ),
        ],
      ),
    );
  }

  _categoryPressed(BuildContext context, Category category) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => BottomSheet(
        builder: (_) => QuizOptionsDialog(
          category: category,
        ),
        onClosing: () {},
      ),
    );
  }
}
