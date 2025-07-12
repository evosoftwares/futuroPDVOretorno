import 'package:flutter/material.dart';

class PartnersManagementPage extends StatelessWidget {
  const PartnersManagementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Parceiros'),
      ),
      body: Center(
        child: Text(
          'Página de Gestão de Parceiros',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
} 