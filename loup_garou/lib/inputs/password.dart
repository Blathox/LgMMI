import 'package:flutter/material.dart';

class Password extends StatelessWidget {
  final TextEditingController passwordController; 
  final TextEditingController confirmPasswordController;

  const Password({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
  });
    static const Color bgField = Color(0xFFE7E7E7);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: 'Mot de passe',
            fillColor: bgField,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          obscureText: true,
        ),
        TextField(
          controller: confirmPasswordController,
          decoration: InputDecoration(
            labelText: 'Confirmer le mot de passe',
            fillColor: bgField,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          obscureText: true,
        ),
      ],
    );
  }
}