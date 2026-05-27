class ReminderModel {
  final int? id;
  final String noteId;
  final String noteTitle;
  final DateTime dateTime;
  final bool isTriggered;

  ReminderModel({
    this.id,
    required this.noteId,
    this.noteTitle = '',
    required this.dateTime,
    this.isTriggered = false,
  });

  ReminderModel copyWith({
    int? id,
    String? noteId,
    String? noteTitle,
    DateTime? dateTime,
    bool? isTriggered,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      noteTitle: noteTitle ?? this.noteTitle,
      dateTime: dateTime ?? this.dateTime,
      isTriggered: isTriggered ?? this.isTriggered,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'note_id': noteId,
      'date_time': dateTime.toIso8601String(),
      'is_triggered': isTriggered ? 1 : 0,
    };
  }

  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      id: map['id'] as int?,
      noteId: map['note_id'] as String,
      dateTime: DateTime.parse(map['date_time'] as String),
      isTriggered: (map['is_triggered'] as int? ?? 0) == 1,
    );
  }
}
