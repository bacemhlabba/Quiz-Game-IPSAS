import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:opentrivia/generated/l10n.dart'; // Import generated localization file
import 'package:opentrivia/ui/pages/home.dart'; // Your HomePage widget

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Initial theme mode
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = Locale('en', ''); // Default locale is English

  // Toggle the theme mode
  void _toggleTheme(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  // Change the locale (language) of the app
  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OpenTrivia',
      themeMode: _themeMode, // Dynamically switch between themes
      theme: ThemeData(
        primarySwatch: Colors.pink,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        fontFamily: "Montserrat",
        buttonTheme: ButtonThemeData(
            buttonColor: Colors.pink,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            textTheme: ButtonTextTheme.primary),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.indigo,
        scaffoldBackgroundColor: Colors.black87,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo,
          elevation: 0,
        ),
        buttonTheme: ButtonThemeData(
            buttonColor: Colors.pink,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            textTheme: ButtonTextTheme.primary),
      ),
      supportedLocales: [
        Locale('en', ''), // English
        Locale('fr', ''), // French
        Locale('ar', ''), // Arabic
      ],
      locale: _locale, // Use the locale set by the user
      localizationsDelegates: [
        S.delegate, // The generated localization delegate
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: HomePage(
        onThemeChanged: _toggleTheme,
        onLanguageChanged: _changeLanguage, // Pass the language change callback
      ),
    );
  }
}
