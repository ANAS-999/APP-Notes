import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/Data/note_data.dart';

import '../Funcs/func.dart';

class NotePage extends StatefulWidget {
  final NoteData note;

  const NotePage({super.key, required this.note});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
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
                        color: listColors[1],
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
                    child: Text(widget.note.body),
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
      title: Text(widget.note.title),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: showSvg('back', color: theme.iconTheme.color),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(CupertinoIcons.pen),
        ),
        IconButton(
          onPressed: () {},
          iconSize: 20,
          icon: const Icon(CupertinoIcons.trash),
        ),
      ],
    );
  }
}
