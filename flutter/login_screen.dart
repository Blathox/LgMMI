import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loup_garou/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Color bgField = const Color(0xFFE7E7E7);
  final Color bgContainer = const Color.fromARGB(60, 136, 136, 136);
  final Color yellow = const Color.fromARGB(255, 255, 200, 20);
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.bodyMedium!;
    bool isChecked = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
              color: bgContainer, borderRadius: BorderRadius.circular(50)),
          margin:
              const EdgeInsets.all(20.0), // Marge autour du Container entier
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Champ email avec largeur adaptative
              Container(
                width: double.infinity,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    fillColor: bgField,
                    filled: true,
                    labelStyle: textStyle,
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Champ mot de passe avec largeur adaptative
              Container(
                width: double.infinity,
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    fillColor: bgField,
                    filled: true,
                    labelStyle: textStyle,
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 24),
              Row(children: [
                Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.blue,
                    value: isChecked,
                    onChanged: (bool? value) {
                      isChecked = value!;
                    }),
                Text('Se souvenir de moi')
              ]),
              // Bouton de connexion avec largeur adaptative
              Container(
                width: double.infinity,
                child: FilledButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(yellow),
                  ),
                  onPressed: () {
                    // Action de connexion
                    // ignore: avoid_print
                    print('Connexion avec : ${emailController.text}');
                  },
                  child: const Text(
                    'Connexion',
                    style:
                        TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Bouton pour s'inscrire
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
                child: const Text("Pas de compte ? S'inscrire"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
