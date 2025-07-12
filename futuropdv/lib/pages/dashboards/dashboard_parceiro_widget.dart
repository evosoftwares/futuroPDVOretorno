import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../backend/services/dashboard_service.dart';
import '../../models/mission_model.dart';
import '../../models/partner_profile_model.dart';
import '../../models/wallet_model.dart';
import '../mission_details_page.dart';
import '../mission_list_page.dart';
import '../notifications_page.dart';

class DashboardParceiroWidget extends StatefulWidget {
  const DashboardParceiroWidget({Key? key}) : super(key: key);

  @override
  _DashboardParceiroWidgetState createState() => _DashboardParceiroWidgetState();
}

class _DashboardParceiroWidgetState extends State<DashboardParceiroWidget> {
  final user = FirebaseAuth.instance.currentUser;
  final DashboardService _dashboardService = DashboardService();
  late Future<DailySummary> _dailySummaryFuture;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      _dailySummaryFuture = _dashboardService.getDailySummary(user!.uid);
    }
  }

  Future<void> _updatePartnerStatus(bool isAvailable) async {
    if (user == null) return;
    try {
      final newStatus = isAvailable ? PartnerStatus.available : PartnerStatus.in_mission;
      await FirebaseFirestore.instance
          .collection('partnerProfiles')
          .doc(user!.uid)
          .set({'status': newStatus.name}, SetOptions(merge: true));
    } catch (e) {
      // Tratar erro, talvez com uma SnackBar
      print("Erro ao atualizar status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard do Parceiro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // A navegação será tratada pelo AuthWrapper
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderStream(), // Trocado para o StreamBuilder
            const SizedBox(height: 24),
            _buildWalletStream(), // Trocado para o StreamBuilder
            const SizedBox(height: 24),
            _buildDailySummary(),
            const SizedBox(height: 24),
            _buildOpportunitiesFeed(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStream() {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('partnerProfiles').doc(user?.uid).snapshots(),
      builder: (context, snapshot) {
        PartnerStatus status = PartnerStatus.offline;
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data();
          status = PartnerProfile.parseStatus(data?['status']);
        }
        
        // O widget do header agora é construído com base no status do stream
        return _buildHeader(status);
      },
    );
  }

  Widget _buildHeader(PartnerStatus status) {
    bool isAvailable = status == PartnerStatus.available;

    String statusText;
    Color statusColor;

    switch (status) {
      case PartnerStatus.available:
        statusText = 'Você está disponível';
        statusColor = Colors.green;
        break;
      case PartnerStatus.in_mission:
        statusText = 'Você está em missão';
        statusColor = Colors.orange;
        break;
      case PartnerStatus.offline:
      default:
        statusText = 'Status indisponível';
        statusColor = Colors.grey;
        break;
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá, ${user?.displayName ?? user?.email}!',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Switch(
              value: isAvailable,
              onChanged: (value) {
                // Ao mudar o switch, chama a função para atualizar o Firestore
                _updatePartnerStatus(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletStream() {
    // Usando um StreamBuilder para ouvir as atualizações da carteira em tempo real
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('wallet')
          .doc('main') // Assumindo que a carteira principal tem um ID fixo "main"
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _buildWalletCard(wallet: null, error: 'Erro ao carregar saldo');
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          // Se não houver dados, exibe um saldo padrão ou de boas-vindas
          return _buildWalletCard(wallet: Wallet(balance: 0, currency: 'BRL', lastTransactionAt: Timestamp.now()));
        }

        final wallet = Wallet.fromJson(snapshot.data!.data()!);
        return _buildWalletCard(wallet: wallet);
      },
    );
  }

  Widget _buildWalletCard({Wallet? wallet, String? error}) {
    final balance = wallet?.balance.toStringAsFixed(2).replaceAll('.', ',') ?? '---';
    final currency = wallet?.currency ?? 'BRL';
    
    return Card(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Saldo em Carteira',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 8),
                if (error != null)
                  Text(
                    error,
                    style: TextStyle(
                      color: Colors.red[200],
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                else
                  Text(
                    '$currency $balance',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            Icon(Icons.account_balance_wallet, color: Colors.white, size: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDailySummary() {
    return FutureBuilder<DailySummary>(
      future: _dailySummaryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text('Não foi possível carregar o resumo.'));
        }

        final summary = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumo do Dia',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryCard(
                  icon: Icons.monetization_on,
                  title: 'Ganhos',
                  value: 'R\$ ${summary.earnings.toStringAsFixed(2)}',
                  color: Colors.green,
                ),
                _buildSummaryCard(
                  icon: Icons.check_circle,
                  title: 'Missões',
                  value: summary.completedMissions.toString(),
                  color: Colors.blue,
                ),
                _buildSummaryCard(
                  icon: Icons.star,
                  title: 'Avaliação',
                  value: summary.averageRating.toStringAsFixed(1),
                  color: Colors.amber,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(title, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 4),
              Text(value, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOpportunitiesFeed() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Novas Oportunidades',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('missions')
              .where('status', isEqualTo: 'available')
              .orderBy('createdAt', descending: true)
              .limit(3)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('Nenhuma oportunidade disponível no momento.'),
              );
            }

            final missions = snapshot.data!.docs
                .map((doc) => Mission.fromFirestore(doc))
                .toList();

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: missions.length,
              itemBuilder: (context, index) {
                final mission = missions[index];
                return _buildOpportunityCard(mission: mission);
              },
            );
          },
        ),
        const SizedBox(height: 8),
        if (true) // Lógica para mostrar este botão pode ser mais complexa depois
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MissionListPage()),
                );
              },
              child: const Text('Ver todas as oportunidades'),
            ),
          )
      ],
    );
  }

  Widget _buildOpportunityCard({required Mission mission}) {
    // A lógica de distância precisará de geolocalização no futuro
    final distance = '... km'; 
    final reward = 'R\$ ${mission.reward.toStringAsFixed(2)}';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(Icons.work, color: Theme.of(context).primaryColor),
        title: Text(mission.title),
        subtitle: Text('Distância: $distance'),
        trailing: Text(
          reward,
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MissionDetailsPage(missionId: mission.id),
            ),
          );
        },
      ),
    );
  }
} 