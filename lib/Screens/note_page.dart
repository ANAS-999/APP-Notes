import 'package:flutter/material.dart';
import 'package:note_app/Data/note_data.dart';
import 'package:note_app/Widgets/note_color_picker.dart';

import '../Funcs/func.dart';
import '../SQL/local_database.dart';

class NotePage extends StatefulWidget {
  final NoteData note;

  const NotePage({super.key, required this.note});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late NoteData _currentNote;
  bool _inEditMode = false;
  final FocusNode _bodyFocusNode = FocusNode();
  final FocusNode _titleFocusNode = FocusNode();

  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _currentNote = widget.note;
    _titleController = TextEditingController(text: _currentNote.title);
    _bodyController = TextEditingController(text: _currentNote.body);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _bodyFocusNode.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  void _onDeleteClick() {
    showAlertDialog(
      context,
      title: 'Delete Note?',
      buttonText: 'Delete',
      content: 'This note will be permanently deleted.',
      onConfirm: () async {
        Navigator.pop(context);
        await NotesDatabase().deleteData(_currentNote);
        if (!mounted) return;
        Navigator.pop(context);
      },
    );
  }

  Future<void> _onSaveClick() async {
    final newTitle = _titleController.text.trim();
    final newBody = _bodyController.text.trim();

    if (newTitle.isEmpty && newBody.isEmpty) {
      showToast('Note cannot be empty');
      return;
    }

    final updatedNote = _currentNote.copyWith(
      title: newTitle.isEmpty ? 'Untitled' : newTitle,
      body: newBody,
    );

    await NotesDatabase().updateData(updatedNote);

    if (!mounted) return;
    setState(() {
      _currentNote = updatedNote;
      _inEditMode = false;
    });
    showToast('Note updated');
  }

  void _onEditClick() {
    setState(() {
      _inEditMode = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bodyFocusNode.requestFocus();
    });
  }

  void _onBackClick() {
    if (_inEditMode) {
      setState(() {
        _inEditMode = false;
        _titleController.text = _currentNote.title;
        _bodyController.text = _currentNote.body;
      });
      return;
    }
    Navigator.pop(context);
  }

  Future<void> _changeNoteColor(int index) async {
    final newColor = getStrColorFromIndex(index);
    final updatedNote = _currentNote.copyWith(color: newColor);
    await NotesDatabase().updateData(updatedNote);
    if (!mounted) return;
    setState(() {
      _currentNote = updatedNote;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final Color surfaceColor = getNoteSurfaceColor(context, _currentNote.color);

    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _onBackClick,
        ),
        actions: [
          if (!_inEditMode) ...[
            IconButton(
              tooltip: 'Edit note',
              icon: const Icon(Icons.edit_outlined),
              onPressed: _onEditClick,
            ),
            IconButton(
              tooltip: 'Delete note',
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: _onDeleteClick,
            ),
          ] else ...[
            IconButton.filledTonal(
              tooltip: 'Save changes',
              icon: const Icon(Icons.check_rounded, size: 24),
              onPressed: _onSaveClick,
            ),
          ],
          const SizedBox(width: 8),
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
                      focusNode: _titleFocusNode,
                      enabled: _inEditMode,
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
                        disabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 14,
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          formatNoteDate(_currentNote.date),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _bodyController,
                      focusNode: _bodyFocusNode,
                      enabled: _inEditMode,
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
                        disabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_inEditMode)
              NoteColorPicker(
                selectedIndex: getIndexColorFromStr(_currentNote.color),
                onColorSelected: _changeNoteColor,
              ),
          ],
        ),
      ),
    );
  }
}


