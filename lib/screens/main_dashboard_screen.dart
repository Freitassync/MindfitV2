// lib/screens/main_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:smart_has_app/screens/nutrition_tracker_screen.dart'; // Changed from mindfit_app
import 'package:smart_has_app/screens/workout_planner_screen.dart'; // Changed from mindfit_app
import 'package:smart_has_app/screens/chatbot_screen.dart'; // Changed from mindfit_app
import 'package:smart_has_app/screens/settings_screen.dart'; // Changed from mindfit_app

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  // Mock data (from Kotlin project)
  String currentWeight = "73.0 kg";
  String weightDiff = "-2.5 kg";
  Color weightDiffColor = Colors.green;
  String caloriesConsumed = "1850";
  String caloriesGoal = "2000";
  String workoutsCompleted = "12";
  String streak = "5 dias";

  List<FlSpot> weightData = [
    const FlSpot(0, 75.5),
    const FlSpot(1, 75.0),
    const FlSpot(2, 74.5),
    const FlSpot(3, 74.2),
    const FlSpot(4, 73.8),
    const FlSpot(5, 73.3),
    const FlSpot(6, 73.0),
  ];

  List<String> getLastSevenDays() {
    final dateFormat = DateFormat("dd/MM");
    final dates = <String>[];
    final now = DateTime.now();
    for (int i = 6; i >= 0; i--) {
      dates.add(dateFormat.format(now.subtract(Duration(days: i))));
    }
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    final lastSevenDays = getLastSevenDays();

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
                  "DASHBOARD PRINCIPAL",
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
            Row(
              children: [
                _buildFeatureCard(
                  context,
                  "Treinos",
                  Icons.fitness_center,
                  () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) =>
                              const WorkoutPlannerScreen())),
                ),
                const SizedBox(width: 16),
                _buildFeatureCard(
                  context,
                  "Nutrição",
                  Icons.restaurant,
                  () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) =>
                              const NutritionTrackerScreen())),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildFeatureCard(
                  context,
                  "Assistente",
                  Icons.chat,
                  () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const ChatbotScreen())),
                ),
                const SizedBox(width: 16),
                _buildFeatureCard(
                  context,
                  "Configurações",
                  Icons.settings,
                  () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const SettingsScreen())),
                ),
              ],
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
                      "Peso Atual",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          currentWeight,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          weightDiff,
                          style: TextStyle(
                              fontSize: 16, color: weightDiffColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    space: 8,
                                    child: Text(
                                      lastSevenDays[value.toInt()],
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.black),
                                    ),
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toStringAsFixed(0),
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.black),
                                  );
                                },
                              ),
                            ),
                            topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: weightData,
                              isCurved: true,
                              color: Colors.blue,
                              barWidth: 2,
                              isStrokeCapRound: true,
                              dotData: FlDotData(show: true),
                              belowBarData: BarAreaData(show: false),
                            ),
                          ],
                          minX: 0,
                          maxX: 6,
                          minY: 70,
                          maxY: 76,
                        ),
                      ),
                    ),
                  ],
                ),
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
                      "Resumo Diário",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildDailySummaryItem(
                            "Calorias",
                            "$caloriesConsumed",
                            "Meta: $caloriesGoal"),
                        _buildDailySummaryItem(
                            "Treinos", workoutsCompleted, "Este mês"),
                        _buildDailySummaryItem(
                            "Sequência", streak, "Consecutivos"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
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
      ),
    );
  }

  Widget _buildDailySummaryItem(
      String title, String value, String subtitle) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 20),
        ),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}