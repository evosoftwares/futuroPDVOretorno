import 'package:cloud_firestore/cloud_firestore.dart';

class DailySummary {
  final double earnings;
  final int completedMissions;
  final double averageRating;

  DailySummary({
    required this.earnings,
    required this.completedMissions,
    required this.averageRating,
  });
}

class DashboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DailySummary> getDailySummary(String userId) async {
    // Definir o intervalo de hoje
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final endOfToday = startOfToday.add(const Duration(days: 1));

    // 1. Consultar missões completadas hoje
    final missionsSnapshot = await _firestore
        .collection('missions')
        .where('driverId', isEqualTo: userId)
        .where('status', isEqualTo: 'completed')
        .where('completedAt', isGreaterThanOrEqualTo: startOfToday)
        .where('completedAt', isLessThan: endOfToday)
        .get();

    double totalEarnings = 0;
    for (var doc in missionsSnapshot.docs) {
      // Usamos .get() que pode lançar um erro se o campo não existir.
      // Em um app de produção, é bom ter um tratamento de erro mais robusto (ex: usar um modelo com fromJson).
      totalEarnings += (doc.data()['reward'] as num?) ?? 0.0;
    }

    final int completedMissions = missionsSnapshot.docs.length;

    // 2. Calcular a avaliação média do motorista (COM MITIGAÇÃO DE PERFORMANCE)
    // ATENÇÃO: A lógica ideal é usar uma Cloud Function para desnormalizar este valor.
    // Limitamos a 100 para evitar custos e lentidão excessivos como medida paliativa.
    final reviewsSnapshot = await _firestore
        .collection('reviews')
        .where('driverId', isEqualTo: userId)
        .limit(100) // Mitigação de performance
        .get();
    
    double totalRating = 0;
    int reviewCount = reviewsSnapshot.docs.length;
    if (reviewCount > 0) {
      for (var doc in reviewsSnapshot.docs) {
        totalRating += (doc.data()['rating'] as num?) ?? 0.0;
      }
    }

    final double averageRating = reviewCount > 0 ? totalRating / reviewCount : 0.0;

    return DailySummary(
      earnings: totalEarnings,
      completedMissions: completedMissions,
      averageRating: averageRating,
    );
  }
} 