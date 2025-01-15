import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/Data/note_data.dart';

import '../Funcs/func.dart';
import '../SQL/local_database.dart';

class NotePage extends StatefulWidget {
  final NoteData note;

  const NotePage({super.key, required this.note});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  //! Variables
  String title = 'Title';
  bool inEditMode = false;
  FocusNode focusNodeNote = FocusNode();
  FocusNode focusNodeNewTitle = FocusNode();

  final TextEditingController lineNote = TextEditingController();
  final TextEditingController lineNewTitle = TextEditingController();

  //! Functions
  onDeleteClick() {
    showAlertDialog(
      context,
      title: 'Delete Note',
      buttonText: 'Delete',
      content: 'Are you sure you want to delete this note?',
      onConfirm: () {
        Navigator.pop(context);
        NotesDatabase().deleteData(widget.note);
        Navigator.pop(context);
      },
    );
  }

  onCheckClick() {
    if (lineNote.text.isEmpty) {
      showSnackBar(context, 'Note cannot be empty!');
      return;
    }

    if (lineNote.text == widget.note.body) {
      setState(() => inEditMode = false);
      return;
    }

    showAlertDialog(
      context,
      title: 'Update Note',
      buttonText: 'Update',
      content: 'Are you sure you want to update this note?',
      onConfirm: () {
        NoteData data = widget.note.copyWith(body: lineNote.text);
        NotesDatabase().updateData(data);
        Navigator.pop(context);

        setState(() => inEditMode = false);
      },
    );
  }

  onEditClick() {
    setState(() {
      inEditMode = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNodeNote.requestFocus();
    });
  }

  onTitleClick() {
    if (inEditMode) {
      return;
    }

    final theme = Theme.of(context);

    lineNewTitle.text = title;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNodeNewTitle.requestFocus();
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Title'),
          content: Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(40),
            ),
            child: TextField(
              controller: lineNewTitle,
              focusNode: focusNodeNewTitle,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                hintText: 'New Title',
                border: InputBorder.none,
                prefixIcon: const Icon(CupertinoIcons.book),
                prefixIconColor: theme.textTheme.bodySmall!.color,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: onUpdateTitle,
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  onBackClick() {
    if (inEditMode) {
      setState(() => inEditMode = false);
      lineNote.text = widget.note.body;

      return;
    }

    Navigator.pop(context);
  }

  onUpdateTitle() {
    if (lineNewTitle.text.isEmpty) {
      showSnackBar(context, 'Title cannot be empty!');
      return;
    }

    if (lineNewTitle.text == title) {
      Navigator.pop(context);
      return;
    }

    NoteData data = widget.note.copyWith(title: lineNewTitle.text);
    NotesDatabase().updateData(data);
    Navigator.pop(context);

    setState(() {
      title = lineNewTitle.text;
    });
  }

  @override
  void initState() {
    super.initState();

    title = widget.note.title;
    lineNote.text = widget.note.body;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              //! Wave Background
              ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black,
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.05, 0.87],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: RotationTransition(
                  turns: const AlwaysStoppedAnimation(180 / 360),
                  child: Opacity(
                    opacity: 0.2,
                    child: Container(
                      child: showSvg(
                        'wave',
                        width: null,
                        height: height,
                        fit: BoxFit.cover,
                        color: listColors[getIndexColorFromStr(
                          widget.note.color,
                        )],
                      ),
                    ),
                  ),
                ),
              ),

              //! Page Content
              Column(
                children: [
                  spaceV(12),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.cardColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      maxLines: null,
                      enabled: inEditMode,
                      controller: lineNote,
                      focusNode: focusNodeNote,
                      keyboardType: TextInputType.text,
                      style: theme.textTheme.bodyLarge,
                      decoration: InputDecoration(
                        hintText: 'Note...',
                        border: InputBorder.none,
                        hintStyle: theme.textTheme.bodySmall,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget appBar() {
    final theme = Theme.of(context);

    return AppBar(
      title: GestureDetector(
        onTap: onTitleClick,
        child: Text(title.capitalize()),
      ),
      leading: IconButton(
        onPressed: onBackClick,
        icon: showSvg('back', color: theme.iconTheme.color),
      ),
      actions: [
        Visibility(
          visible: !inEditMode,
          child: IconButton(
            onPressed: onEditClick,
            icon: const Icon(CupertinoIcons.pen),
          ),
        ),
        Visibility(
          visible: !inEditMode,
          child: IconButton(
            onPressed: onDeleteClick,
            iconSize: 20,
            icon: const Icon(CupertinoIcons.trash),
          ),
        ),
        Visibility(
          visible: inEditMode,
          child: IconButton(
            onPressed: onCheckClick,
            icon: const Icon(CupertinoIcons.checkmark),
          ),
        ),
      ],
    );
  }
}
