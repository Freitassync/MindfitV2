
import 'dart:convert';
import 'package:http/http.dart' as http;

class NutritionService {
  // Usando USDA FoodData Central API (gratuita)
  static const String _baseUrl = 'https://api.nal.usda.gov/fdc/v1';
  static const String _apiKey = 'jIuAqMBIELVyKM9pJIpaU6OFad02qhVnEpsNxykn'; // Para produção, use uma chave real
  
  // Dados mock para quando a API não estiver disponível
  static final Map<String, Map<String, dynamic>> _mockFoodData = {
    'banana': {
      'name': 'Banana',
      'calories': 89,
      'protein': 1.1,
      'carbs': 22.8,
      'fat': 0.3,
      'fiber': 2.6,
      'sugar': 12.2,
    },
    'maçã': {
      'name': 'Maçã',
      'calories': 52,
      'protein': 0.3,
      'carbs': 13.8,
      'fat': 0.2,
      'fiber': 2.4,
      'sugar': 10.4,
    },
    'arroz': {
      'name': 'Arroz Branco Cozido',
      'calories': 130,
      'protein': 2.7,
      'carbs': 28.2,
      'fat': 0.3,
      'fiber': 0.4,
      'sugar': 0.1,
    },
    'frango': {
      'name': 'Peito de Frango Grelhado',
      'calories': 165,
      'protein': 31.0,
      'carbs': 0.0,
      'fat': 3.6,
      'fiber': 0.0,
      'sugar': 0.0,
    },
    'ovo': {
      'name': 'Ovo Cozido',
      'calories': 155,
      'protein': 13.0,
      'carbs': 1.1,
      'fat': 11.0,
      'fiber': 0.0,
      'sugar': 1.1,
    },
    'aveia': {
      'name': 'Aveia',
      'calories': 389,
      'protein': 16.9,
      'carbs': 66.3,
      'fat': 6.9,
      'fiber': 10.6,
      'sugar': 0.0,
    },
    'leite': {
      'name': 'Leite Integral',
      'calories': 61,
      'protein': 3.2,
      'carbs': 4.8,
      'fat': 3.3,
      'fiber': 0.0,
      'sugar': 4.8,
    },
    'pão': {
      'name': 'Pão Integral',
      'calories': 247,
      'protein': 13.0,
      'carbs': 41.0,
      'fat': 4.2,
      'fiber': 6.0,
      'sugar': 6.0,
    },
  };

  Future<List<Map<String, dynamic>>> searchFood(String query) async {
    try {
      // Primeiro, buscar nos dados mock
      final mockResults = _searchMockData(query);
      if (mockResults.isNotEmpty) {
        return mockResults;
      }

      // Só tenta a API se a chave estiver preenchida
      if (_apiKey.isEmpty) {
        print('API KEY não fornecida!');
        return [];
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/foods/search?query=$query&api_key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Verifica se o campo 'foods' existe e é uma lista
        if (data['foods'] is List && (data['foods'] as List).isNotEmpty) {
          final foods = data['foods'] as List;
          return foods.take(5).map((food) => {
            'name': food['description'] ?? 'Alimento desconhecido',
            'calories': _extractNutrient(food, 'Energy') ?? 0,
            'protein': _extractNutrient(food, 'Protein') ?? 0,
            'carbs': _extractNutrient(food, 'Carbohydrate, by difference') ?? 0,
            'fat': _extractNutrient(food, 'Total lipid (fat)') ?? 0,
            'fiber': _extractNutrient(food, 'Fiber, total dietary') ?? 0,
            'sugar': _extractNutrient(food, 'Sugars, total including NLEA') ?? 0,
          }).toList();
        } else {
          // Nenhum alimento encontrado na API
          print('Nenhum alimento encontrado na API para "$query"');
          return [];
        }
      } else {
        print('Erro na API: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erro ao buscar alimento: $e');
      return [];
    }
  }

  List<Map<String, dynamic>> _searchMockData(String query) {
    final results = <Map<String, dynamic>>[];
    final queryLower = query.toLowerCase();
    
    _mockFoodData.forEach((key, value) {
      if (key.contains(queryLower) || 
          value['name'].toString().toLowerCase().contains(queryLower)) {
        results.add(Map<String, dynamic>.from(value));
      }
    });
    
    return results;
  }

  double? _extractNutrient(Map<String, dynamic> food, String nutrientName) {
    try {
      final nutrients = food['foodNutrients'] as List?;
      if (nutrients == null) return null;
      
      for (final nutrient in nutrients) {
        if (nutrient['nutrientName']?.toString().contains(nutrientName) == true) {
          return (nutrient['value'] as num?)?.toDouble();
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Método para obter sugestões populares
  List<String> getPopularFoods() {
    return _mockFoodData.keys.toList();
  }

  // Método para calcular macros totais
  Map<String, double> calculateTotalMacros(List<Map<String, dynamic>> foods) {
    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;
    double totalFiber = 0;

    for (final food in foods) {
      totalCalories += (food['calories'] as num?)?.toDouble() ?? 0;
      totalProtein += (food['protein'] as num?)?.toDouble() ?? 0;
      totalCarbs += (food['carbs'] as num?)?.toDouble() ?? 0;
      totalFat += (food['fat'] as num?)?.toDouble() ?? 0;
      totalFiber += (food['fiber'] as num?)?.toDouble() ?? 0;
    }

    return {
      'calories': totalCalories,
      'protein': totalProtein,
      'carbs': totalCarbs,
      'fat': totalFat,
      'fiber': totalFiber,
    };
  }
}
