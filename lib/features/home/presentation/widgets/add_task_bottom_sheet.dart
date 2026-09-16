import 'package:flutter/material.dart';

/// The values collected by the add-task form.
class AddTaskData {
  const AddTaskData({required this.title, required this.category});

  final String title;
  final String category;
}

/// Presents the form used to create a task from the Home screen.
class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  static Future<AddTaskData?> show(BuildContext context) {
    return showModalBottomSheet<AddTaskData>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddTaskBottomSheet(),
    );
  }

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  static const _surface = Color(0xFFFFFEFC);
  static const _ink = Color(0xFF17302C);
  static const _muted = Color(0xFF6C7D78);
  static const _emerald = Color(0xFF0F766E);
  static const _line = Color(0xFFDDE6DF);

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _addTask() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    Navigator.of(context).pop(
      AddTaskData(
        title: _titleController.text.trim(),
        category: _categoryController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(24, 12, 24, 24 + bottomInset),
      decoration: const BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _line,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Add a new task',
                style: TextStyle(
                  color: _ink,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Give your next step a clear beginning.',
                style: TextStyle(color: _muted, fontSize: 14),
              ),
              const SizedBox(height: 22),
              TextFormField(
                controller: _titleController,
                autofocus: true,
                textInputAction: TextInputAction.next,
                decoration: _decoration('Task title', Icons.edit_note_rounded),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter a task title'
                    : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _categoryController,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _addTask(),
                decoration: _decoration(
                  'Category',
                  Icons.sell_outlined,
                  hintText: 'e.g. Planning',
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter a category'
                    : null,
              ),
              const SizedBox(height: 22),
              FilledButton.icon(
                onPressed: _addTask,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add task'),
                style: FilledButton.styleFrom(
                  backgroundColor: _emerald,
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static InputDecoration _decoration(
    String label,
    IconData icon, {
    String? hintText,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      prefixIcon: Icon(icon, color: _muted),
      filled: true,
      fillColor: const Color(0xFFF7F9F6),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: _line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: _line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: _emerald, width: 1.5),
      ),
    );
  }
}
