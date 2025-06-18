// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:smart_has_app/screens/main_dashboard_screen.dart'; // Changed from mindfit_app

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _appVersion = "1.0.0"; // Mock version

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary, // Usar primary color do tema
        foregroundColor: Colors.white,
        title: const Text("Configurações"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MainDashboardScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Notificações",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SwitchListTile(
              title: const Text("Ativar notificações"),
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Notificações ${value ? "ativadas" : "desativadas"}")),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              "Aparência",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SwitchListTile(
              title: const Text("Tema escuro"),
              value: _darkModeEnabled,
              onChanged: (bool value) {
                setState(() {
                  _darkModeEnabled = value;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Tema escuro ${value ? "ativado" : "desativado"}")),
                );
                // Lógica para mudar o tema do aplicativo (pode ser feita via Provider/ThemeData)
              },
            ),
            const SizedBox(height: 24),
            const Text(
              "Sobre",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              title: const Text("Versão"),
              subtitle: Text(_appVersion),
            ),
            const SizedBox(height: 24),
            const Text(
              "Créditos",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const ListTile(
              title: Text("Felipe Cavalcanti\nMateus Vicente\nGabriel Freitas\nMurilo Moura\nRoberto Felix"),
            ),
          ],
        ),
      ),
    );
  }
}