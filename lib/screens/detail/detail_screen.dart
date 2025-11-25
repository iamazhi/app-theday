import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/anniversary_model.dart';
import '../../services/date_calculator.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.item});

  final AnniversaryModel item;

  @override
  Widget build(BuildContext context) {
    final calc = DateCalculator(item);
    final badge = calc.badge();

    return Scaffold(
      appBar: AppBar(
        title: const Text('纪念日详情'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text(DateFormat.yMMMMd().format(item.date)),
                    const SizedBox(height: 16),
                    Chip(
                      label: Text(badge.text),
                      backgroundColor: badge.background,
                      labelStyle: TextStyle(color: badge.foreground),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('提醒设置', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ListTile(
              title: Text(item.reminder.enabled ? '已开启' : '未开启'),
              subtitle: Text('提前 ${item.reminder.daysBefore} 天 • ${TimeOfDay(hour: item.reminder.hour, minute: item.reminder.minute).format(context)}'),
            ),
          ],
        ),
      ),
    );
  }
}

