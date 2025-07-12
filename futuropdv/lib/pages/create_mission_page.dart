import 'package:flutter/material.dart';

class CreateMissionPage extends StatelessWidget {
  const CreateMissionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Missão'),
      ),
      body: Center(
        child: Text(
          'Página de Criação de Missão',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
} 