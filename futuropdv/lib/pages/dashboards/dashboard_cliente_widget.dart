import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:futuropdv/pages/request_ride_page.dart';
import 'package:futuropdv/pages/rewards_club_page.dart';
import 'package:futuropdv/pages/rides_history_page.dart';
import 'package:futuropdv/pages/wallet_page.dart';

class DashboardClienteWidget extends StatelessWidget {
  const DashboardClienteWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Cliente'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bem-vindo, ${user?.email}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text('Perfil: Cliente'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildMenuCard(
                  context,
                  icon: Icons.directions_car,
                  title: 'Solicitar Corrida',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RequestRidePage()),
                    );
                  },
                ),
                _buildMenuCard(
                  context,
                  icon: Icons.history,
                  title: 'Histórico',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RidesHistoryPage()),
                    );
                  },
                ),
                _buildMenuCard(
                  context,
                  icon: Icons.account_balance_wallet,
                  title: 'Carteira Digital',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WalletPage()),
                    );
                  },
                ),
                _buildMenuCard(
                  context,
                  icon: Icons.card_giftcard,
                  title: 'Clube de Vantagens',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RewardsClubPage()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 