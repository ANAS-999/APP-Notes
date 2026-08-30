import 'package:flutter/material.dart';

class AboutDialog extends StatelessWidget {
  final String appName;
  final String version;

  const AboutDialog({
    super.key,
    required this.appName,
    required this.version,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      icon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(12),
        child: Image.asset('assets/icons/logo.png'),
      ),
      title: Text(
        appName,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'v$version',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'A clean, intuitive note-taking app crafted with Material You design and local SQLite storage.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Divider(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 8),
          Text(
            'Created by ANAS',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              letterSpacing: 1.1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: [
        FilledButton.tonal(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
