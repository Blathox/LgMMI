
  import 'package:flutter/material.dart';

  class WaitingScreen extends StatelessWidget {

    const WaitingScreen({super.key});
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Waiting for Players'),
        ),
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Waiting for all players to join...',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: players.length,
            //     itemBuilder: (context, index) {
            //       return ListTile(
            //         title: Text(players[index]),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      );
    }
  }
