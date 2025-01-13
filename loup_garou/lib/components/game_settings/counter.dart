import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  final String valueCounter;
  final Function addCounter;
  final Function removeCount;

  const Counter({super.key, required this.valueCounter, required this.addCounter, required this.removeCount});
  
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
          widget.removeCount();
          },
        ),
        Text(
          widget.valueCounter,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          
          onPressed: () {
            widget.addCounter();
          },
        ),
      ],
    );
  }
}