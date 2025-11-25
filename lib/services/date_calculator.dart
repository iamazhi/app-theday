import 'package:flutter/material.dart';

import '../models/anniversary_model.dart';

class DateBadge {
  const DateBadge({
    required this.text,
    required this.background,
    required this.foreground,
  });

  final String text;
  final Color background;
  final Color foreground;
}

class DateCalculator {
  DateCalculator(this.item);

  final AnniversaryModel item;

  bool get _isBirthday => item.type == AnniversaryType.birthday;

  int get daysUntil {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = _isBirthday ? _nextBirthday(today) : DateTime(item.date.year, item.date.month, item.date.day);
    return target.difference(today).inDays;
  }

  int get daysSince {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = DateTime(item.date.year, item.date.month, item.date.day);
    return today.difference(start).inDays;
  }

  DateBadge badge() {
    if (item.type == AnniversaryType.countdown || _isBirthday) {
      final remaining = daysUntil;
      if (remaining >= 0) {
        return DateBadge(
          text: '还有 $remaining 天',
          background: Colors.green.shade100,
          foreground: Colors.green.shade900,
        );
      }
      return DateBadge(
        text: '已过 ${remaining.abs()} 天',
        background: Colors.grey.shade200,
        foreground: Colors.grey.shade800,
      );
    }
    final passed = daysSince;
    return DateBadge(
      text: '已过 $passed 天',
      background: Colors.orange.shade100,
      foreground: Colors.orange.shade900,
    );
  }

  IconData iconData() {
    switch (item.type) {
      case AnniversaryType.birthday:
        return Icons.cake;
      case AnniversaryType.anniversary:
        return Icons.favorite;
      case AnniversaryType.countdown:
        return Icons.hourglass_bottom;
      case AnniversaryType.life:
        return Icons.wb_sunny;
      case AnniversaryType.work:
        return Icons.work;
    }
  }

  DateTime _nextBirthday(DateTime today) {
    var next = DateTime(today.year, item.date.month, item.date.day);
    if (next.isBefore(today)) {
      next = DateTime(today.year + 1, item.date.month, item.date.day);
    }
    if (item.date.month == 2 && item.date.day == 29 && !_isLeapYear(next.year)) {
      return DateTime(next.year, 2, 28);
    }
    return next;
  }

  bool _isLeapYear(int year) {
    if (year % 400 == 0) return true;
    if (year % 100 == 0) return false;
    return year % 4 == 0;
  }
}

