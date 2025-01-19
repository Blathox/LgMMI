import 'package:flutter/material.dart';

class GameScreen  extends StatefulWidget{
  const GameScreen({super.key});

  @override 
  State<GameScreen> createState() => _GameScreenState();

}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Screen'),
      ),
      body: const Center(
        child: Text('Welcome to the Game Screen!'),
      ),
    );
  }
} 
