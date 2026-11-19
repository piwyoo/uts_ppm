class ActivityModel {
  final String id;
  String name;
  String category;
  int counter;
  int target;

  ActivityModel({
    required this.id,
    required this.name,
    this.category = 'Olahraga',
    this.counter = 0,
    this.target = 10,
  });

  double get progress => target > 0 ? (counter / target).clamp(0.0, 1.0) : 0.0;
}
