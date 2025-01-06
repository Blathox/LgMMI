import 'package:flutter/material.dart';

class GameSettingsScreen extends StatelessWidget{

const GameSettingsScreen({super.key});
@override
  Widget build (BuildContext context){
  return Scaffold(
    appBar: AppBar(
      title: const Text('Paramètres de la partie'),
    ),
    body: const Center(
      child: Column(
        children: [
          SizedBox(height: 20),
          Text(
            'Choisissez les rôles de la partie',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          // Liste des rôles
          
        ])));}
}