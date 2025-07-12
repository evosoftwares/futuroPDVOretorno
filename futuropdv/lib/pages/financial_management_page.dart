import 'package:flutter/material.dart';

class FinancialManagementPage extends StatelessWidget {
  const FinancialManagementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão Financeira'),
      ),
      body: Center(
        child: Text(
          'Página de Gestão Financeira',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
} 