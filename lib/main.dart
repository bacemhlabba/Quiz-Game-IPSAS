import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:opentrivia/ui/widgets/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:opentrivia/generated/l10n.dart'; // Importer le fichier de localisation généré
import 'package:opentrivia/ui/pages/home.dart'; // Votre widget HomePage
 // Importer le service de notifications

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones(); // Initialisation des fuseaux horaires
  final NotificationService _notificationService = NotificationService();
  await _notificationService.initialize(); // Initialiser les notifications

  runApp(MyApp(notificationService: _notificationService));
}

class MyApp extends StatefulWidget {
  final NotificationService notificationService;

  MyApp({required this.notificationService});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Initialisation du mode sombre et de la langue
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = Locale('en', ''); // Locale par défaut en anglais

  // Fonction pour changer le mode du thème
  void _toggleTheme(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  // Fonction pour changer la langue de l'application
  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IPSAS Quiz',
      themeMode: _themeMode, // Permet de basculer dynamiquement entre les thèmes
      theme: ThemeData(
        primarySwatch: Colors.pink,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        fontFamily: "Montserrat",
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          textTheme: ButtonTextTheme.primary,
        ),
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
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      supportedLocales: [
        Locale('en', ''), // Anglais
        Locale('fr', ''), // Français
        Locale('ar', ''), // Arabe
      ],
      locale: _locale, // Utiliser la locale définie par l'utilisateur
      localizationsDelegates: [
        S.delegate, // Le délégué de localisation généré
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: HomePage(
        onThemeChanged: _toggleTheme,
        onLanguageChanged: _changeLanguage, // Passer la fonction pour changer la langue
        notificationService: widget.notificationService, // Passer le service de notification
      ),
    );
  }
}
