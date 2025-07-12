import 'package:flutter/foundation.dart';
import 'package:futuropdv/backend/services/dashboard_service.dart';
import 'package:futuropdv/backend/services/location_service.dart';
import 'package:geolocator/geolocator.dart' hide LocationServiceDisabledException;
import 'package:futuropdv/backend/repositories/user_repository.dart';

class DashboardMotoristaProvider with ChangeNotifier {
  final DashboardService _dashboardService = DashboardService();
  final LocationService _locationService = LocationService();
  final UserRepository _userRepository = UserRepository();

  bool _isAvailable = false;
  DailySummary? _dailySummary;
  Position? _currentPosition;
  String? _locationError;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isAvailable => _isAvailable;
  DailySummary? get dailySummary => _dailySummary;
  Position? get currentPosition => _currentPosition;
  String? get locationError => _locationError;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void clearErrorMessage() {
    _errorMessage = null;
  }

  DashboardMotoristaProvider(String userId) {
    fetchAllData(userId);
  }

  Future<void> fetchAllData(String userId) async {
    _setLoading(true);
    // Resetamos os erros antes de tentar novamente.
    _locationError = null;
    _errorMessage = null;

    // Executamos em sequência para garantir um fluxo mais simples e robusto.
    await _fetchInitialStatus(userId);
    await fetchDailySummary(userId);
    await _fetchInitialLocation();
    
    _setLoading(false);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> toggleAvailability(String userId) async {
    _isAvailable = !_isAvailable;
    notifyListeners();
    try {
      await _userRepository.updateDriverAvailability(userId, _isAvailable);
    } catch (e) {
      // Se a atualização falhar, revertemos o estado da UI e notificamos o usuário.
      _isAvailable = !_isAvailable;
      _errorMessage = 'Falha ao atualizar o status. Tente novamente.';
      notifyListeners();
      print("Falha ao atualizar o status: $e");
    }
  }

  Future<void> _fetchInitialStatus(String userId) async {
    try {
      final partnerProfile = await _userRepository.getPartnerProfileById(userId);
      if (partnerProfile != null && partnerProfile.exists) {
        final data = partnerProfile.data() as Map<String, dynamic>?;
        _isAvailable = data?['isAvailable'] ?? false;
      }
    } catch (e) {
      _errorMessage = 'Erro ao buscar seu status.';
      print("Erro ao buscar status inicial: $e");
      // O padrão será 'false'
    }
  }

  Future<void> fetchDailySummary(String userId) async {
    try {
      _dailySummary = await _dashboardService.getDailySummary(userId);
    } catch (e) {
      _errorMessage = 'Erro ao buscar resumo diário.';
      print("Erro ao buscar resumo diário: $e");
      // Poderíamos ter um erro específico para o resumo também.
    }
  }

  Future<void> _fetchInitialLocation() async {
    try {
      _currentPosition = await _locationService.getCurrentPosition();
      _locationError = null;
    } on LocationServiceDisabledException {
      _locationError = 'Por favor, ative o GPS do seu celular.';
    } catch (e) {
      _locationError = 'Não foi possível obter a localização. Verifique sua conexão e permissões.';
    }
  }
} 