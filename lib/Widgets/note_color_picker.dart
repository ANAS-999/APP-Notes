import 'package:flutter/material.dart';
import '../Funcs/func.dart';

class NoteColorPicker extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onColorSelected;

  const NoteColorPicker({
    super.key,
    required this.selectedIndex,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer.withValues(alpha: 0.85),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Color:',
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: noteColors.length,
                itemBuilder: (context, index) {
                  final item = noteColors[index];
                  final isSelected = index == selectedIndex;
                  final chipColor = isDark ? item.darkColor : item.lightColor;

                  return GestureDetector(
                    onTap: () => onColorSelected(index),
                    child: Container(
                      width: 36,
                      height: 36,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: chipColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? item.accentColor
                              : colorScheme.outlineVariant.withValues(alpha: 0.5),
                          width: isSelected ? 2.5 : 1,
                        ),
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check_rounded,
                              size: 20,
                              color: item.accentColor,
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
