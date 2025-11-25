import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'anniversary_model.g.dart';

@HiveType(typeId: 0)
enum AnniversaryType {
  @HiveField(0)
  birthday,
  @HiveField(1)
  anniversary,
  @HiveField(2)
  countdown,
  @HiveField(3)
  life,
  @HiveField(4)
  work,
}

@HiveType(typeId: 1)
class ReminderSetting {
  const ReminderSetting({
    this.enabled = true,
    this.daysBefore = 0,
    this.hour = 9,
    this.minute = 0,
  });

  @HiveField(0)
  final bool enabled;
  @HiveField(1)
  final int daysBefore;
  @HiveField(2)
  final int hour;
  @HiveField(3)
  final int minute;

  TimeOfDay get timeOfDay => TimeOfDay(hour: hour, minute: minute);

  ReminderSetting copyWith({
    bool? enabled,
    int? daysBefore,
    int? hour,
    int? minute,
  }) {
    return ReminderSetting(
      enabled: enabled ?? this.enabled,
      daysBefore: daysBefore ?? this.daysBefore,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }

  factory ReminderSetting.fromMap(Map<String, dynamic> map) {
    return ReminderSetting(
      enabled: map['enabled'] as bool? ?? true,
      daysBefore: map['daysBefore'] as int? ?? 0,
      hour: map['hour'] as int? ?? 9,
      minute: map['minute'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'enabled': enabled,
        'daysBefore': daysBefore,
        'hour': hour,
        'minute': minute,
      };
}

@HiveType(typeId: 2)
class AnniversaryModel {
  AnniversaryModel({
    String? id,
    required this.title,
    required this.date,
    required this.type,
    ReminderSetting? reminder,
    this.colorValue,
    this.iconName,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        reminder = reminder ?? const ReminderSetting(),
        createdAt = createdAt ?? DateTime.now();

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final DateTime date;
  @HiveField(3)
  final AnniversaryType type;
  @HiveField(4)
  final ReminderSetting reminder;
  @HiveField(5)
  final int? colorValue;
  @HiveField(6)
  final String? iconName;
  @HiveField(7)
  final DateTime createdAt;

  AnniversaryModel copyWith({
    String? id,
    String? title,
    DateTime? date,
    AnniversaryType? type,
    ReminderSetting? reminder,
    int? colorValue,
    String? iconName,
    DateTime? createdAt,
  }) {
    return AnniversaryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      type: type ?? this.type,
      reminder: reminder ?? this.reminder,
      colorValue: colorValue ?? this.colorValue,
      iconName: iconName ?? this.iconName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory AnniversaryModel.fromMap(Map<String, dynamic> map) {
    return AnniversaryModel(
      id: map['id'] as String?,
      title: map['title'] as String,
      date: DateTime.parse(map['date'] as String),
      type: AnniversaryType.values[map['type'] as int],
      reminder: ReminderSetting.fromMap(
        Map<String, dynamic>.from(map['reminder'] as Map),
      ),
      colorValue: map['colorValue'] as int?,
      iconName: map['iconName'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'date': date.toIso8601String(),
        'type': type.index,
        'reminder': reminder.toMap(),
        'colorValue': colorValue,
        'iconName': iconName,
        'createdAt': createdAt.toIso8601String(),
      };
}

