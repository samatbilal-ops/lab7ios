import 'package:flutter/material.dart';

import 'screens/registration_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SoleStore',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepOrange),
      // Flow: Registration (Lab 6) -> Root with tabs (Lab 7) -> Detail (Lab 5)
      home: const RegistrationScreen(),
    );
  }
}
