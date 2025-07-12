
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(String userId, String name, String email, List<String> roles) async {
    try {
      await _usersCollection.doc(userId).set({
        'name': name,
        'email': email,
        'userRoles': roles,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'active', // ou 'pending_verification' dependendo do fluxo
        'onboardingCompleted': false,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<DocumentSnapshot?> getUserById(String userId) async {
    try {
      return await _usersCollection.doc(userId).get();
    } catch (e) {
      print('Erro ao buscar usuário: $e');
      return null;
    }
  }

  Future<DocumentSnapshot?> getPartnerProfileById(String userId) async {
    try {
      return await _firestore.collection('partnerProfiles').doc(userId).get();
    } catch (e) {
      print('Erro ao buscar perfil de parceiro: $e');
      return null;
    }
  }

  Future<void> updateLastLogin(String userId) async {
    try {
      await _usersCollection.doc(userId).update({
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addDeviceToken(String userId, String token) async {
    try {
      await _usersCollection.doc(userId).update({
        'deviceTokens': FieldValue.arrayUnion([token]),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserRoles(String userId, List<String> roles) async {
    try {
      await _usersCollection.doc(userId).update({
        'userRoles': roles,
      });
    } catch (e) {
      // Propaga o erro para ser tratado na UI
      rethrow;
    }
  }

  Future<void> markOnboardingCompleted(String userId) async {
    try {
      await _usersCollection.doc(userId).update({
        'onboardingCompleted': true,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateDriverAvailability(String userId, bool isAvailable) async {
    try {
      // Usaremos o partnerProfiles para armazenar dados específicos do parceiro/motorista
      await _firestore.collection('partnerProfiles').doc(userId).set({
        'isAvailable': isAvailable,
        'lastStatusUpdate': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }
} 