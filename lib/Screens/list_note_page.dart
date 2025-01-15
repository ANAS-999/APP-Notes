import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/Data/note_data.dart';
import 'package:note_app/Screens/note_page.dart';

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
  //! Variables
  bool inSelectMode = false;
  List<bool> listSelected = [];
  List<NoteData> listNotes = [];

  //! Functions
  getNotes() async {
    await NotesDatabase().readData().then(
          (onValue) => {
            setState(() {
              listNotes = onValue;
              listSelected = List.generate(listNotes.length, (index) => false);
            })
          },
        );
  }

  onNoteClick(NoteData note) {
    if (inSelectMode) {
      int index = listNotes.indexOf(note);

      setState(() {
        listSelected[index] = !listSelected[index];
      });
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotePage(note: note)),
    ).then((value) => getNotes());
  }

  onNoteLongClick(NoteData note) {
    int index = listNotes.indexOf(note);

    setState(() {
      inSelectMode = true;
      listSelected[index] = !listSelected[index];
    });
  }

  onActionButtonClick() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateNotePage()),
    ).then((value) => getNotes());
  }

  onDeleteNotesClick() {
    if (getNumberSelected() == 0) {
      showToast('No notes selected!');
      return;
    }

    showAlertDialog(
      context,
      title: 'Delete Notes',
      content: 'Are you sure you want to delete the selected notes?',
      buttonText: 'Delete',
      onConfirm: () {
        for (int i = 0; i < listSelected.length; i++) {
          if (listSelected[i]) {
            NotesDatabase().deleteData(listNotes[i]);
          }
        }

        setState(() {
          inSelectMode = false;
          listSelected = List.generate(listNotes.length, (index) => false);
          getNotes();
        });

        Navigator.of(context).pop();
      },
    );
  }

  int getNumberSelected() {
    int count = 0;
    for (bool selected in listSelected) {
      if (selected) count++;
    }
    return count;
  }

  @override
  void initState() {
    getNotes();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: inSelectMode ? appBarInSelectedMode() : appBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: listNotes.length,
                  itemBuilder: noteWidget,
                  physics: const NeverScrollableScrollPhysics(),
                ),
                spaceV(),
              ],
            ),
          ),

          //! Empty Note
          Visibility(
            visible: listNotes.isEmpty,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.doc,
                    size: 64,
                  ),
                  spaceV(8),
                  Text(
                    'No Notes',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      //! Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: onActionButtonClick,
        child: Icon(
          CupertinoIcons.pencil_outline,
          color: isDarkMode(context) ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      centerTitle: true,
      title: Text(widget.appName),
    );
  }

  PreferredSizeWidget appBarInSelectedMode() {
    return AppBar(
      centerTitle: true,
      title: Text('Selected Notes ${getNumberSelected()}'),
      leading: IconButton(
        onPressed: () {
          setState(() {
            inSelectMode = false;
            listSelected = List.generate(listNotes.length, (index) => false);
          });
        },
        icon: const Icon(CupertinoIcons.xmark),
      ),
      actions: [
        IconButton(
          onPressed: onDeleteNotesClick,
          icon: const Icon(CupertinoIcons.trash, size: 20),
        ),
      ],
    );
  }

  Widget noteWidget(BuildContext context, int index) {
    final theme = Theme.of(context);
    final NoteData note = listNotes[index];
    final screenWidth = MediaQuery.of(context).size.width;
    final color = listColors[getIndexColorFromStr(note.color)];

    return Container(
      height: 64,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: inSelectMode && listSelected[index]
            ? theme.cardColor.withOpacity(0.3)
            : theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          //! Wave Background
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      //theme.cardColor,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.transparent,
                      color.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
              ClipRect(
                child: Transform.rotate(
                  angle: -50 * 3.1415927 / 180,
                  child: Container(
                    height: 100,
                    width: 200,
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: inSelectMode && listSelected[index]
                          ? theme.cardColor.withOpacity(0.3)
                          : theme.cardColor,
                      //color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),

          //! Note Content
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onNoteClick(note),
              onLongPress: () => onNoteLongClick(note),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title.capitalize(),
                      overflow: TextOverflow.fade,
                      style: theme.textTheme.titleMedium,
                    ),
                    spaceV(4),
                    SizedBox(
                      width: screenWidth * 0.7,
                      child: Text(
                        maxLines: 1,
                        note.body,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Visibility(
            visible: inSelectMode,
            child: Container(
              alignment: Alignment.centerRight,
              width: double.infinity,
              height: double.infinity,
              child: Checkbox(
                value: listSelected[index],
                onChanged: (value) {
                  setState(() {
                    listSelected[index] = value!;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
