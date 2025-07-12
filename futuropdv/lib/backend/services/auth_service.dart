
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:futuropdv/backend/repositories/user_repository.dart';
import 'package:futuropdv/backend/services/push_notification_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepository _userRepository = UserRepository();
  final PushNotificationService _pushNotificationService = PushNotificationService();

  Future<Map<String, dynamic>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final userDoc = await _userRepository.getUserById(userCredential.user!.uid);
        if (userDoc != null) {
          final userData = userDoc.data() as Map<String, dynamic>;
          if (userData['status'] == 'active') {
            await _userRepository.updateLastLogin(userCredential.user!.uid);
            
            // Registrar token do dispositivo corretamente
            await _pushNotificationService.initialize(userCredential.user!.uid);

            return {
              'success': true,
              'user': userCredential.user,
            };
          } else {
            // Usuário suspenso ou inativo
            await _auth.signOut();
            return {
              'success': false,
              'error': 'Sua conta está ${userData['status']}. Entre em contato com o suporte.',
            };
          }
        } else {
          // Documento do usuário não encontrado
          await _auth.signOut();
          return {
            'success': false,
            'error': 'Dados do usuário não encontrados. Entre em contato com o suporte.',
          };
        }
      }
      return {
        'success': false,
        'error': 'Falha na autenticação.',
      };
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Erro de autenticação: ${e.code}');
      }
      
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Usuário não encontrado.';
          break;
        case 'wrong-password':
          errorMessage = 'Senha incorreta.';
          break;
        case 'invalid-email':
          errorMessage = 'Email inválido.';
          break;
        case 'user-disabled':
          errorMessage = 'Esta conta foi desativada.';
          break;
        case 'too-many-requests':
          errorMessage = 'Muitas tentativas. Tente novamente mais tarde.';
          break;
        case 'invalid-credential':
          errorMessage = 'Email ou senha inválidos.';
          break;
        default:
          errorMessage = 'Erro ao fazer login. Tente novamente.';
      }
      
      return {
        'success': false,
        'error': errorMessage,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Erro inesperado: $e');
      }
      return {
        'success': false,
        'error': 'Erro inesperado. Tente novamente.',
      };
    }
  }

  Future<Map<String, dynamic>> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return {
        'success': true,
        'user': userCredential.user,
      };
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Erro de registro: ${e.code}');
      }
      
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'A senha é muito fraca.';
          break;
        case 'email-already-in-use':
          errorMessage = 'Este email já está em uso.';
          break;
        case 'invalid-email':
          errorMessage = 'Email inválido.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Registro não permitido. Entre em contato com o suporte.';
          break;
        default:
          errorMessage = 'Erro ao criar conta. Tente novamente.';
      }
      
      return {
        'success': false,
        'error': errorMessage,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Erro inesperado no registro: $e');
      }
      return {
        'success': false,
        'error': 'Erro inesperado. Tente novamente.',
      };
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao enviar email de redefinição de senha: $e');
      }
      rethrow;
    }
  }

  // Adicionar métodos de logout, etc.
} 