import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  final bool isError;
  final bool isLoading;
  final String message;

  const AppErrorWidget({
    super.key,
    required this.isError,
    required this.isLoading,
    this.message = 'Error loading content!',
  });

  @override
  Widget build(BuildContext context) {
    if (!isError || isLoading) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

