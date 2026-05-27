import 'package:flutter/material.dart';

class NoteModel {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String category;
  final String priority;
  final List<String> tags;
  final int colorValue;
  final List<String> imagePaths;
  final String? voicePath;
  final bool isPinned;
  final bool isFavorite;
  final bool isArchived;
  final bool isDeleted;
  final DateTime? reminderDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  NoteModel({
    required this.id,
    required this.title,
    this.subtitle = '',
    this.description = '',
    this.category = 'Personal',
    this.priority = 'Low',
    this.tags = const [],
    this.colorValue = 0xFFFFFFFF,
    this.imagePaths = const [],
    this.voicePath,
    this.isPinned = false,
    this.isFavorite = false,
    this.isArchived = false,
    this.isDeleted = false,
    this.reminderDate,
    required this.createdAt,
    required this.updatedAt,
  });

  Color get color => Color(colorValue);

  NoteModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    String? category,
    String? priority,
    List<String>? tags,
    int? colorValue,
    List<String>? imagePaths,
    String? voicePath,
    bool? isPinned,
    bool? isFavorite,
    bool? isArchived,
    bool? isDeleted,
    DateTime? reminderDate,
    bool clearReminder = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      colorValue: colorValue ?? this.colorValue,
      imagePaths: imagePaths ?? this.imagePaths,
      voicePath: voicePath ?? this.voicePath,
      isPinned: isPinned ?? this.isPinned,
      isFavorite: isFavorite ?? this.isFavorite,
      isArchived: isArchived ?? this.isArchived,
      isDeleted: isDeleted ?? this.isDeleted,
      reminderDate: clearReminder ? null : (reminderDate ?? this.reminderDate),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'category': category,
      'priority': priority,
      'tags': tags.join(','),
      'color_value': colorValue,
      'image_path': imagePaths.join('|'),
      'voice_path': voicePath,
      'is_pinned': isPinned ? 1 : 0,
      'is_favorite': isFavorite ? 1 : 0,
      'is_archived': isArchived ? 1 : 0,
      'is_deleted': isDeleted ? 1 : 0,
      'reminder_date': reminderDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as String,
      title: map['title'] as String,
      subtitle: map['subtitle'] as String? ?? '',
      description: map['description'] as String? ?? '',
      category: map['category'] as String? ?? 'Personal',
      priority: map['priority'] as String? ?? 'Low',
      tags: map['tags'] != null && (map['tags'] as String).isNotEmpty
          ? (map['tags'] as String).split(',')
          : [],
      colorValue: map['color_value'] as int? ?? 0xFFFFFFFF,
      imagePaths: map['image_path'] != null && (map['image_path'] as String).isNotEmpty
          ? (map['image_path'] as String).split('|')
          : [],
      voicePath: map['voice_path'] as String?,
      isPinned: (map['is_pinned'] as int? ?? 0) == 1,
      isFavorite: (map['is_favorite'] as int? ?? 0) == 1,
      isArchived: (map['is_archived'] as int? ?? 0) == 1,
      isDeleted: (map['is_deleted'] as int? ?? 0) == 1,
      reminderDate: map['reminder_date'] != null
          ? DateTime.parse(map['reminder_date'] as String)
          : null,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  @override
  String toString() {
    return 'NoteModel(id: $id, title: $title, category: $category, priority: $priority)';
  }
}