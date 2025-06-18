import 'package:flutter/material.dart';

class Workout {
  final String id;
  final String name;
  final String description;
  final int duration; // em minutos
  final String difficulty; // 'Iniciante', 'Intermediário', 'Avançado'
  final List<Exercise> exercises;
  final String category; // 'Cardio', 'Força', 'Flexibilidade', 'HIIT'
  final DateTime? completedAt;

  Workout({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.difficulty,
    required this.exercises,
    required this.category,
    this.completedAt,
  });

  Workout copyWith({
    String? id,
    String? name,
    String? description,
    int? duration,
    String? difficulty,
    List<Exercise>? exercises,
    String? category,
    DateTime? completedAt,
  }) {
    return Workout(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      difficulty: difficulty ?? this.difficulty,
      exercises: exercises ?? this.exercises,
      category: category ?? this.category,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

class Exercise {
  final String name;
  final int sets;
  final int reps;
  final int? restSeconds;
  final String? notes;

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    this.restSeconds,
    this.notes,
  });
}

class WorkoutProvider with ChangeNotifier {
  List<Workout> _workouts = [];
  List<Workout> _completedWorkouts = [];

  List<Workout> get workouts => _workouts;
  List<Workout> get completedWorkouts => _completedWorkouts;

  int get totalWorkoutsThisMonth => _completedWorkouts
      .where((w) =>
          w.completedAt != null &&
          w.completedAt!.month == DateTime.now().month &&
          w.completedAt!.year == DateTime.now().year)
      .length;

  int get currentStreak {
    if (_completedWorkouts.isEmpty) return 0;

    final sortedWorkouts = _completedWorkouts
        .where((w) => w.completedAt != null)
        .toList()
      ..sort((a, b) => b.completedAt!.compareTo(a.completedAt!));

    int streak = 0;
    DateTime? lastDate;

    for (final workout in sortedWorkouts) {
      final workoutDate = DateTime(
        workout.completedAt!.year,
        workout.completedAt!.month,
        workout.completedAt!.day,
      );

      if (lastDate == null) {
        lastDate = workoutDate;
        streak = 1;
      } else {
        final difference = lastDate.difference(workoutDate).inDays;
        if (difference == 1) {
          streak++;
          lastDate = workoutDate;
        } else {
          break;
        }
      }
    }

    return streak;
  }

  WorkoutProvider() {
    _loadMockWorkouts();
  }

  void _loadMockWorkouts() {
    _workouts = [
      Workout(
        id: '1',
        name: 'Treino HIIT 30 min',
        description: 'Treino de alta intensidade para queima de gordura',
        duration: 30,
        difficulty: 'Intermediário',
        category: 'HIIT',
        exercises: [
          Exercise(name: 'Burpees', sets: 3, reps: 10, restSeconds: 30),
          Exercise(
              name: 'Mountain Climbers', sets: 3, reps: 20, restSeconds: 30),
          Exercise(name: 'Jump Squats', sets: 3, reps: 15, restSeconds: 30),
          Exercise(name: 'High Knees', sets: 3, reps: 30, restSeconds: 30),
        ],
      ),
      Workout(
        id: '2',
        name: 'Yoga para iniciantes',
        description: 'Sequência relaxante para flexibilidade e bem-estar',
        duration: 45,
        difficulty: 'Iniciante',
        category: 'Flexibilidade',
        exercises: [
          Exercise(name: 'Saudação ao Sol', sets: 1, reps: 5, restSeconds: 10),
          Exercise(
              name: 'Postura do Guerreiro', sets: 1, reps: 1, restSeconds: 30),
          Exercise(
              name: 'Postura da Criança', sets: 1, reps: 1, restSeconds: 60),
          Exercise(name: 'Postura do Cão', sets: 1, reps: 1, restSeconds: 30),
        ],
      ),
      Workout(
        id: '3',
        name: 'Força - Parte Superior',
        description: 'Treino focado em braços, peito e costas',
        duration: 60,
        difficulty: 'Avançado',
        category: 'Força',
        exercises: [
          Exercise(name: 'Flexões', sets: 4, reps: 12, restSeconds: 60),
          Exercise(name: 'Pull-ups', sets: 4, reps: 8, restSeconds: 90),
          Exercise(name: 'Dips', sets: 3, reps: 10, restSeconds: 60),
          Exercise(name: 'Pike Push-ups', sets: 3, reps: 8, restSeconds: 60),
        ],
      ),
    ];

    // Adicionar alguns treinos completados para demonstração
    _completedWorkouts = [
      _workouts[0].copyWith(
          completedAt: DateTime.now().subtract(const Duration(days: 1))),
      _workouts[1].copyWith(
          completedAt: DateTime.now().subtract(const Duration(days: 2))),
      _workouts[0].copyWith(
          completedAt: DateTime.now().subtract(const Duration(days: 3))),
    ];

    notifyListeners();
  }

  void addWorkout(Workout workout) {
    _workouts.add(workout);
    notifyListeners();
  }

  void completeWorkout(String workoutId) {
    final workout = _workouts.firstWhere((w) => w.id == workoutId);
    final completedWorkout = workout.copyWith(completedAt: DateTime.now());
    _completedWorkouts.add(completedWorkout);
    notifyListeners();
  }

  void removeWorkout(String workoutId) {
    _workouts.removeWhere((w) => w.id == workoutId);
    notifyListeners();
  }

  List<Workout> getWorkoutsByCategory(String category) {
    return _workouts.where((w) => w.category == category).toList();
  }

  List<Workout> getWorkoutsByDifficulty(String difficulty) {
    return _workouts.where((w) => w.difficulty == difficulty).toList();
  }
}
