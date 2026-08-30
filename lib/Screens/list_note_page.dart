import 'package:flutter/material.dart';
import 'package:note_app/Data/note_data.dart';
import 'package:note_app/Screens/note_page.dart';
import 'package:note_app/Widgets/note_card.dart';

import '../Funcs/func.dart';
import '../SQL/local_database.dart';
import 'create_note_page.dart';

class ListNotePage extends StatefulWidget {
  final String appName;
  const ListNotePage({super.key, required this.appName});

  @override
  State<ListNotePage> createState() => _ListNotePageState();
}

class _ListNotePageState extends State<ListNotePage> {
  final Set<int> _selectedNoteIds = {};
  bool _inSelectMode = false;
  List<NoteData> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await NotesDatabase().readData();
    if (!mounted) return;
    setState(() {
      _notes = notes;
      _isLoading = false;
    });
  }

  void _onNoteClick(NoteData note) {
    if (_inSelectMode) {
      if (note.id == null) return;
      setState(() {
        if (_selectedNoteIds.contains(note.id)) {
          _selectedNoteIds.remove(note.id);
          if (_selectedNoteIds.isEmpty) {
            _inSelectMode = false;
          }
        } else {
          _selectedNoteIds.add(note.id!);
        }
      });
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotePage(note: note)),
    ).then((_) => _loadNotes());
  }

  void _onNoteLongClick(NoteData note) {
    if (note.id == null) return;
    setState(() {
      _inSelectMode = true;
      _selectedNoteIds.add(note.id!);
    });
  }

  void _toggleSelectAll() {
    setState(() {
      if (_selectedNoteIds.length == _notes.length) {
        _selectedNoteIds.clear();
        _inSelectMode = false;
      } else {
        _selectedNoteIds
            .addAll(_notes.where((n) => n.id != null).map((n) => n.id!));
      }
    });
  }

  void _onDeleteSelected() {
    final count = _selectedNoteIds.length;
    if (count == 0) {
      showToast('No notes selected');
      return;
    }

    showAlertDialog(
      context,
      title: 'Delete $count ${count == 1 ? 'note' : 'notes'}?',
      content: 'These notes will be permanently removed from your device.',
      buttonText: 'Delete',
      onConfirm: () async {
        Navigator.of(context).pop();
        await NotesDatabase().deleteMultiple(_selectedNoteIds.toList());

        if (!mounted) return;
        setState(() {
          _inSelectMode = false;
          _selectedNoteIds.clear();
        });
        _loadNotes();
      },
    );
  }

  void _onCreateNote() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateNotePage()),
    ).then((_) => _loadNotes());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          if (_inSelectMode)
            SliverAppBar(
              pinned: true,
              backgroundColor: colorScheme.surfaceContainerHighest,
              surfaceTintColor: colorScheme.surfaceTint,
              scrolledUnderElevation: 3.0,
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    _inSelectMode = false;
                    _selectedNoteIds.clear();
                  });
                },
                icon: const Icon(Icons.close_rounded),
              ),
              title: Text(
                '${_selectedNoteIds.length} selected',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [
                IconButton(
                  tooltip: 'Select all',
                  onPressed: _toggleSelectAll,
                  icon: const Icon(Icons.select_all_rounded),
                ),
                IconButton(
                  tooltip: 'Delete',
                  onPressed: _onDeleteSelected,
                  icon: const Icon(Icons.delete_outline_rounded),
                ),
                const SizedBox(width: 4),
              ],
            )
          else
            SliverAppBar.large(
              title: Text(
                widget.appName,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              surfaceTintColor: colorScheme.surfaceTint,
              scrolledUnderElevation: 0.0,
              actions: [
                if (_notes.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Center(
                      child: Badge(
                        backgroundColor: colorScheme.secondaryContainer,
                        textColor: colorScheme.onSecondaryContainer,
                        label: Text('${_notes.length}'),
                      ),
                    ),
                  ),
              ],
            ),
          if (!_isLoading && _notes.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildEmptyState(context),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final note = _notes[index];
                    final isSelected =
                        note.id != null && _selectedNoteIds.contains(note.id);
                    return NoteCard(
                      note: note,
                      isSelected: isSelected,
                      inSelectMode: _inSelectMode,
                      onTap: () => _onNoteClick(note),
                      onLongPress: () => _onNoteLongClick(note),
                      onSelectChanged: (val) => _onNoteClick(note),
                    );
                  },
                  childCount: _notes.length,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 2,
        onPressed: _onCreateNote,
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.note_alt_outlined,
                size: 56,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No notes yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the button below to write your first note',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
