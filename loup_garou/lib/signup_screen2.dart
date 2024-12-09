import 'package:flutter/material.dart';
import 'package:loup_garou/inputs/mail_pseudo.dart';
import 'package:loup_garou/inputs/password.dart';
import 'package:loup_garou/stepper/signin_stepper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State createState() => _SignUpScreenState();
}
int indexStepper = 0;

class _SignUpScreenState extends State<SignUpScreen> {
  static const Color bgField = Color(0xFFE7E7E7);
  final Color bgContainer = const Color.fromARGB(60, 136, 136, 136);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  static const Color yellow = Color.fromARGB(255, 255, 200, 20);
  final supabase = Supabase.instance.client;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    //int indexStepper = 0;
    TextStyle h1 = Theme.of(context).textTheme.titleLarge!;
    TextStyle h2 = Theme.of(context).textTheme.titleMedium!;
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
      ),
      body: SizedBox(
          height: 500,
          width: 500,
          child: Column(children: [
            Text(
              'Inscription',
              style: h1,
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 16),
            indexStepper == 0
                ? Text(
                    'Vos informations personnelles',
                    style: h2,
                    textAlign: TextAlign.left,
                  )
                : Text(
                    'Votre mot de passe',
                    style: h2,
                    textAlign: TextAlign.left,
                  ),
            SigninStepper(indexStepper: indexStepper),
            indexStepper == 0 ? MailPseudo(
              emailController:emailController,
              usernameController:usernameController)
             : Password(passwordController: passwordController,confirmPasswordController: confirmPasswordController),
            const SizedBox(height: 24),
            if (indexStepper == 0)
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(yellow),
                  ),
                  onPressed: () {
                    setState(() => indexStepper += 1);
                    print(indexStepper);
                  },
                  child: const Text(
                    "Passez à l'étape suivante",
                    style:
                        TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                  ),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(yellow),
                  ),
                  onPressed: () async {
                    final sm = ScaffoldMessenger.of(context);
                    final authResponse = await supabase.auth.signUp(
                        password: passwordController.text,
                         email: emailController.text,
                         data:{
                            'username': usernameController.text
                         });
                     sm.showSnackBar(SnackBar(
                          content: 
                              Text("Logged in: ${authResponse.user?.email}")));
                              
                  },

                  child: const Text(
                    "S'inscrire",
                    style:
                        TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                  ),
                ),
              )
          ])),
    );
  }
}
