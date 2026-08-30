import 'package:flutter/material.dart';
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
  int navBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    final dark = isDarkMode(context);
    final colorScheme = Theme.of(context).colorScheme;

    print(Theme.of(context).scaffoldBackgroundColor);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness:
            dark ? Brightness.light : Brightness.dark,
      ),
    );

    final pages = [
      ListNotePage(appName: widget.appName),
      SettingsPage(appName: widget.appName, version: widget.version),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth >= 640;

        if (isWideScreen) {
          return Scaffold(
            body: SafeArea(
              child: Row(
                children: [
                  NavigationRail(
                    selectedIndex: navBarIndex,
                    onDestinationSelected: (value) =>
                        setState(() => navBarIndex = value),
                    labelType: NavigationRailLabelType.all,
                    leading: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit_note_rounded,
                          color: colorScheme.onPrimaryContainer,
                          size: 26,
                        ),
                      ),
                    ),
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.sticky_note_2_outlined),
                        selectedIcon: Icon(Icons.sticky_note_2_rounded),
                        label: Text('Notes'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings_outlined),
                        selectedIcon: Icon(Icons.settings_rounded),
                        label: Text('Settings'),
                      ),
                    ],
                  ),
                  const VerticalDivider(thickness: 1, width: 1),
                  Expanded(
                    child: IndexedStack(
                      index: navBarIndex,
                      children: pages,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: IndexedStack(
              index: navBarIndex,
              children: pages,
            ),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: navBarIndex,
            onDestinationSelected: (value) =>
                setState(() => navBarIndex = value),
            destinations: const [
              NavigationDestination(
                label: 'Notes',
                icon: Icon(Icons.sticky_note_2_outlined),
                selectedIcon: Icon(Icons.sticky_note_2_rounded),
              ),
              NavigationDestination(
                label: 'Settings',
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings_rounded),
              ),
            ],
          ),
        );
      },
    );
  }
}
