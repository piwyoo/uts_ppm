import 'package:flutter/material.dart';

import '../models/activity_model.dart';
import '../viewmodels/activity_viewmodel.dart';

class ActivityFormView extends StatefulWidget {
  final ActivityViewModel viewModel;
  final ActivityModel? activity;

  const ActivityFormView({super.key, required this.viewModel, this.activity});

  @override
  State<ActivityFormView> createState() => _ActivityFormViewState();
}

class _ActivityFormViewState extends State<ActivityFormView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _targetController;
  String _selectedCategory = 'Olahraga';

  final List<String> _categories = [
    'Olahraga',
    'Belajar',
    'Kesehatan',
    'Lainnya',
  ];

  bool get isEditMode => widget.activity != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: isEditMode ? widget.activity!.name : '',
    );
    _targetController = TextEditingController(
      text: isEditMode ? widget.activity!.target.toString() : '10',
    );
    if (isEditMode) {
      _selectedCategory = widget.activity!.category;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final target = int.tryParse(_targetController.text) ?? 10;

      if (isEditMode) {
        widget.viewModel.updateActivity(
          widget.activity!.id,
          name,
          _selectedCategory,
          target,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aktivitas berhasil diperbarui')),
        );
      } else {
        widget.viewModel.addActivity(name, _selectedCategory, target);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aktivitas baru berhasil ditambahkan')),
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Aktivitas' : 'Tambah Aktivitas'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Aktivitas',
                  hintText: 'Contoh: Jogging Pagi, Baca Buku',
                  prefixIcon: const Icon(Icons.edit_note),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama aktivitas tidak boleh kosong!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Kategori Aktivitas',
                  prefixIcon: const Icon(Icons.category_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedCategory = val);
                  }
                },
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _targetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Target Hitungan',
                  hintText: 'Contoh: 10',
                  prefixIcon: const Icon(Icons.flag_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  final number = int.tryParse(value ?? '');
                  if (number == null || number <= 0) {
                    return 'Masukkan angka target lebih dari 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: _saveForm,
                icon: const Icon(Icons.save),
                label: const Text(
                  'Simpan Aktivitas',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
