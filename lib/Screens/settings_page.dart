import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../Funcs/func.dart';

class SettingsPage extends StatefulWidget {
  final String appName;
  final String version;

  const SettingsPage({
    super.key,
    required this.appName,
    required this.version,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //! AppBar
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 22,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ListTile(
                  title: const Text('Theme Mode'),
                  subtitle: Text(
                    'Dark, light or system mode.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  iconColor: Theme.of(context).iconTheme.color,
                  leading: const Icon(size: 30, CupertinoIcons.settings),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onTap: () => showDialogTheme(context),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ListTile(
                  title: const Text('About us'),
                  subtitle: Text(
                    'App version, created by...',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  iconColor: Theme.of(context).iconTheme.color,
                  leading: const Icon(size: 30, CupertinoIcons.info),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onTap: () =>
                      showDialogAbout(widget.appName, widget.version, context),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ListTile(
                  title: const Text('Check for updates'),
                  subtitle: Text(
                    'Get the latest updates with many features.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  iconColor: Theme.of(context).iconTheme.color,
                  leading: const Icon(size: 30, CupertinoIcons.upload_circle),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  onTap: () {
                    showDialogUpdate(widget.appName, widget.version, context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
