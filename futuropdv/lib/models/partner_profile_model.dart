import 'package:cloud_firestore/cloud_firestore.dart';

enum PartnerStatus { available, in_mission, offline }

class PartnerProfile {
  final PartnerStatus status;
  // Adicione outros campos do perfil do parceiro aqui conforme necessário
  // final String otherField;

  PartnerProfile({
    required this.status,
    // required this.otherField,
  });

  factory PartnerProfile.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception("Document data was null!");
    }

    return PartnerProfile(
      status: _parseStatus(data['status']),
      // otherField: data['otherField'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'status': status.name,
      // 'otherField': otherField,
    };
  }

  static PartnerStatus _parseStatus(String? statusString) {
    if (statusString == null) return PartnerStatus.offline;
    
    switch (statusString) {
      case 'available':
        return PartnerStatus.available;
      case 'in_mission':
        return PartnerStatus.in_mission;
      default:
        return PartnerStatus.offline;
    }
  }

  // Método público para parseStatus
  static PartnerStatus parseStatus(String? statusString) {
    return _parseStatus(statusString);
  }
} 