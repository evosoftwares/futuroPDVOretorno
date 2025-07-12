import 'package:flutter/material.dart';

class ActiveRidesPage extends StatelessWidget {
  const ActiveRidesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Corridas Ativas'),
      ),
      body: Center(
        child: Text(
          'Página de Corridas Ativas',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
} 