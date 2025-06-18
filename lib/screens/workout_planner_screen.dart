// lib/screens/workout_planner_screen.dart
import 'package:flutter/material.dart';
import 'package:smart_has_app/screens/main_dashboard_screen.dart'; // Changed from mindfit_app
import 'package:smart_has_app/screens/nutrition_tracker_screen.dart'; // Changed from mindfit_app
import 'package:smart_has_app/screens/chatbot_screen.dart'; // Changed from mindfit_app
import 'package:smart_has_app/screens/settings_screen.dart'; // Changed from mindfit_app

class WorkoutPlannerScreen extends StatelessWidget {
  const WorkoutPlannerScreen({super.key});

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "PLANEJAMENTO DE TREINOS",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset(
                  'assets/logo_mindfit.png',
                  width: 100,
                  height: 78,
                ),
              ],
            ),
            const SizedBox(height: 16),
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
                      "Nutrição",
                      Icons.restaurant,
                      () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const NutritionTrackerScreen()))),
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
            const SizedBox(height: 24),
            const Text(
              "Recomendados para você",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildRecommendedWorkoutCard(
                    "Treino HIIT 30 min",
                    "Queima de gordura",
                    'assets/workout_1.jpg', // Adicione esta imagem
                  ),
                  const SizedBox(width: 16),
                  _buildRecommendedWorkoutCard(
                    "Yoga para iniciantes",
                    "Relaxamento e flexibilidade",
                    'assets/workout_2.jpg', // Adicione esta imagem
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
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
                      "Desafio Semanal",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Complete 5 treinos esta semana",
                      style: TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: 0.60, // 3/5 treinos
                      backgroundColor: Colors.grey[300],
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "3/5 treinos completos",
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Artigos e Dicas",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildArticleCard(
              "Como melhorar sua alimentação",
              "Dicas para uma dieta equilibrada",
              'assets/article_1.jpg', // Adicione esta imagem
            ),
            const SizedBox(height: 12),
            _buildArticleCard(
              "Benefícios do sono para fitness",
              "Como o sono afeta seus resultados",
              'assets/article_2.jpg', // Adicione esta imagem
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ação para adicionar exercício
        },
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNavigationCard(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
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

  Widget _buildRecommendedWorkoutCard(
      String title, String subtitle, String imagePath) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        width: 280,
        height: 160,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black.withOpacity(0.2), // Overlay escuro
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard(String title, String subtitle, String imagePath) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
            child: Image.asset(
              imagePath,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}