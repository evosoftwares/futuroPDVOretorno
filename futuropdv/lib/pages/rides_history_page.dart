import 'package:flutter/material.dart';

class RidesHistoryPage extends StatelessWidget {
  const RidesHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Corridas'),
      ),
      body: Center(
        child: Text(
          'Página de Histórico de Corridas',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
} 