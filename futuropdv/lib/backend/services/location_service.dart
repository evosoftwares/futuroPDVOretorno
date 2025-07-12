import 'package:geolocator/geolocator.dart';

class LocationServiceDisabledException implements Exception {}
class LocationPermissionDeniedException implements Exception {}
class LocationPermissionDeniedForeverException implements Exception {}

class LocationService {
  /// Determina a posição atual do dispositivo.
  ///
  /// Quando os serviços de localização não estão ativados ou as permissões
  /// são negadas, a função `Future` retornará um erro.
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Testa se os serviços de localização estão ativados.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Serviços de localização não estão ativados. Não é possível continuar
      // acessando a posição e solicitamos aos usuários que ativem os serviços.
      throw LocationServiceDisabledException();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // As permissões foram negadas, da próxima vez você poderia tentar
        // mostrar a UI para solicitar permissões novamente.
        throw LocationPermissionDeniedException();
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // As permissões são negadas para sempre, lide com isso apropriadamente.
      throw LocationPermissionDeniedForeverException();
    } 

    // Quando chegamos aqui, as permissões foram concedidas e podemos
    // continuar acessando a posição do dispositivo.
    return await Geolocator.getCurrentPosition();
  }
} 