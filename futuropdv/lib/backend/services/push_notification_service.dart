import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> initialize(String userId) async {
    // Solicita permissão para iOS e web
    await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Obtém o token FCM do dispositivo
    final token = await _fcm.getToken();
    print("Firebase Messaging Token: $token");
    
    if (token != null) {
      await _saveTokenToDatabase(userId, token);
    }

    // Listener para quando o token é atualizado
    _fcm.onTokenRefresh.listen((newToken) {
      _saveTokenToDatabase(userId, newToken);
    });

    // Listener para quando o app está em primeiro plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Recebida uma mensagem em primeiro plano!');
      print('Dados da mensagem: ${message.data}');

      // Se for uma notificação de nova missão, vibra para alertar o motorista.
      if (message.data['type'] == 'new_mission') {
        Vibrate.feedback(FeedbackType.heavy);
        // Aqui também poderíamos mostrar uma SnackBar ou um alerta customizado.
      }

      if (message.notification != null) {
        print('A mensagem também continha uma notificação: ${message.notification}');
        // Aqui você pode exibir um diálogo, uma snackbar, etc.
      }
    });

    // Listener para quando o app está em segundo plano e o usuário clica na notificação
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A mensagem foi aberta a partir do segundo plano: ${message.data}');
      // TODO: Navegar para a tela apropriada com base nos dados da mensagem
    });

    // Para notificações recebidas quando o app está terminado (não em execução)
    // Isso é tratado quando o app é iniciado a partir da notificação
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('App iniciado a partir de uma notificação terminada: ${message.data}');
        // TODO: Navegar para a tela apropriada
        // Ex: if (message.data['type'] == 'new_mission') { ... navega para o dashboard ... }
      }
    });
  }

  Future<void> _saveTokenToDatabase(String userId, String token) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'fcmToken': token,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      print("Token salvo no Firestore com sucesso.");
    } catch (e) {
      print("Erro ao salvar token no Firestore: $e");
    }
  }
} 