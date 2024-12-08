import 'package:flutter/material.dart';
import 'package:note_app/Data/note_data.dart';

import '../Funcs/func.dart';
import '../SQL/local_database.dart';

class ListNotePage extends StatefulWidget {
  final String appName;
  const ListNotePage({super.key, required this.appName});

  @override
  State<ListNotePage> createState() => _ListNotePageState();
}

class _ListNotePageState extends State<ListNotePage> {
  //! Variables
  List<NoteData> listNotes = [];

  //! Functions
  getNotes() async {
    await NotesDatabase().readData().then((onValue) => {
          setState(() {
            listNotes = onValue;
          })
        });
  }

  @override
  void initState() {
    getNotes();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: listNotes.length,
              itemBuilder: noteWidget,
            ),
          ],
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

  Widget noteWidget(BuildContext context, int index) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            listNotes[index].title,
            style: theme.textTheme.titleMedium,
          ),
          spaceV(4),
          Text(
            maxLines: 1,
            listNotes[index].body,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
