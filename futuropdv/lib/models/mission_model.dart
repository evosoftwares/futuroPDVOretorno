import 'package:cloud_firestore/cloud_firestore.dart';

enum MissionStatus { available, accepted, in_progress, completed, cancelled }

class Mission {
  final String id;
  final String clientName;
  final String? notes;
  final double reward; // Valor da corrida
  final MissionStatus status;
  
  // Pontos da corrida
  final GeoPoint pickupLocation;
  final String pickupAddress;
  final GeoPoint destinationLocation;
  final String destinationAddress;

  // Detalhes estimados
  final double estimatedDistance; // em km
  final int estimatedTime; // em minutos

  final String createdBy; // ID do cliente
  final Timestamp createdAt;
  final String? driverId; // ID do motorista que aceitou

  Mission({
    required this.id,
    required this.clientName,
    this.notes,
    required this.reward,
    required this.status,
    required this.pickupLocation,
    required this.pickupAddress,
    required this.destinationLocation,
    required this.destinationAddress,
    required this.estimatedDistance,
    required this.estimatedTime,
    required this.createdBy,
    required this.createdAt,
    this.driverId,
  });

  // Getter para o título da missão
  String get title => 'Missão para $clientName';

  factory Mission.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception("Mission data not found!");
    }

    return Mission(
      id: snapshot.id,
      clientName: data['clientName'] ?? 'Cliente Anônimo',
      notes: data['notes'],
      reward: (data['reward'] ?? 0.0).toDouble(),
      status: _parseStatus(data['status']),
      pickupLocation: data['pickupLocation'] ?? const GeoPoint(0, 0),
      pickupAddress: data['pickupAddress'] ?? 'Endereço de partida não informado',
      destinationLocation: data['destinationLocation'] ?? const GeoPoint(0, 0),
      destinationAddress: data['destinationAddress'] ?? 'Endereço de destino não informado',
      estimatedDistance: (data['estimatedDistance'] ?? 0.0).toDouble(),
      estimatedTime: (data['estimatedTime'] ?? 0).toInt(),
      createdBy: data['createdBy'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      driverId: data['driverId'],
    );
  }

  static MissionStatus _parseStatus(String? statusString) {
    switch (statusString) {
      case 'available':
        return MissionStatus.available;
      case 'accepted':
        return MissionStatus.accepted;
      case 'in_progress':
        return MissionStatus.in_progress;
      case 'completed':
        return MissionStatus.completed;
      case 'cancelled':
        return MissionStatus.cancelled;
      default:
        // Se o status for desconhecido, é mais seguro não mostrá-la.
        // Ou ter um status 'unknown' para debug.
        // Por agora, vamos assumir que não deveria aparecer no feed.
        return MissionStatus.cancelled; 
    }
  }
} 