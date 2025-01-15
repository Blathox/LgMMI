
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
    final user = await supabase.from('USERS').select().eq('id_user', idUser);
    print(user);
    if(user.isEmpty){
      print('empty');
      final response = await supabase.from('USERS').insert({'username': supabase.auth.currentUser?.userMetadata?['username']??""});
      print("réponse : $response");
    }
    final List<dynamic> idList = await supabase.from('USERS').select('id').eq('id_user', idUser);
    var id = idList[0];
    id= id['id'];
 
   final stats = await supabase.from('STATISTICS').select().eq('id_user',id);
   print("stats: $stats");
    if(stats.isEmpty){
      print("test");
       await supabase.from('STATISTICS').insert({
      'games_played': 0,
      'victories_as_villager': 0,
      'victories_as_werewolf': 0,
      'last_game_at': null,
      'id_user': id
    });
    }
     
  }
  
  
    return true;
  } else {
    print('No sign in');
    return false;
  }
}