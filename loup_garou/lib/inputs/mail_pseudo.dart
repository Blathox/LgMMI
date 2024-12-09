import 'package:flutter/material.dart';

class MailPseudo extends StatelessWidget{
final TextEditingController emailController;
  final TextEditingController usernameController;

  const MailPseudo({super.key, 
    required this.emailController,
    required this.usernameController,
  });
  static const Color bgField = Color(0xFFE7E7E7);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              fillColor: bgField,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              labelText: "Nom d'utilisateur",
              fillColor: bgField,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}