import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  // Simula uma chamada de API para login.
  // Em um aplicativo real, substitua esta lógica por uma chamada a um serviço de autenticação.
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); 
    if (email == "test@example.com" && password == "password") {
      return true;
    }
    return false;
  }

  // Simula o registro de um novo usuário.
  Future<void> register() async {
    await Future.delayed(const Duration(seconds: 1));
    // Implemente a lógica de registro real aqui.
  }
}