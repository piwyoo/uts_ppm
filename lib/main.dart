import 'package:flutter/material.dart';

import 'viewmodels/activity_viewmodel.dart';
import 'views/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ActivityViewModel _viewModel = ActivityViewModel();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Activity Tracker Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: HomeView(viewModel: _viewModel),
    );
  }
}
