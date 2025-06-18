
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_has_app/providers/user_provider.dart';
import 'package:smart_has_app/screens/main_dashboard_screen.dart';
import 'package:smart_has_app/screens/workout_planner_screen.dart';
import 'package:smart_has_app/screens/chatbot_screen.dart';
import 'package:smart_has_app/screens/settings_screen.dart';
import 'package:smart_has_app/services/nutrition_service.dart';

class NutritionTrackerScreen extends StatefulWidget {
  const NutritionTrackerScreen({super.key});

  @override
  State<NutritionTrackerScreen> createState() => _NutritionTrackerScreenState();
}

class _NutritionTrackerScreenState extends State<NutritionTrackerScreen> {
  final NutritionService _nutritionService = NutritionService();
  final List<Map<String, dynamic>> _meals = [];
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  Map<String, double> _dailyTotals = {
    'calories': 0,
    'protein': 0,
    'carbs': 0,
    'fat': 0,
    'fiber': 0,
  };
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _calculateDailyTotals();
  }

  void _calculateDailyTotals() {
    final totals = _nutritionService.calculateTotalMacros(_meals);
    setState(() {
      _dailyTotals = totals;
    });
  }

  Future<void> _searchFood(String query, void Function(void Function()) updateState) async {
    if (query.isEmpty) {
      updateState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    updateState(() {
      _isSearching = true;
    });

    try {
      final results = await _nutritionService.searchFood(query);
      final uniqueResults = removeDuplicatesByName(results);
      updateState(() {
        _searchResults = uniqueResults;
        _isSearching = false;
      });
    } catch (e) {
      updateState(() {
        _isSearching = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar alimento: $e')),
      );
    }
  }

  List<Map<String, dynamic>> removeDuplicatesByName(List<Map<String, dynamic>> list) {
    final seen = <String>{};
    return list.where((item) {
      final name = item['name']?.toString().toLowerCase() ?? '';
      if (seen.contains(name)) {
        return false;
      } else {
        seen.add(name);
        return true;
      }
    }).toList();
  }

  void _addFood(Map<String, dynamic> food) {
    setState(() {
      _meals.add(Map<String, dynamic>.from(food));
      _searchResults = [];
      _searchController.clear();
    });
    _calculateDailyTotals();
    Navigator.pop(context);
  }

  void _showAddFoodDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Adicionar Alimento'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Buscar alimento',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(const Duration(milliseconds: 500), () {
                      _searchFood(value, setDialogState);
                    });
                  },
                ),
                const SizedBox(height: 16),
                if (_isSearching)
                  const Center(child: CircularProgressIndicator())
                else if (_searchResults.isEmpty && _searchController.text.isNotEmpty)
                  const Text('Nenhum alimento encontrado')
                else if (_searchResults.isEmpty)
                  Column(
                    children: [
                      const Text('Sugestões populares:'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: _nutritionService.getPopularFoods().map((food) => 
                          ActionChip(
                            label: Text(food),
                            onPressed: () {
                              _searchController.text = food;
                              _searchFood(food, setDialogState);
                              setDialogState(() {});
                            },
                          ),
                        ).toList(),
                      ),
                    ],
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final food = _searchResults[index];
                        return ListTile(
                          title: Text(food['name']),
                          subtitle: Text('${food['calories']} kcal'),
                          trailing: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => _addFood(food),
                          ),
                          onTap: () => _showFoodDetails(food),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }

  void _showFoodDetails(Map<String, dynamic> food) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(food['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Calorias: ${food['calories']} kcal'),
            Text('Proteínas: ${food['protein']}g'),
            Text('Carboidratos: ${food['carbs']}g'),
            Text('Gorduras: ${food['fat']}g'),
            Text('Fibras: ${food['fiber']}g'),
            if (food['sugar'] != null) Text('Açúcares: ${food['sugar']}g'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _addFood(food);
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

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
                        Text(
                          "${_dailyTotals['calories']!.toInt()}/2000 kcal",
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: (_dailyTotals['calories']! / 2000).clamp(0.0, 1.0),
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
                _buildMacroNutrientCard("Proteínas", "${_dailyTotals['protein']!.toInt()}g", Icons.fitness_center),
                _buildMacroNutrientCard("Carboidratos", "${_dailyTotals['carbs']!.toInt()}g", Icons.fastfood),
                _buildMacroNutrientCard("Gorduras", "${_dailyTotals['fat']!.toInt()}g", Icons.local_pizza),
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
            _meals.isEmpty
                ? const Text("Nenhuma refeição registrada hoje.")
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _meals.length,
                    itemBuilder: (context, index) {
                      final meal = _meals[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(meal['name']),
                          subtitle: Text('${meal['calories']} kcal'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('P: ${meal['protein']}g'),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _meals.removeAt(index);
                                  });
                                  _calculateDailyTotals();
                                },
                              ),
                            ],
                          ),
                          onTap: () => _showFoodDetails(meal),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFoodDialog,
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
