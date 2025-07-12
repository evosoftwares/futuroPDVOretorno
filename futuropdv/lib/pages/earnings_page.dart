import 'package:flutter/material.dart';

class EarningsPage extends StatelessWidget {
  const EarningsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ganhos'),
      ),
      body: Center(
        child: Text(
          'Página de Ganhos',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
} 