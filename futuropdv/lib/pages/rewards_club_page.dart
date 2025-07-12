import 'package:flutter/material.dart';

class RewardsClubPage extends StatelessWidget {
  const RewardsClubPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clube de Vantagens'),
      ),
      body: Center(
        child: Text(
          'Página do Clube de Vantagens',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
} 