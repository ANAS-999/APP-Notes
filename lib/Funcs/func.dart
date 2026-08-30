import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:note_app/Dialogs/theme_dialog.dart';
import 'package:note_app/Dialogs/update_dialog.dart';
import 'package:note_app/Dialogs/about_dialog.dart' as about;

// ==========================================
// 1. Material You Harmonized Color Palettes
// ==========================================

class NoteColorItem {
  final String name;
  final Color lightColor;
  final Color darkColor;
  final Color accentColor;

  const NoteColorItem({
    required this.name,
    required this.lightColor,
    required this.darkColor,
    required this.accentColor,
  });
}

const List<NoteColorItem> noteColors = [
  NoteColorItem(
    name: 'default',
    lightColor: Color(0xFFF0F4F8),
    darkColor: Color(0xFF1E232A),
    accentColor: Color(0xFF006492),
  ),
  NoteColorItem(
    name: 'blue',
    lightColor: Color(0xFFD6E4FF),
    darkColor: Color(0xFF1B3250),
    accentColor: Color(0xFF2E63B8),
  ),
  NoteColorItem(
    name: 'purple',
    lightColor: Color(0xFFEDE0FD),
    darkColor: Color(0xFF35254D),
    accentColor: Color(0xFF7A4FBE),
  ),
  NoteColorItem(
    name: 'red',
    lightColor: Color(0xFFFFDAD6),
    darkColor: Color(0xFF412022),
    accentColor: Color(0xFFB3261E),
  ),
  NoteColorItem(
    name: 'green',
    lightColor: Color(0xFFD3EBCB),
    darkColor: Color(0xFF1F3724),
    accentColor: Color(0xFF2E7D32),
  ),
  NoteColorItem(
    name: 'amber',
    lightColor: Color(0xFFFFE7BA),
    darkColor: Color(0xFF403014),
    accentColor: Color(0xFFB57000),
  ),
  NoteColorItem(
    name: 'teal',
    lightColor: Color(0xFFCCEAEA),
    darkColor: Color(0xFF163738),
    accentColor: Color(0xFF006A6B),
  ),
];

String getStrColorFromIndex(int index) {
  if (index >= 0 && index < noteColors.length) {
    return noteColors[index].name;
  }
  return 'default';
}

int getIndexColorFromStr(String color) {
  final idx = noteColors.indexWhere((e) => e.name == color);
  return idx != -1 ? idx : 0;
}

Color getNoteSurfaceColor(BuildContext context, String color) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final idx = getIndexColorFromStr(color);
  if (idx == 0) {
    return Theme.of(context).colorScheme.surfaceContainerLow;
  }
  return isDark ? noteColors[idx].darkColor : noteColors[idx].lightColor;
}

Color getNoteAccentColor(BuildContext context, String color) {
  final idx = getIndexColorFromStr(color);
  if (idx == 0) {
    return Theme.of(context).colorScheme.primary;
  }
  return noteColors[idx].accentColor;
}

// ==========================================
// 2. Date Formatting & String Helpers
// ==========================================

String formatNoteDate(String rawDate) {
  try {
    final parsed = DateTime.parse(rawDate);
    final now = DateTime.now();
    if (parsed.year == now.year &&
        parsed.month == now.month &&
        parsed.day == now.day) {
      return DateFormat.jm().format(parsed);
    } else if (parsed.year == now.year) {
      return DateFormat('MMM d').format(parsed);
    } else {
      return DateFormat('MMM d, y').format(parsed);
    }
  } catch (_) {
    return rawDate;
  }
}

bool isDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

// ==========================================
// 3. User Feedback & Notifications
// ==========================================

void showToast(String text) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
  );
}

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
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

// ==========================================
// 4. M3 Dialog Helpers
// ==========================================

void showDialogTheme(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const ThemeDialog(),
  );
}

void showDialogAbout(String appName, String version, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => about.AboutDialog(appName: appName, version: version),
  );
}

void showDialogUpdate(String appName, String version, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => UpdateDialog(
      data: null,
      appName: appName,
      version: version,
    ),
  );
}

void showAlertDialog(
  BuildContext context, {
  required String title,
  required String content,
  required String buttonText,
  required VoidCallback onConfirm,
}) {
  final colorScheme = Theme.of(context).colorScheme;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.errorContainer,
              foregroundColor: colorScheme.onErrorContainer,
            ),
            onPressed: onConfirm,
            child: Text(buttonText),
          ),
        ],
      );
    },
  );
}


