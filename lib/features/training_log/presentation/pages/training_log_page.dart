import 'package:flutter/material.dart';

class TrainingLogPage extends StatelessWidget {
  const TrainingLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Training Log'), // TODO: add translation
          centerTitle: true,
        ),
        body: const Align(
          alignment: Alignment.topCenter,
          child : Column(
            children: [
              Text('No training blocks yet'), // TODO: add translation
              Text('Tap the button down below to start one') // TODO: add translation
            ]
          )
        )
      )
    );
  }
}