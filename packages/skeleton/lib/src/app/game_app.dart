import 'package:flutter/material.dart';

import 'status_screen.dart';

class GameApp extends StatelessWidget {
  const GameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multiplayer Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const Scaffold(
        backgroundColor: Color(0xFF07070F),
        // Swap this for a GameWidget with your game.
        body: StatusScreen(),
      ),
    );
  }
}
