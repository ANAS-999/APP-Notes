import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:note_app/Dialogs/theme_dialog.dart';
import 'package:note_app/Dialogs/update_dialog.dart';
import 'package:note_app/Dialogs/about_dialog.dart' as about;

//! Variables
final List<Color> listColors = [
  Colors.blueAccent,
  Colors.indigoAccent,
  Colors.red,
  Colors.green.shade600,
];

//! Colors
getStrColorFromIndex(int index) {
  switch (index) {
    case 0:
      return 'blue';
    case 1:
      return 'indigo';
    case 2:
      return 'red';
    case 3:
      return 'green';

    default:
      return 'blue';
  }
}

getIndexColorFromStr(String color) {
  switch (color) {
    case 'blue':
      return 0;
    case 'indigo':
      return 1;
    case 'red':
      return 2;
    case 'green':
      return 3;

    default:
      return 0;
  }
}

//! Themes
bool isDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}

//! Widgets
Widget spaceV([double height = 8]) {
  return SizedBox(height: height);
}

Widget spaceH([double width = 8]) {
  return SizedBox(width: width);
}

//! Toast
showToast(String text) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: const Color(0xFF3A424D),
  );
}

showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
  ));
}

//! String Extension
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

//! Images
Widget showPlaceholderImage(BuildContext context) {
  final theme = Theme.of(context);

  if (theme.colorScheme.brightness == Brightness.dark) {
    return Image.asset(
      'assets/icons/anime_dark.png',
      fit: BoxFit.cover,
    );
  }

  return Image.asset(
    'assets/icons/anime_light.png',
    fit: BoxFit.cover,
  );
}

Widget showSvg(
  String name, {
  Color? color,
  double? width = 24,
  double? height = 24,
  BoxFit fit = BoxFit.contain,
}) {
  return SizedBox(
    width: width,
    height: height,
    child: SvgPicture.asset(
      'assets/icons/$name.svg',
      fit: fit,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    ),
  );
}

//! Dialogs
showDialogTheme(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => FluidDialog(
      rootPage: FluidDialogPage(
        alignment: Alignment.center,
        decoration: const BoxDecoration(color: Colors.transparent),
        builder: (context) => const ThemeDialog(),
      ),
    ),
  );
}

showDialogAbout(String appName, String version, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => FluidDialog(
      rootPage: FluidDialogPage(
        alignment: Alignment.center,
        decoration: const BoxDecoration(color: Colors.transparent),
        builder: (context) =>
            about.AboutDialog(appName: appName, version: version),
      ),
    ),
  );
}

showDialogUpdate(String appName, String version, BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => FluidDialog(
      rootPage: FluidDialogPage(
        alignment: Alignment.center,
        decoration: const BoxDecoration(color: Colors.transparent),
        builder: (context) => UpdateDialog(
          data: Null,
          appName: appName,
          version: version,
        ),
      ),
    ),
  );
}
