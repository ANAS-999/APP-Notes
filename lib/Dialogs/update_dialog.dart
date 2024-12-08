import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluid_dialog/fluid_dialog.dart';

import '../Funcs/func.dart';

class UpdateDialog extends StatefulWidget {
  final dynamic data;
  final String version;
  final String appName;
  const UpdateDialog(
      {super.key,
      required this.appName,
      required this.version,
      required this.data});

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  bool isLoading = true;
  bool isUpdated = false;
  String newVersion = '';
  String newVersionLink = '';
  final String api = 'anas-apps-api.vercel.app';

  @override
  void initState() {
    super.initState();

    if (widget.data == Null) {
      checkUpdate();
    } else {
      getUpdate();
    }
  }

  getUpdate() {
    setState(() {
      isLoading = false;
      newVersion = widget.data['version'];
      newVersionLink = widget.data['link'];
      isUpdated = newVersion == widget.version;
    });
  }

/*   onDownload() async {
    final ref = FirebaseDatabase.instance.ref();
    final link = await ref.child('${widget.appName}/link').get();

    if (link.exists) {
      if (!await launchUrl(Uri.parse(link.value.toString()),
          mode: LaunchMode.externalApplication)) {
        if (!mounted) return;
        DialogNavigator.of(context).close();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Something is wrong. Try again later"),
        ));
      }
    } else {
      if (!mounted) return;
      DialogNavigator.of(context).close();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something is wrong. Try again later"),
      ));
    }
  } */

  onDownload() async {
    if (!isUpdated) {
      if (!await launchUrl(Uri.parse(newVersionLink),
          mode: LaunchMode.externalApplication)) {
        if (!mounted) return;
        DialogNavigator.of(context).close();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Something is wrong. Try again later"),
        ));
      }
    } else {
      if (!mounted) return;
      DialogNavigator.of(context).close();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something is wrong. Try again later"),
      ));
    }
  }

  checkUpdate() async {
    setState(() {
      isLoading = true;
    });

    try {
      final appName = widget.appName.toLowerCase().replaceAll(' ', '_');

      final url = Uri.https(api, '/app/$appName');
      final response = jsonDecode((await http.get(url)).body);
      final data = response['data'];

      setState(() {
        isLoading = false;
        newVersion = data['version'];
        newVersionLink = data['link'];
        isUpdated = newVersion == widget.version;
      });
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Could not connect to server!'),
        ));
      } else {
        showToast('Could not connect to server!');
      }
    }
  }

/*   checkUpdate() async {
    setState(() {
      isLoading = true;
    });

    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('${widget.appName}/version').get();
    if (snapshot.exists) {
      String v = snapshot.value.toString();

      setState(() {
        newVersion = v;
        isLoading = false;
        isUpdated = v == widget.version;
      });
    } else {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "The application is not connected to our servers!",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }
 */
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: FutureBuilder(
        future: null,
        builder: (context, snapshot) {
          if (isLoading) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: const CircularProgressIndicator(),
            );
          } else if (!isUpdated) {
            return Container(
              width: 300,
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.rocket,
                        size: 54,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Update available',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'There is a new version now $newVersion',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'your version ${widget.version}',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: theme.brightness == Brightness.light
                              ? Colors.grey[700]
                              : Colors.grey,
                        ),
                  ),
                  /* const SizedBox(height: 10),
                  Text(
                    textAlign: TextAlign.center,
                    'If the new version does not work, uninstall the old version and try again',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold),
                  ), */
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      onDownload();
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 12.0,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        textStyle: const TextStyle(color: Colors.white)),
                    child: const Text(
                      'Download',
                      style: TextStyle(
                        color: Colors.white,
                        //color: Theme.of(context).textTheme.titleLarge!.color!,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.check_mark_circled,
                  color: theme.iconTheme.color,
                  size: 50,
                ),
                const SizedBox(height: 10),
                Text(
                  'Last Version ${widget.version}  ✔️',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
