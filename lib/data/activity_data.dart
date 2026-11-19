import '../models/activity_model.dart';

class ActivityData {
  // Penyimpanan data sementara menggunakan List selama aplikasi berjalan
  final List<ActivityModel> _activities = [
    ActivityModel(
      id: '1',
      name: 'Push Up Pagi',
      category: 'Olahraga',
      counter: 15,
      target: 30,
    ),
    ActivityModel(
      id: '2',
      name: 'Membaca Buku (Halaman)',
      category: 'Belajar',
      counter: 12,
      target: 20,
    ),
    ActivityModel(
      id: '3',
      name: 'Minum Air Putih (Gelas)',
      category: 'Kesehatan',
      counter: 6,
      target: 8,
    ),
  ];

  List<ActivityModel> get activities => _activities;
}
