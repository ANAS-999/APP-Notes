import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:note_app/Screens/list_note_page.dart';
import 'package:note_app/Screens/settings_page.dart';

import '../Funcs/func.dart';

class HomePage extends StatefulWidget {
  final String appName;
  final String version;

  const HomePage({super.key, required this.appName, required this.version});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //! Variables
  int navBarIndex = 0;
  List<Widget> pages = [];

  //! Functions
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    pages = [
      ListNotePage(appName: widget.appName),
      SettingsPage(appName: widget.appName, version: widget.version),
    ];

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor:
            isDarkMode(context) ? Colors.transparent : Colors.transparent,
        statusBarIconBrightness:
            isDarkMode(context) ? Brightness.light : Brightness.dark,
      ),
    );

    return Scaffold(
      //! Pages
      body: SafeArea(child: pages[navBarIndex]),

      //! Navigation Bar
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: isDarkMode(context)
              ? theme.colorScheme.primary
              : Colors.blue.shade100,
        ),
        child: NavigationBar(
          height: 60,
          selectedIndex: navBarIndex,
          backgroundColor: isDarkMode(context)
              ? const Color(0xFF27273B)
              : const Color(0xFFf1f5fb),
          onDestinationSelected: (value) => setState(() => navBarIndex = value),
          destinations: const [
            NavigationDestination(
              label: 'Notes',
              icon: Icon(CupertinoIcons.book),
              selectedIcon: Icon(CupertinoIcons.book_fill),
            ),
            NavigationDestination(
              label: 'Settings',
              icon: Icon(CupertinoIcons.settings),
              selectedIcon: Icon(CupertinoIcons.settings),
            ),
          ],
        ),
      ),
    );
  }
}
