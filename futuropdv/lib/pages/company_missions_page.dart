import 'package:flutter/material.dart';

class CompanyMissionsPage extends StatelessWidget {
  const CompanyMissionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Missões da Empresa'),
      ),
      body: Center(
        child: Text(
          'Página de Missões da Empresa',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
} 