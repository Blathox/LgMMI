import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final Color bgField = const Color(0xFFE7E7E7);
  final Color bgContainer = const Color.fromARGB(60, 136, 136, 136);
  final Color yellow = const Color.fromARGB(255, 255, 200, 20);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    int _indexStepper = 0;
    TextStyle h1 = Theme.of(context).textTheme.titleLarge!;
    TextStyle h2 = Theme.of(context).textTheme.titleMedium!;
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: 
        Container(
          height: 500,
          child:
         Column(
          
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Inscription',
                      style: h1,
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Vos informations personnelles',
                      style: h2,
                      textAlign: TextAlign.left,
                    ),
                    Stepper(
                      
                      onStepCancel: () {
                        if (_indexStepper > 0) {
                          setState(() {
                            _indexStepper -= 1;
                          });
                        }
                      },
                      onStepTapped: (int index) {
                        setState(() {
                          _indexStepper = index;
                        });
                      },
                      type: StepperType.horizontal,
                      currentStep: _indexStepper,
                      steps: [
                        Step(
                          
                          title: Text(

                            'Vos informations personnelles',
                            style: h2,
                            textAlign: TextAlign.left,
                          ),
                          content: _indexStepper == 0
                              ? 
                              Container(
                                child: Column(

                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        labelText: 'Email',
                                        fillColor: bgField,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
                                      controller: usernameController,
                                      decoration: InputDecoration(
                                        labelText: "Nom d'utilisateur",
                                        fillColor: bgField,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                             )
                               : Container(),
                        ),
                        Step(
                          title: const Text("Votre mot de passe"),
                          content: _indexStepper == 1
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: passwordController,
                                      decoration: InputDecoration(
                                        labelText: 'Mot de passe',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      obscureText: true,
                                    ),
                                    TextField(
                                      controller: confirmPasswordController,
                                      decoration: InputDecoration(
                                        labelText: 'Confirmer le mot de passe',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      obscureText: true,
                                    ),
                                  ],
                                )
                              : Container(),
                        ),
                      ],
                    ),
                  
                
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Use a logging framework instead of print
                  debugPrint('Inscription avec : ${emailController.text}');
                },
                child: const Text("S'inscrire"),
              ),
                  ]
          )),
        ),
      );
    
  }
}
