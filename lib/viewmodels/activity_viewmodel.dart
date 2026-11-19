import 'package:flutter/material.dart';

import '../models/activity_model.dart';
import '../repositories/activity_repository.dart';

class ActivityViewModel extends ChangeNotifier {
  final ActivityRepository _repository = ActivityRepository();

  List<ActivityModel> get activities => _repository.getAllActivities();

  int get totalActivities => activities.length;

  int get totalAllCounters =>
      activities.fold(0, (sum, item) => sum + item.counter);

  ActivityModel? getActivityById(String id) {
    try {
      return activities.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  void addActivity(String name, String category, int target) {
    final newActivity = ActivityModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
      category: category,
      counter: 0,
      target: target > 0 ? target : 10,
    );
    _repository.addActivity(newActivity);
    notifyListeners();
  }

  void updateActivity(
    String id,
    String newName,
    String newCategory,
    int newTarget,
  ) {
    _repository.updateActivity(
      id,
      newName.trim(),
      newCategory,
      newTarget > 0 ? newTarget : 10,
    );
    notifyListeners();
  }

  void deleteActivity(String id) {
    _repository.deleteActivity(id);
    notifyListeners();
  }

  void incrementCounter(String id) {
    final activity = getActivityById(id);
    if (activity != null) {
      _repository.updateCounter(id, activity.counter + 1);
      notifyListeners();
    }
  }

  bool decrementCounter(String id) {
    final activity = getActivityById(id);
    // Aturan: Nilai counter tidak boleh kurang dari 0
    if (activity != null && activity.counter > 0) {
      _repository.updateCounter(id, activity.counter - 1);
      notifyListeners();
      return true;
    }
    return false;
  }

  void resetCounter(String id) {
    _repository.updateCounter(id, 0);
    notifyListeners();
  }

  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Olahraga':
        return Icons.fitness_center;
      case 'Belajar':
        return Icons.menu_book_rounded;
      case 'Kesehatan':
        return Icons.favorite_rounded;
      default:
        return Icons.task_alt_rounded;
    }
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case 'Olahraga':
        return Colors.orange;
      case 'Belajar':
        return Colors.indigo;
      case 'Kesehatan':
        return Colors.teal;
      default:
        return Colors.purple;
    }
  }
}
