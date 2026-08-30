import 'package:flutter/material.dart';
import 'package:note_app/Funcs/func.dart';
import 'package:note_app/SQL/local_database.dart';
import 'package:note_app/Widgets/note_color_picker.dart';

import '../Data/note_data.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key});

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  int _colorIndex = 0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final content = _bodyController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      showToast('Note is empty');
      return;
    }

    await NotesDatabase().insertData(
      NoteData(
        title: title.isEmpty ? 'Untitled' : title,
        body: content,
        date: DateTime.now().toIso8601String(),
        color: getStrColorFromIndex(_colorIndex),
      ),
    );

    showToast('Note saved');
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final String selectedColorStr = getStrColorFromIndex(_colorIndex);
    final Color surfaceColor = getNoteSurfaceColor(context, selectedColorStr);

    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton.filledTonal(
            tooltip: 'Save note',
            icon: const Icon(Icons.check_rounded, size: 24),
            onPressed: _saveNote,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _titleController,
                      textCapitalization: TextCapitalization.sentences,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Title',
                        hintStyle: theme.textTheme.headlineSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w600,
                        ),
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _bodyController,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: null,
                      minLines: 12,
                      keyboardType: TextInputType.multiline,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.5,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Note details...',
                        hintStyle: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                        ),
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            NoteColorPicker(
              selectedIndex: _colorIndex,
              onColorSelected: (index) => setState(() => _colorIndex = index),
            ),
          ],
        ),
      ),
    );
  }
}


