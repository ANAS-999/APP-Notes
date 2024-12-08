import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:note_app/Themes/theme_provider.dart';

class ThemeDialog extends StatefulWidget {
  const ThemeDialog({super.key});

  @override
  State<ThemeDialog> createState() => _ThemeDialogState();
}

class _ThemeDialogState extends State<ThemeDialog> {
  String themeMode = 'system';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 301,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Consumer<ThemeProvider>(
          builder: (_, ThemeProvider provider, __) {
            themeMode = provider.currentTheme;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                        onPressed: () => DialogNavigator.of(context).close(),
                        splashRadius: 20,
                        icon: SvgPicture.asset(
                          'assets/icons/back.svg',
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            theme.iconTheme.color!,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Theme Mode',
                      style: theme.textTheme.titleLarge,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: 'dark',
                      groupValue: themeMode,
                      onChanged: (theme) async {
                        provider.changeTheme(theme ?? 'system');
                      },
                    ),
                    const Text('Dark'),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: 'light',
                      groupValue: themeMode,
                      onChanged: (theme) async {
                        provider.changeTheme(theme ?? 'system');
                      },
                    ),
                    const Text('Light'),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: 'system',
                      groupValue: themeMode,
                      onChanged: (theme) async {
                        provider.changeTheme(theme ?? 'system');
                      },
                    ),
                    const Text('System'),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
