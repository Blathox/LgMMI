import 'dart:ui_web';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../game_logic/player.dart';

Future<List<Player>> getPlayers( BuildContext context, code) async {
 final supabase = Supabase.instance.client;
  final sm = ScaffoldMessenger.of(context);
    var response = await supabase.from('GAMES').select('users').eq('game_code', code).single();
    // ignore: unused_local_variable
    for (String player in (response['users'] as List<dynamic>)){
          var user= await supabase.from('USERS').select().eq('id', )
    }

return response
}