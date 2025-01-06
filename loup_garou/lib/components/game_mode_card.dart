import 'package:flutter/material.dart';
import 'package:loup_garou/visuals/colors.dart';

class GameModeCard extends StatelessWidget{
  final String title; 
  final IconData icon;
  final String image1;
  final String? image2; // Image facultative

  const GameModeCard({
    required this.title,
    required this.icon,
    required this.image1,
    this.image2,
  })
  

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color:  yellow,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(
                  icon, 
                  size: 30
                ),
              ]
            ),
            const SizedBox(height: 10),
            Column (children: [
              Expanded(
                child:Image.asset(
                  image1,
                  fit: BoxFit.cover,
                  height: 100,
                ),
                
              ),
              if (image2 != null)
              Expanded(
                child: Image.asset(
                  image2!,
                  fit: BoxFit.cover,
                  height: 100,
                ),
              ),
             ],
             ),
          ]
        ),
      ),
    );
    
  }
}