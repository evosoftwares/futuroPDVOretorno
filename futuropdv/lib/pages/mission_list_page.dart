import 'package:flutter/material.dart';

class MissionListPage extends StatelessWidget {
  const MissionListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todas as Missões'),
      ),
      body: Center(
        child: Text(
          'Página de Lista de Missões',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
} 