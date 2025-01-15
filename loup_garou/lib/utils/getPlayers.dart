
// ignore_for_file: await_only_futures

import 'package:flutter/material.dart';
import 'package:loup_garou/game_logic/player.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

 Future <void> getPlayers( BuildContext context, code, playerManager) async {
 final supabase = Supabase.instance.client;

 var response = await supabase.from("GAMES").select('users').eq('game_code', code).single();  
  List<dynamic> listUsers = response['users'];  
    print(response);

    for (String player in listUsers) {
          var userResponse = await supabase.from('USERS').select().eq('id', player).single();
          print(userResponse);
          var user = userResponse;
          String username = user['username'] as String;
          playerManager.addPlayer(Player(username,false));     
    }

}