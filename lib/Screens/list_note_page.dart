import 'package:flutter/material.dart';
import 'package:note_app/Data/note_data.dart';
import 'package:note_app/Screens/note_page.dart';

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
    final NoteData note = listNotes[index];
    final screenWidth = MediaQuery.of(context).size.width;
    final color = listColors[getIndexColorFromStr(note.color)];

    return Container(
      height: 64,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotePage(note: note),
            ),
          ),
          borderRadius: BorderRadius.circular(12),
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
                          theme.cardColor,
                          theme.cardColor,
                          theme.cardColor,
                          theme.cardColor,
                          color.withOpacity(0.7),
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
                          color: theme.cardColor,
                          //color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              //! Note Content
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
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
            ],
          ),
        ),
      ),
    );
  }
}
