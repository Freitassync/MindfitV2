// lib/screens/chatbot_screen.dart
import 'package:flutter/material.dart';
import 'package:smart_has_app/screens/main_dashboard_screen.dart'; // Changed from mindfit_app

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MainDashboardScreen()),
            );
          },
        ),
        title: const Text(
          "Assistente MindFit",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mensagem do usuário
                  Align(
                    alignment: Alignment.centerRight,
                    child: Card(
                      color: Theme.of(context).colorScheme.primary, // Cor do tema
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          "Olá! Preciso de ajuda com minha dieta.",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Mensagem do bot
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          "Olá! Sou o assistente MindFit e estou aqui para ajudar você com sua jornada fitness. Em breve estarei disponível para responder suas dúvidas!",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    enabled: false, // Desabilitado como no Kotlin
                    decoration: InputDecoration(
                      hintText: "Chat em desenvolvimento...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: null, // Desabilitado como no Kotlin
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey, // Cor para botão desabilitado
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text("Enviar"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}