import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutDialog extends StatefulWidget {
  final String appName;
  final String version;

  const AboutDialog({
    super.key,
    required this.appName,
    required this.version,
  });

  @override
  State<AboutDialog> createState() => _AboutDialog();
}

class _AboutDialog extends State<AboutDialog> {
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //! Title
            Row(
              children: [
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    onPressed: () => DialogNavigator.of(context).close(),
                    splashRadius: 20,
                    icon: const Icon(CupertinoIcons.xmark, size: 20),
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  'About Us',
                  style: theme.textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 20),
            //! Image
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 65,
                  alignment: Alignment.center,
                  child: Image.asset('assets/icons/logo.png'),
                ),
              ],
            ),
            const SizedBox(height: 5),
            //! App Name
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    widget.appName,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            //! Version
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'version : ${widget.version}',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 1),
            //! By
            Container(
              alignment: Alignment.center,
              child: Text(
                'APP BY ANAS',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
