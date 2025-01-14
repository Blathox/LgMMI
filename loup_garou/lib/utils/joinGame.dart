import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> joinGame(
    BuildContext context, String code) async {
  // Add your function code here!
  // Get a reference your Supabase client
  final supabase = Supabase.instance.client;
  final sm = ScaffoldMessenger.of(context);
   final authResponse = await supabase.from('GAMES').select().eq('game_code', code);

  sm.showSnackBar(
      SnackBar(content: Text("Partie rejointe avec le code $code")));
}
