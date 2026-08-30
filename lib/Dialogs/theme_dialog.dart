import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:note_app/Themes/theme_provider.dart';

class ThemeDialog extends StatelessWidget {
  const ThemeDialog({super.key});

  Widget _themeOption(
    BuildContext context, {
    required ThemeProvider provider,
    required String label,
    required String value,
    required IconData icon,
    required bool isSelected,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
          color: isSelected ? colorScheme.primary : null,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_rounded, color: colorScheme.primary)
          : null,
      onTap: () {
        provider.changeTheme(value);
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, ThemeProvider provider, _) {
        final themeMode = provider.currentTheme;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          icon: const Icon(Icons.palette_outlined, size: 28),
          title: const Text(
            'Theme Mode',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          contentPadding: const EdgeInsets.only(top: 16, bottom: 8),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _themeOption(
                context,
                provider: provider,
                label: 'Light',
                value: 'light',
                icon: Icons.light_mode_rounded,
                isSelected: themeMode == 'light',
              ),
              _themeOption(
                context,
                provider: provider,
                label: 'Dark',
                value: 'dark',
                icon: Icons.dark_mode_rounded,
                isSelected: themeMode == 'dark',
              ),
              _themeOption(
                context,
                provider: provider,
                label: 'System default',
                value: 'system',
                icon: Icons.brightness_auto_rounded,
                isSelected: themeMode == 'system',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

