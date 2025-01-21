import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  // Initialisation de Supabase
  await Supabase.initialize(
    url: 'https://vaobaeoqugklzdrdyofh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhb2JhZW9xdWdrbHpkcmR5b2ZoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzIxNzkyMjcsImV4cCI6MjA0Nzc1NTIyN30.4dQFEk546toyop4OlHPlM-vpiuuUa8HZTTzg-JkEdKs',
  );

  final supabase = Supabase.instance.client;

  // Tester la récupération des joueurs tués
  try {
    final response = await supabase
        .from('PLAYERS')
        .select('name, role')
        .eq('killedatnight', true);

    if (response.isEmpty) {
      print("Aucun joueur n'a été tué cette nuit.");
    } else {
      print("Joueurs tués cette nuit :");
      for (var player in response) {
        print("Nom : ${player['name']}, Rôle : ${player['role']}");
      }
    }
  } catch (error) {
    print("Erreur lors de la récupération des joueurs : $error");
  }
}
