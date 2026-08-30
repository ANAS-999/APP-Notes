import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../Funcs/func.dart';

class UpdateDialog extends StatefulWidget {
  final dynamic data;
  final String version;
  final String appName;

  const UpdateDialog({
    super.key,
    required this.appName,
    required this.version,
    required this.data,
  });

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
    if (widget.data == null) {
      checkUpdate();
    } else {
      getUpdate();
    }
  }

  void getUpdate() {
    setState(() {
      isLoading = false;
      newVersion = widget.data['version'] ?? '';
      newVersionLink = widget.data['link'] ?? '';
      isUpdated = newVersion == widget.version;
    });
  }

  void onDownload() async {
    if (!isUpdated && newVersionLink.isNotEmpty) {
      final uri = Uri.parse(newVersionLink);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (!mounted) return;
        Navigator.of(context).pop();
        showToast('Could not open download link');
      }
    } else {
      Navigator.of(context).pop();
    }
  }

  void checkUpdate() async {
    setState(() {
      isLoading = true;
    });

    try {
      final appName = widget.appName.toLowerCase().replaceAll(' ', '_');
      final url = Uri.https(api, '/app/$appName');
      final res = await http.get(url);
      final response = jsonDecode(res.body);
      final data = response['data'];

      if (!mounted) return;
      setState(() {
        isLoading = false;
        newVersion = data['version'] ?? '';
        newVersionLink = data['link'] ?? '';
        isUpdated = newVersion == widget.version;
      });
    } catch (_) {
      if (!mounted) return;
      Navigator.pop(context);
      showSnackBar(context, 'Could not connect to update server');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isLoading) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        content: const Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Checking for updates...'),
            ],
          ),
        ),
      );
    }

    if (!isUpdated) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        icon: Icon(
          Icons.rocket_launch_rounded,
          size: 40,
          color: colorScheme.primary,
        ),
        title: const Text(
          'Update Available',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'A newer version (v$newVersion) is available.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Current version: v${widget.version}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Later'),
          ),
          FilledButton(
            onPressed: onDownload,
            child: const Text('Download'),
          ),
        ],
      );
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      icon: Icon(
        Icons.check_circle_outline_rounded,
        size: 44,
        color: colorScheme.primary,
      ),
      title: const Text(
        'Up to date',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      content: Text(
        'You are running the latest version (v${widget.version}).',
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      actions: [
        FilledButton.tonal(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
