import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> createUser(
    BuildContext context, String email, String password, String pseudo) async {
  // Add your function code here!
  // Get a reference your Supabase client
  final supabase = Supabase.instance.client;
  final sm = ScaffoldMessenger.of(context);

  final authResponse = await supabase.auth
      .signUp(password: password, email: email, data: {'username': pseudo});


  sm.showSnackBar(
      SnackBar(content: Text("Logged in: ${authResponse.user?.email}")));
  
}
