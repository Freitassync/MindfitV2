import 'package:flutter/material.dart';
import 'package:smart_has_app/models/user.dart';
import 'package:smart_has_app/services/user_service.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  final UserService _userService = UserService();

  User? get currentUser => _currentUser;

  Future<void> loadCurrentUser(String userId) async {
    try {
      _currentUser = await _userService.fetchUserData(userId);
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading user: $e");
    }
  }

  Future<bool> updateCurrentUser(User user) async {
    try {
      const mockUserId = "1";
      final success = await _userService.updateUserData(mockUserId, user);
      if (success) {
        _currentUser = user;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error updating user: $e");
      return false;
    }
  }

  // Métodos auxiliares para facilitar o acesso aos dados
  String get userName => _currentUser?.name ?? "Usuário";
  double get currentWeight => _currentUser?.weight ?? 0.0;
  double get goalWeight => _currentUser?.goalWeight ?? 0.0;
  double get weightDifference => goalWeight - currentWeight;
  String get weightDifferenceText {
    final diff = weightDifference;
    if (diff > 0) {
      return "+${diff.toStringAsFixed(1)} kg";
    } else if (diff < 0) {
      return "${diff.toStringAsFixed(1)} kg";
    } else {
      return "Meta atingida!";
    }
  }

  Color get weightDifferenceColor {
    final diff = weightDifference;
    if (diff > 0) {
      return Colors.orange; // Precisa ganhar peso
    } else if (diff < 0) {
      return Colors.green; // Perdendo peso (assumindo que é o objetivo)
    } else {
      return Colors.blue; // Meta atingida
    }
  }
}
