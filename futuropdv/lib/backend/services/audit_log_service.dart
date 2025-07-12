import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

enum LogAction {
  userCreated,
  missionApproved,
  paymentProcessed,
  // Adicione outras ações conforme necessário
}

class AuditLogService {
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(region: 'us-central1');

  Future<void> logAction({
    required String action,
    required String performedBy,
    String? targetId,
    String? targetType,
    Map<String, dynamic>? previousData,
    Map<String, dynamic>? newData,
  }) async {
    // Os dados a serem enviados para a Cloud Function
    final Map<String, dynamic> logData = {
      'action': action,
      'performedBy': performedBy, // Será sobrescrito pela função com o UID do usuário autenticado
      'targetId': targetId,
      'targetType': targetType,
      'previousData': previousData,
      'newData': newData,
      // O timestamp será adicionado pela função
    };

    try {
      final HttpsCallable callable = _functions.httpsCallable('addAuditLog');
      final result = await callable.call(logData);
      print('Log de auditoria enviado com sucesso: ${result.data}');
    } on FirebaseFunctionsException catch (e) {
      print('Erro ao chamar a função de auditoria: ${e.code} - ${e.message}');
      // Em um app real, seria bom ter um tratamento de erro mais robusto aqui.
    } catch (e) {
      print('Erro inesperado ao chamar a função de auditoria: $e');
    }
  }
} 