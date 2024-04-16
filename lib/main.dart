import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'models/languages.dart';
import 'screens/notescreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('en', ''); // Default locale is English

  void _changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      locale: _locale, // Pass the selected locale here
      localizationsDelegates: [
        // Add your app's localization delegate
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English
        const Locale('es', ''), // Spanish
        const Locale('fr', ''), // French
        // Add more locales as needed
      ],
      home: NotesScreen(
        changeLocale: _changeLocale, // Pass the method to change locale
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'My App',
//       debugShowCheckedModeBanner: false,
//       localizationsDelegates: [
//         // Add your app's localization delegate
//         AppLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//       ],
//       supportedLocales: [
//         const Locale('en', ''), // English
//         const Locale('es', ''), // Spanish
//         const Locale('fr', ''), // French

//         // Add more locales as needed
//       ],
//       home: NotesScreen(),
//     );
//   }
// }