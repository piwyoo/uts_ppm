import 'package:flutter/material.dart';

import '../viewmodels/activity_viewmodel.dart';

class ActivityDetailView extends StatelessWidget {
  final ActivityViewModel viewModel;
  final String activityId;

  const ActivityDetailView({
    super.key,
    required this.viewModel,
    required this.activityId,
  });

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Reset'),
        content: const Text(
          'Apakah Anda yakin ingin mengatur ulang counter ke 0?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      viewModel.resetCounter(activityId);
      _showSnackBar(context, 'Nilai counter berhasil di-reset ke 0');
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus aktivitas ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      viewModel.deleteActivity(activityId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aktivitas berhasil dihapus')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final activity = viewModel.getActivityById(activityId);

        if (activity == null) {
          return const Scaffold(
            body: Center(child: Text('Aktivitas tidak ditemukan')),
          );
        }

        final catColor = viewModel.getCategoryColor(activity.category);
        final catIcon = viewModel.getCategoryIcon(activity.category);
        final percentage = (activity.progress * 100).toInt();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detail Aktivitas'),
            backgroundColor: catColor,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Hapus Aktivitas',
                onPressed: () => _confirmDelete(context),
              ),
            ],
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Chip(
                    avatar: Icon(catIcon, color: catColor, size: 18),
                    label: Text(
                      activity.category,
                      style: TextStyle(
                        color: catColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: catColor.withOpacity(0.12),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    activity.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Lingkaran Progress & Counter
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          value: activity.progress,
                          strokeWidth: 14,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(catColor),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '${activity.counter}',
                            style: TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                              color: catColor,
                            ),
                          ),
                          Text(
                            'Target: ${activity.target} ($percentage%)',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Tombol Kurang (-) dan Tambah (+)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton.tonalIcon(
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                        onPressed: () {
                          final success = viewModel.decrementCounter(
                            activityId,
                          );
                          if (success) {
                            _showSnackBar(
                              context,
                              'Counter berkurang menjadi ${activity.counter}',
                            );
                          } else {
                            _showSnackBar(
                              context,
                              'Counter tidak boleh kurang dari 0',
                            );
                          }
                        },
                        icon: const Icon(Icons.remove),
                        label: const Text(
                          'Kurang',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 20),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: catColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 16,
                          ),
                        ),
                        onPressed: () {
                          viewModel.incrementCounter(activityId);
                          _showSnackBar(
                            context,
                            'Counter bertambah menjadi ${activity.counter}',
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text(
                          'Tambah',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Tombol Reset
                  OutlinedButton.icon(
                    onPressed: () => _confirmReset(context),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset Counter'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
