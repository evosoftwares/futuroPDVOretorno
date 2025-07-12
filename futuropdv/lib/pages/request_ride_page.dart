import 'package:flutter/material.dart';

class RequestRidePage extends StatelessWidget {
  const RequestRidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitar Corrida'),
      ),
      body: Center(
        child: Text(
          'Página de Solicitação de Corrida',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
} 