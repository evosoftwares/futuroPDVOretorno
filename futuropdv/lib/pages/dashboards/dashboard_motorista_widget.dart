import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:futuropdv/backend/providers/dashboard_motorista_provider.dart';
import 'package:futuropdv/pages/dashboards/widgets/dashboard_motorista_skeleton.dart';
import 'package:futuropdv/pages/dashboards/widgets/mission_feed_widget.dart';
import 'package:futuropdv/pages/active_rides_page.dart';
import 'package:futuropdv/pages/earnings_page.dart';
import 'package:futuropdv/pages/mission_list_page.dart';
import 'package:futuropdv/pages/rides_history_page.dart';

class DashboardMotoristaWidget extends StatelessWidget {
  const DashboardMotoristaWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Idealmente, o wrapper de autenticação já deve lidar com isso.
      return const Scaffold(body: Center(child: Text("Usuário não logado.")));
    }

    return ChangeNotifierProvider(
      create: (_) => DashboardMotoristaProvider(user.uid),
      child: Consumer<DashboardMotoristaProvider>(
        builder: (context, provider, child) {
          // Usamos addPostFrameCallback para mostrar o SnackBar após o build.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (provider.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(provider.errorMessage!),
                  backgroundColor: Colors.red,
                ),
              );
              // Limpa a mensagem de erro para não mostrar novamente.
              provider.clearErrorMessage();
            }
          });

          return Scaffold(
            appBar: AppBar(
              title: const Text('Dashboard Motorista'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                ),
              ],
            ),
            body: provider.isLoading
                ? const DashboardMotoristaSkeleton()
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWelcomeCard(context, user),
                        const SizedBox(height: 16),
                        _buildStatusToggle(context, provider),
                        const SizedBox(height: 16),
                        _buildLocationStatusCard(context, provider),
                        const SizedBox(height: 16),
                        _buildSummarySection(context, provider),
                        const SizedBox(height: 24),
                        // O conteúdo principal agora é o feed ou um aviso.
                        Expanded(
                          child: provider.isAvailable
                              ? const MissionFeedWidget()
                              : _buildGoOnlineMessage(),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildLocationStatusCard(BuildContext context, DashboardMotoristaProvider provider) {
    // É importante passar o userId para o método fetchAllData.
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (provider.locationError != null) {
      return Card(
        color: Colors.amber.shade100,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 32),
              const SizedBox(height: 8),
              Text(
                'Não foi possível obter a localização',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(provider.locationError!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar Novamente'),
                onPressed: () {
                  if (userId != null) {
                    provider.fetchAllData(userId);
                  }
                },
              ),
            ],
          ),
        ),
      );
    }

    if (provider.currentPosition != null) {
      return Card(
        color: Colors.green.shade50,
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, color: Colors.green, size: 24),
              SizedBox(width: 8),
              Text('Localização GPS ativa', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      );
    }

    // Se ainda não houver nem posição nem erro (carregando), não mostra nada.
    return const SizedBox.shrink();
  }

  Widget _buildWelcomeCard(BuildContext context, User? user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bem-vindo, ${user?.displayName ?? user?.email}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('Perfil: Motorista'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusToggle(BuildContext context, DashboardMotoristaProvider provider) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return Card(
      child: SwitchListTile(
        title: Text(
          provider.isAvailable ? 'Disponível para corridas' : 'Indisponível',
          style: TextStyle(
            color: provider.isAvailable ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        value: provider.isAvailable,
        onChanged: (value) {
          if (userId != null) {
            provider.toggleAvailability(userId);
          }
        },
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context, DashboardMotoristaProvider provider) {
    final summary = provider.dailySummary;
    if (summary == null) {
      return const SizedBox.shrink(); // Ou um widget de loading/erro
    }

    if (summary.completedMissions == 0) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Icon(Icons.sunny, size: 40, color: Colors.orange),
              const SizedBox(height: 16),
              Text('Um novo dia começa!', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              const Text(
                'Fique disponível para receber sua primeira corrida e bons ganhos!',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumo de Hoje', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('Ganhos', 'R\$ ${summary.earnings.toStringAsFixed(2)}'),
                _buildSummaryItem('Corridas', summary.completedMissions.toString()),
                _buildSummaryItem('Avaliação', summary.averageRating.toStringAsFixed(1)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(title),
      ],
    );
  }

  Widget _buildGoOnlineMessage() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.power_settings_new_rounded, size: 60, color: Colors.blue),
            SizedBox(height: 16),
            Text(
              'Fique online para ver as corridas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Altere seu status para "Disponível" para começar a receber oportunidades.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainMenu(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildMenuCard(
          context,
          icon: Icons.directions_car,
          title: 'Corridas Disponíveis',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MissionListPage()),
            );
          },
        ),
        _buildMenuCard(
          context,
          icon: Icons.assignment,
          title: 'Minhas Corridas',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ActiveRidesPage()),
            );
          },
        ),
        _buildMenuCard(
          context,
          icon: Icons.account_balance_wallet,
          title: 'Ganhos',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EarningsPage()),
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
      ],
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
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