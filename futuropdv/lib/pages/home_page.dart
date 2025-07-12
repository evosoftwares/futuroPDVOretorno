import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:futuropdv/pages/dashboards/dashboard_cliente_widget.dart';
import 'package:futuropdv/pages/dashboards/dashboard_motorista_widget.dart';
import 'package:futuropdv/pages/dashboards/dashboard_parceiro_widget.dart';
import 'package:futuropdv/pages/dashboards/dashboard_empresa_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    if (user == null) {
      // Não deveria acontecer, mas por segurança
      return const Scaffold(
        body: Center(
          child: Text('Usuário não autenticado'),
        ),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(
              child: Text('Dados do usuário não encontrados'),
            ),
          );
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final userRoles = List<String>.from(userData['userRoles'] ?? []);

        // Se o usuário tem múltiplos perfis, mostrar seletor
        if (userRoles.length > 1) {
          return _MultiRoleSelector(userRoles: userRoles);
        }

        // Se tem apenas um perfil, redirecionar direto
        if (userRoles.isNotEmpty) {
          return _getDashboardByRole(userRoles.first);
        }

        return const Scaffold(
          body: Center(
            child: Text('Nenhum perfil encontrado'),
          ),
        );
      },
    );
  }

  Widget _getDashboardByRole(String role) {
    switch (role) {
      case 'cliente':
        return const DashboardClienteWidget();
      case 'motorista':
        return const DashboardMotoristaWidget();
      case 'parceiro':
        return const DashboardParceiroWidget();
      case 'empresa':
        return const DashboardEmpresaWidget();
      default:
        return Scaffold(
          body: Center(
            child: Text('Perfil desconhecido: $role'),
          ),
        );
    }
  }
}

class _MultiRoleSelector extends StatelessWidget {
  final List<String> userRoles;

  const _MultiRoleSelector({required this.userRoles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione o Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Você tem múltiplos perfis',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Selecione como deseja acessar o sistema:',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ...userRoles.map((role) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => _getDashboardByRole(role),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_getIconByRole(role)),
                    const SizedBox(width: 8),
                    Text(
                      'Acessar como ${_getRoleLabel(role)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _getDashboardByRole(String role) {
    switch (role) {
      case 'cliente':
        return const DashboardClienteWidget();
      case 'motorista':
        return const DashboardMotoristaWidget();
      case 'parceiro':
        return const DashboardParceiroWidget();
      case 'empresa':
        return const DashboardEmpresaWidget();
      default:
        return Scaffold(
          body: Center(
            child: Text('Perfil desconhecido: $role'),
          ),
        );
    }
  }

  IconData _getIconByRole(String role) {
    switch (role) {
      case 'cliente':
        return Icons.person;
      case 'motorista':
        return Icons.directions_car;
      case 'parceiro':
        return Icons.handshake;
      case 'empresa':
        return Icons.business;
      default:
        return Icons.help;
    }
  }

  String _getRoleLabel(String role) {
    switch (role) {
      case 'cliente':
        return 'Cliente';
      case 'motorista':
        return 'Motorista';
      case 'parceiro':
        return 'Parceiro';
      case 'empresa':
        return 'Empresa';
      default:
        return role;
    }
  }
} 