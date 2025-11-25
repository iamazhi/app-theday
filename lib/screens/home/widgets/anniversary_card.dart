import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/anniversary_model.dart';
import '../../../services/date_calculator.dart';

class AnniversaryCard extends StatelessWidget {
  const AnniversaryCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  final AnniversaryModel item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final calc = DateCalculator(item);
    final badge = calc.badge();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: (item.colorValue != null)
                    ? Color(item.colorValue!)
                    : Theme.of(context).colorScheme.secondaryContainer,
                child: Icon(
                  calc.iconData(),
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat.yMMMMd().format(item.date),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Chip(
                label: Text(badge.text),
                backgroundColor: badge.background,
                labelStyle: TextStyle(color: badge.foreground),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

