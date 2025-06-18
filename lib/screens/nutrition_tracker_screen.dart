// lib/screens/nutrition_tracker_screen.dart
import 'package:flutter/material.dart';
import 'package:smart_has_app/screens/main_dashboard_screen.dart'; // Changed from mindfit_app
import 'package:smart_has_app/screens/workout_planner_screen.dart'; // Changed from mindfit_app
import 'package:smart_has_app/screens/chatbot_screen.dart'; // Changed from mindfit_app
import 'package:smart_has_app/screens/settings_screen.dart'; // Changed from mindfit_app

class NutritionTrackerScreen extends StatefulWidget {
  const NutritionTrackerScreen({super.key});

  @override
  State<NutritionTrackerScreen> createState() => _NutritionTrackerScreenState();
}

class _NutritionTrackerScreenState extends State<NutritionTrackerScreen> {
  // Mock data for meals (for future implementation)
  final List<String> _meals = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Olá, Usuário!",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              // Implementar notificações
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildNavigationCard(
                      context,
                      "Dashboard",
                      Icons.dashboard,
                      () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const MainDashboardScreen()))),
                  _buildNavigationCard(
                      context,
                      "Treinos",
                      Icons.fitness_center,
                      () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const WorkoutPlannerScreen()))),
                  _buildNavigationCard(
                      context,
                      "Chatbot",
                      Icons.chat,
                      () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const ChatbotScreen()))),
                  _buildNavigationCard(
                      context,
                      "Configurações",
                      Icons.settings,
                      () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const SettingsScreen()))),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "ACOMPANHAMENTO NUTRICIONAL",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Calorias Diárias",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          "1500/2000 kcal",
                          style: TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: 0.75, // 1500/2000
                            backgroundColor: Colors.grey[300],
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Macronutrientes",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMacroNutrientCard("Proteínas", "75g", Icons.fitness_center),
                _buildMacroNutrientCard("Carboidratos", "200g", Icons.fastfood),
                _buildMacroNutrientCard("Gorduras", "50g", Icons.local_pizza),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              "Refeições de Hoje",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Exemplo de lista de refeições (pode ser um ListView.builder real)
            _meals.isEmpty
                ? const Text("Nenhuma refeição registrada hoje.")
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _meals.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(_meals[index]),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Adicionar refeição - Em desenvolvimento")),
          );
        },
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNavigationCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 100,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.black),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMacroNutrientCard(String title, String value, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.black),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}