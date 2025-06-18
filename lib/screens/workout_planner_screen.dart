
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_has_app/providers/user_provider.dart';
import 'package:smart_has_app/providers/workout_provider.dart';
import 'package:smart_has_app/screens/main_dashboard_screen.dart';
import 'package:smart_has_app/screens/nutrition_tracker_screen.dart';
import 'package:smart_has_app/screens/chatbot_screen.dart';
import 'package:smart_has_app/screens/settings_screen.dart';
import 'package:smart_has_app/screens/add_workout_screen.dart';
import 'package:smart_has_app/widgets/compact_map_widget.dart';

class WorkoutPlannerScreen extends StatelessWidget {
  const WorkoutPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return Text(
              "Olá, ${userProvider.userName}!",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
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

            const SizedBox(height: 24),
            Consumer<WorkoutProvider>(
              builder: (context, workoutProvider, child) {
                return Card(
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
                          value: (workoutProvider.currentStreak / 5).clamp(0.0, 1.0),
                          backgroundColor: Colors.grey[300],
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${workoutProvider.currentStreak}/5 treinos completos",
                          style: const TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Widget de mapa compacto
            const CompactMapWidget(),
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
              'assets/article_1.jpg',
            ),
            const SizedBox(height: 12),
            _buildArticleCard(
              "Benefícios do sono para fitness",
              "Como o sono afeta seus resultados",
              'assets/article_2.jpg',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddWorkoutScreen(),
            ),
          );
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
          width: 100, // Defina uma largura fixa
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.black),
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
