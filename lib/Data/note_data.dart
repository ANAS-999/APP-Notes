class NoteData {
  final int? id;
  final String body;
  final String date;
  final String color;
  final String title;

  NoteData({
    this.id,
    required this.body,
    required this.date,
    required this.color,
    required this.title,
  });

  NoteData copyWith({
    int? id,
    String? body,
    String? date,
    String? color,
    String? title,
  }) {
    return NoteData(
      id: id ?? this.id,
      body: body ?? this.body,
      date: date ?? this.date,
      color: color ?? this.color,
      title: title ?? this.title,
    );
  }
}
