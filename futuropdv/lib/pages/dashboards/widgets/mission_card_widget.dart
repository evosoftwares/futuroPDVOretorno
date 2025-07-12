import 'package:flutter/material.dart';
import 'package:futuropdv/models/mission_model.dart';

class MissionCardWidget extends StatelessWidget {
  final Mission mission;
  final VoidCallback onAccept;

  const MissionCardWidget({
    Key? key,
    required this.mission,
    required this.onAccept,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Corrida Disponível',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                Text(
                  'R\$ ${mission.reward.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow(context, Icons.location_on, 'Partida', mission.pickupAddress),
            const SizedBox(height: 8),
            _buildInfoRow(context, Icons.flag, 'Destino', mission.destinationAddress),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricChip('${mission.estimatedDistance.toStringAsFixed(1)} km'),
                _buildMetricChip('${mission.estimatedTime} min'),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Aceitar Corrida'),
                onPressed: onAccept,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 2),
              Text(value, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
} 