import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/anniversary_model.dart';
import '../../providers/anniversary_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/notification_service.dart';

class AddEditScreen extends ConsumerStatefulWidget {
  const AddEditScreen({super.key, this.initial});

  final AnniversaryModel? initial;

  @override
  ConsumerState<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends ConsumerState<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  DateTime? _selectedDate;
  late AnniversaryType _type;
  late ReminderSetting _reminder;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initial?.title ?? '');
    _selectedDate = widget.initial?.date;
    _type = widget.initial?.type ?? AnniversaryType.anniversary;
    _reminder = widget.initial?.reminder ?? const ReminderSetting();

    if (widget.initial == null) {
      _loadDefaultReminder();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _loadDefaultReminder() async {
    try {
      final defaultReminder = await ref.read(defaultReminderProvider.future);
      if (mounted) {
        setState(() => _reminder = defaultReminder);
      }
    } catch (_) {
      // ignore, fallback to default ReminderSetting
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 50),
      lastDate: DateTime(now.year + 50),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _reminder.hour, minute: _reminder.minute),
    );
    if (picked != null) {
      setState(() {
        _reminder = _reminder.copyWith(hour: picked.hour, minute: picked.minute);
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请选择日期')));
      return;
    }

    final model = AnniversaryModel(
      id: widget.initial?.id,
      title: _titleController.text.trim(),
      date: _selectedDate!,
      type: _type,
      reminder: _reminder,
      colorValue: widget.initial?.colorValue,
      iconName: widget.initial?.iconName,
      createdAt: widget.initial?.createdAt,
    );

    final notifier = ref.read(anniversaryListProvider.notifier);
    final settingsRepo = ref.read(settingsRepositoryProvider);

    if (widget.initial == null) {
      await notifier.addAnniversary(model);
    } else {
      await notifier.updateAnniversary(model);
    }

    await NotificationService.instance.scheduleAnniversaryReminder(model);
    await settingsRepo.saveDefaultReminder(_reminder);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final dateText = _selectedDate == null ? '选择日期' : DateFormat.yMMMd().format(_selectedDate!);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initial == null ? '添加纪念日' : '编辑纪念日'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: '标题'),
                validator: (value) => value == null || value.trim().isEmpty ? '请输入标题' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(dateText),
                subtitle: _selectedDate == null ? const Text('必填') : null,
                trailing: const Icon(Icons.calendar_month),
                onTap: _pickDate,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<AnniversaryType>(
                initialValue: _type,
                decoration: const InputDecoration(labelText: '类型'),
                items: const [
                  DropdownMenuItem(value: AnniversaryType.birthday, child: Text('生日')),
                  DropdownMenuItem(value: AnniversaryType.anniversary, child: Text('纪念日')),
                  DropdownMenuItem(value: AnniversaryType.work, child: Text('工作')),
                  DropdownMenuItem(value: AnniversaryType.life, child: Text('生活')),
                  DropdownMenuItem(value: AnniversaryType.countdown, child: Text('倒数日')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _type = value);
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('开启提醒'),
                value: _reminder.enabled,
                onChanged: (value) => setState(() {
                  _reminder = _reminder.copyWith(enabled: value);
                }),
              ),
              if (_reminder.enabled) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('提前 ${_reminder.daysBefore} 天提醒'),
                  subtitle: const Text('0 表示当天'),
                  trailing: const Icon(Icons.timer),
                  onTap: () async {
                    final value = await showDialog<int>(
                      context: context,
                      builder: (context) => _DaysBeforeDialog(initial: _reminder.daysBefore),
                    );
                    if (value != null) {
                      setState(() {
                        _reminder = _reminder.copyWith(daysBefore: value);
                      });
                    }
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('提醒时间：${TimeOfDay(hour: _reminder.hour, minute: _reminder.minute).format(context)}'),
                  trailing: const Icon(Icons.access_time),
                  onTap: _pickTime,
                ),
              ],
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _save,
                child: const Text('保存'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DaysBeforeDialog extends StatefulWidget {
  const _DaysBeforeDialog({required this.initial});

  final int initial;

  @override
  State<_DaysBeforeDialog> createState() => _DaysBeforeDialogState();
}

class _DaysBeforeDialogState extends State<_DaysBeforeDialog> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initial.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('提前几天提醒'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Slider(
            min: 0,
            max: 14,
            divisions: 14,
            value: _value,
            label: '${_value.toInt()} 天',
            onChanged: (value) => setState(() => _value = value),
          ),
          Text('${_value.toInt()} 天'),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
        FilledButton(
          onPressed: () => Navigator.pop(context, _value.toInt()),
          child: const Text('确定'),
        ),
      ],
    );
  }
}

