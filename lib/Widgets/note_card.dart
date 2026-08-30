import 'package:flutter/material.dart';
import 'package:note_app/Data/note_data.dart';
import '../Funcs/func.dart';

class NoteCard extends StatelessWidget {
  final NoteData note;
  final bool isSelected;
  final bool inSelectMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final ValueChanged<bool?>? onSelectChanged;

  const NoteCard({
    super.key,
    required this.note,
    required this.isSelected,
    required this.inSelectMode,
    required this.onTap,
    required this.onLongPress,
    this.onSelectChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final Color cardBackground = getNoteSurfaceColor(context, note.color);
    final Color accentColor = getNoteAccentColor(context, note.color);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outlineVariant.withValues(alpha: 0.35),
            width: isSelected ? 2.5 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //! Accent indicator dot
                    Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.only(top: 5, right: 12),
                      decoration: BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                      ),
                    ),

                    //! Title & Body
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.title.capitalize(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (note.body.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              note.body,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    //! Checkbox in select mode
                    if (inSelectMode)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Checkbox(
                          value: isSelected,
                          onChanged: onSelectChanged,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 12),

                //! Date & info footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      formatNoteDate(note.date),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
