import 'package:flutter/material.dart';
import '../Funcs/func.dart';

class SettingsPage extends StatelessWidget {
  final String appName;
  final String version;

  const SettingsPage({
    super.key,
    required this.appName,
    required this.version,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text(
              'Settings',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            surfaceTintColor: colorScheme.surfaceTint,
            scrolledUnderElevation: 3.0,
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const _SectionHeader(title: 'Preferences'),
                _SettingsGroupCard(
                  children: [
                    _SettingsTile(
                      icon: Icons.palette_outlined,
                      iconBackgroundColor: colorScheme.primaryContainer,
                      iconForegroundColor: colorScheme.onPrimaryContainer,
                      title: 'Theme Mode',
                      subtitle: 'Light, Dark, or System dynamic default',
                      onTap: () => showDialogTheme(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const _SectionHeader(title: 'About & Support'),
                _SettingsGroupCard(
                  children: [
                    _SettingsTile(
                      icon: Icons.info_outline_rounded,
                      iconBackgroundColor: colorScheme.secondaryContainer,
                      iconForegroundColor: colorScheme.onSecondaryContainer,
                      title: 'About App',
                      subtitle: 'Version $version • Material You',
                      onTap: () => showDialogAbout(appName, version, context),
                    ),
                    Divider(
                      height: 1,
                      indent: 68,
                      endIndent: 16,
                      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                    _SettingsTile(
                      icon: Icons.system_update_alt_rounded,
                      iconBackgroundColor: colorScheme.tertiaryContainer,
                      iconForegroundColor: colorScheme.onTertiaryContainer,
                      title: 'Check for Updates',
                      subtitle: 'Get the latest features and fixes',
                      onTap: () => showDialogUpdate(appName, version, context),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 10),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SettingsGroupCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsGroupCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.surfaceContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconForegroundColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconForegroundColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconBackgroundColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          icon,
          color: iconForegroundColor,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }
}


