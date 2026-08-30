class NoteData {
  final int? id;
  final String title;
  final String body;
  final String date;
  final String color;

  const NoteData({
    this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.color,
  });

  NoteData copyWith({
    int? id,
    String? title,
    String? body,
    String? date,
    String? color,
  }) {
    return NoteData(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      date: date ?? this.date,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'body': body,
      'date': date,
      'color': color,
    };
  }

  factory NoteData.fromMap(Map<String, dynamic> map) {
    return NoteData(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      date: map['date'] as String? ?? '',
      color: map['color'] as String? ?? 'default',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          body == other.body &&
          date == other.date &&
          color == other.color;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      body.hashCode ^
      date.hashCode ^
      color.hashCode;

  @override
  String toString() =>
      'NoteData(id: $id, title: $title, date: $date, color: $color)';
}

