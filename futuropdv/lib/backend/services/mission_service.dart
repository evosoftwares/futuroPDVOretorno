import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:futuropdv/models/mission_model.dart';

class MissionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Busca uma lista de missões disponíveis, ordenadas pela data de criação.
  Stream<List<Mission>> getAvailableMissionsStream() {
    return _firestore
        .collection('missions')
        .where('status', isEqualTo: 'available')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Mission.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
      }).toList();
    });
  }

  /// Atribui uma missão a um motorista e atualiza seu status para 'accepted'.
  Future<void> acceptMission(String missionId, String driverId) async {
    try {
      await _firestore.collection('missions').doc(missionId).update({
        'status': 'accepted',
        'driverId': driverId,
        'acceptedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // É importante tratar o erro, talvez logando ou relançando uma exceção mais específica.
      print('Erro ao aceitar a missão: $e');
      rethrow;
    }
  }
} 