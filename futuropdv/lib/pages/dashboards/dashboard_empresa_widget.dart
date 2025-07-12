import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:futuropdv/pages/company_missions_page.dart';
import 'package:futuropdv/pages/company_settings_page.dart';
import 'package:futuropdv/pages/create_mission_page.dart';
import 'package:futuropdv/pages/financial_management_page.dart';
import 'package:futuropdv/pages/partners_management_page.dart';
import 'package:futuropdv/pages/reports_page.dart';

class DashboardEmpresaWidget extends StatelessWidget {
  const DashboardEmpresaWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Empresa'),
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
                    const Text('Perfil: Empresa'),
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
                  icon: Icons.assignment_add,
                  title: 'Criar Missão',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CreateMissionPage()),
                    );
                  },
                ),
                _buildMenuCard(
                  context,
                  icon: Icons.assignment,
                  title: 'Minhas Missões',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CompanyMissionsPage()),
                    );
                  },
                ),
                _buildMenuCard(
                  context,
                  icon: Icons.people,
                  title: 'Parceiros',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PartnersManagementPage()),
                    );
                  },
                ),
                _buildMenuCard(
                  context,
                  icon: Icons.analytics,
                  title: 'Relatórios',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ReportsPage()),
                    );
                  },
                ),
                _buildMenuCard(
                  context,
                  icon: Icons.account_balance_wallet,
                  title: 'Financeiro',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FinancialManagementPage()),
                    );
                  },
                ),
                _buildMenuCard(
                  context,
                  icon: Icons.settings,
                  title: 'Configurações',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CompanySettingsPage()),
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