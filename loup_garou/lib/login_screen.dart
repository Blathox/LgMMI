import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';
import 'package:loup_garou/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Color bgField = const Color(0xFFE7E7E7);
  final Color bgContainer = const Color.fromARGB(60, 136, 136, 136);
  final Color yellow = const Color.fromARGB(255, 255, 200, 20);
  bool? isChecked = false;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.bodyMedium!;
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
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
              Row(children: [
                Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value;
                      });
                    }),
                const Text(
                  'Se souvenir de moi',
                  style: TextStyle(fontSize: 11),
                ),
                const Spacer(),
                TextButton(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                    minimumSize: WidgetStateProperty.all(Size.zero),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: const Text(
                    "Mot de passe oublié ?",
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 11),
                  ),
                ),
              ]),
              // Bouton de connexion avec largeur adaptative
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(yellow),
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
              // Bouton pour se connecter avec Google
              const Text("Ou essayez de vous connecter avec",
                  style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 11, color: Colors.grey,),),
              //Logos
                            const SizedBox(height: 8),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [   SizedBox(
                child: IconButton(
                  icon: 
                    Image.asset('assets/images/logo/logo_google.png',
                    width: 30,
                  ),
                  tooltip: 'Connectez vous avec google',
                
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.white),
  
                  ),
                  onPressed: () {
                    // Action de connexion avec Google
                    // ignore: avoid_print
                    print('Connexion avec Google');
                  },
                ),
              ),
              const SizedBox(width: 20,),
              IconButton(
                 icon: 
                    Image.asset('assets/images/logo/logo_apple.png',
                    width: 30,
                    height: 30,
                  ),
                  tooltip: 'Connectez vous avec apple',
                  
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.white),
  
                  ),
                  onPressed: () {
                    // Action de connexion avec Apple
                    // ignore: avoid_print
                    print('Connexion avec Apple');
                  },
              ),],),
           

              // Bouton pour s'inscrire
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Pas encore inscrit ?",
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 11),
                    ),
                    const SizedBox(
                        width: 4), // Add this line to create a small space
                    Text(
                      "Inscrivez vous ici",
                      style: TextStyle(
                          fontFamily: 'Poppins', fontSize: 11, color: yellow),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
