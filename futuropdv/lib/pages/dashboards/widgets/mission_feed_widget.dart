import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futuropdv/backend/services/mission_service.dart';
import 'package:futuropdv/models/mission_model.dart';
import 'package:futuropdv/pages/dashboards/widgets/mission_card_widget.dart';

class MissionFeedWidget extends StatefulWidget {
  const MissionFeedWidget({Key? key}) : super(key: key);

  @override
  State<MissionFeedWidget> createState() => _MissionFeedWidgetState();
}

class _MissionFeedWidgetState extends State<MissionFeedWidget> {
  final MissionService _missionService = MissionService();
  bool _isAccepting = false;

  Future<void> _acceptMission(String missionId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você precisa estar logado para aceitar uma missão.')),
      );
      return;
    }

    setState(() => _isAccepting = true);

    try {
      await _missionService.acceptMission(missionId, user.uid);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Missão aceita com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao aceitar a missão: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAccepting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Mission>>(
      stream: _missionService.getAvailableMissionsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Erro ao carregar corridas: ${snapshot.error}'),
          );
        }

        final missions = snapshot.data;

        if (missions == null || missions.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.explore_off, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Nenhuma corrida disponível no momento.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Você será notificado assim que uma nova oportunidade aparecer.',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: missions.length,
          itemBuilder: (context, index) {
            final mission = missions[index];
            return MissionCardWidget(
              mission: mission,
              onAccept: _isAccepting ? () {} : () => _acceptMission(mission.id),
            );
          },
        );
      },
    );
  }
} 