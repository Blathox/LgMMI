// Automatic FlutterFlow imports
import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> checkAuth() async {
  // Add your function code here!
  // Get a reference your Supabase client
  final supabase = Supabase.instance.client;

  final Session? session = supabase.auth.currentSession;

  if (session != null) {
    print('Signed In!');

  if(supabase.auth.currentUser?.id!=null ){
    final idUser = supabase.auth.currentUser?.id??'';
    print(idUser);
   final stats = await supabase.from('STATISTICS').select().eq('id_user',idUser);
  print(stats);
    if(stats.isEmpty){
       await supabase.from('STATISTICS').insert({
      'games_played': 0,
      'victories_as_villager': 0,
      'victories_as_werewolf': 0,
      'last_game_at': null,
      'id_user': supabase.auth.currentUser?.id
    });
    }
     
  }
  
  
    return true;
  } else {
    print('No sign in');
    return false;
  }
}