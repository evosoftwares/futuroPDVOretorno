import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios'),
      ),
      body: Center(
        child: Text(
          'Página de Relatórios',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
} 