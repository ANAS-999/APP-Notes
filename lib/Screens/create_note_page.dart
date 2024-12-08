import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/Funcs/func.dart';
import 'package:note_app/SQL/local_database.dart';

import '../Data/note_data.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key});

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  //! Variables
  int colorIndex = 0;
  final List<Color> listColors = [
    Colors.blueAccent,
    Colors.indigoAccent,
    Colors.red,
    Colors.green.shade600,
  ];
  final lineTitle = TextEditingController();
  final lineContent = TextEditingController();

  //! Functions
  onSaveNote() {
    String title = lineTitle.text;
    String content = lineContent.text;

    if (title.isNotEmpty && content.isNotEmpty) {
      NotesDatabase().insertData(
        NoteData(
          title: title,
          body: content,
          date: DateTime.now().toString(),
          color: '0xFF3A424D',
        ),
      );

      showToast('Note saved');
      Navigator.pop(context);
    } else {
      showToast('Please fill all fields');
    }
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
                        color: listColors[colorIndex],
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  spaceV(16),

                  //! Title
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      maxLines: 1,
                      controller: lineTitle,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Title',
                        hintStyle: theme.textTheme.bodySmall,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(top: 11),
                        prefixIcon: const Icon(CupertinoIcons.book_fill),
                        prefixIconColor: theme.textTheme.bodySmall!.color,
                      ),
                    ),
                  ),

                  spaceV(16),

                  //! Color
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        colorWidget(0, Colors.blueAccent),
                        colorWidget(1, Colors.indigoAccent),
                        colorWidget(2, Colors.red),
                        colorWidget(3, Colors.green.shade600),
                      ],
                    ),
                  ),

                  spaceV(16),

                  //! Content
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      minLines: 5,
                      maxLines: null,
                      controller: lineContent,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: 'Details',
                        border: InputBorder.none,
                        hintStyle: theme.textTheme.bodySmall,
                      ),
                    ),
                  ),

                  spaceV(16),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onSaveNote,
        backgroundColor: listColors[colorIndex],
        child: Icon(
          Icons.check,
          color: isDarkMode(context) ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  PreferredSizeWidget appBar() {
    final theme = Theme.of(context);

    return AppBar(
      centerTitle: true,
      title: const Text('Create Note'),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: showSvg('back', color: theme.iconTheme.color),
      ),
    );
  }

  Widget colorWidget(int index, Color color) {
    //final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => setState(() => colorIndex = index),
      child: Container(
        height: 32,
        width: 44,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: Colors.black.withOpacity(0.5),
            width: index == colorIndex ? 4 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
