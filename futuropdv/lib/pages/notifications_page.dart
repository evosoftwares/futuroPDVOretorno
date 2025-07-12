import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Central de Notificações'),
      ),
      body: Center(
        child: Text(
          'Página da Central de Notificações',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
} 