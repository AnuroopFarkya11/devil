import 'package:devil/src/screens/authentication/authentication_screen.dart';
import 'package:devil/src/shared/strings.dart';
import 'package:devil/src/shared/themes.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: themeLight,
      home: const AuthenticationScreen(),
    );
  }
}
