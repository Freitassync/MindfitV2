import 'package:flutter/material.dart';
import 'package:smart_has_app/models/user.dart';

class UserService {
  final String _baseUrl = "https://api.example.com/users";

  Future<User> fetchUserData(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return User(
      name: "João Silva",
      age: 30,
      height: 175.0,
      weight: 70.0,
      goalWeight: 68.0,
      specialConditions: ["Nenhuma"],
      otherObservations: "Gosta de correr",
    );
  }

  Future<bool> updateUserData(String userId, User user) async {
    await Future.delayed(const Duration(seconds: 1));
    debugPrint("User data updated for $userId: ${user.toJson()}");
    return true;
  }
}
