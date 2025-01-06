import 'package:flutter/material.dart';
import 'package:loup_garou/game_logic/roles.dart';

class GameSettingsScreen extends StatelessWidget{

const GameSettingsScreen({super.key});
@override
//liste des rôles
  Widget build (BuildContext context){
  return Scaffold(
    appBar: AppBar(
      title: const Text('Paramètres de la partie'),
    ),
    body: Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Choisissez les rôles de la partie',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          // Liste des rôles
          ListView(
            children: const [

            ],
          )
        ])));}
}