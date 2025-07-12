import 'package:flutter/material.dart';

class MissionDetailsPage extends StatelessWidget {
  final String missionId;

  const MissionDetailsPage({Key? key, required this.missionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Missão'),
      ),
      body: Center(
        child: Text(
          'Detalhes da Missão: $missionId',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
} 