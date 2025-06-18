
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationProvider with ChangeNotifier {
  Position? _currentPosition;
  bool _isLoading = false;
  String? _errorMessage;
  bool _locationPermissionGranted = false;

  Position? get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get locationPermissionGranted => _locationPermissionGranted;

  Future<void> requestLocationPermission() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Verificar se o serviço de localização está habilitado
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _errorMessage = 'Serviço de localização está desabilitado.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Verificar permissões
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _errorMessage = 'Permissão de localização negada.';
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _errorMessage = 'Permissão de localização negada permanentemente.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      _locationPermissionGranted = true;
      await getCurrentLocation();
    } catch (e) {
      _errorMessage = 'Erro ao solicitar permissão: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getCurrentLocation() async {
    if (!_locationPermissionGranted) {
      await requestLocationPermission();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      _errorMessage = 'Erro ao obter localização: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  double calculateDistance(double lat, double lon) {
    if (_currentPosition == null) return 0.0;
    
    return Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      lat,
      lon,
    ) / 1000; // Converter para km
  }
}
