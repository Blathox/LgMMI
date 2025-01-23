import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:loup_garou/pages/login_screen.dart';

Future<void> signOut(BuildContext context) async {
  try {
    // Effectuer la déconnexion avec Supabase
    await Supabase.instance.client.auth.signOut();

    
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  } catch (e) {
    print('Erreur lors de la déconnexion : $e');
  }
}

