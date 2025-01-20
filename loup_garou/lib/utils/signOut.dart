import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> signOut() async {
  try {
    await Supabase.instance.client.auth.signOut();
  } catch (e) {
    print('Erreur lors de la déconnexion : $e');
  }
}

