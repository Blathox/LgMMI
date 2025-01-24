import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<Map<String, dynamic>>> fetchRoles() async {
  final response = await Supabase.instance.client
    .from('ROLES') 
    .select('name, description');

  if (response.isEmpty) {
    throw Exception('La liste des rôles est vide.');
  }
  return (response as List).cast<Map<String, dynamic>>();
  
}