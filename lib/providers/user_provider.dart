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
      // Em um aplicativo real, use o ID do usuário autenticado.
      const mockUserId = "mockUserId"; 
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
}