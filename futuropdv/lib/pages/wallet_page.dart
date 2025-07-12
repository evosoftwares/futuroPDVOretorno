import 'package:flutter/material.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carteira Digital'),
      ),
      body: Center(
        child: Text(
          'Página da Carteira Digital',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
} 