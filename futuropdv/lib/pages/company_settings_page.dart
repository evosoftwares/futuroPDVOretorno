import 'package:flutter/material.dart';

class CompanySettingsPage extends StatelessWidget {
  const CompanySettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações da Empresa'),
      ),
      body: Center(
        child: Text(
          'Página de Configurações da Empresa',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
} 