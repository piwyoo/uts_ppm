import '../data/activity_data.dart';
import '../models/activity_model.dart';

class ActivityRepository {
  final ActivityData _data = ActivityData();

  List<ActivityModel> getAllActivities() {
    return _data.activities;
  }

  void addActivity(ActivityModel activity) {
    _data.activities.add(activity);
  }

  void updateActivity(
    String id,
    String newName,
    String newCategory,
    int newTarget,
  ) {
    final index = _data.activities.indexWhere((item) => item.id == id);
    if (index != -1) {
      _data.activities[index].name = newName;
      _data.activities[index].category = newCategory;
      _data.activities[index].target = newTarget;
    }
  }

  void deleteActivity(String id) {
    _data.activities.removeWhere((item) => item.id == id);
  }

  void updateCounter(String id, int newCounter) {
    final index = _data.activities.indexWhere((item) => item.id == id);
    if (index != -1) {
      _data.activities[index].counter = newCounter;
    }
  }
}
