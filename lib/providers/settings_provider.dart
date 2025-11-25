import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/anniversary_model.dart';
import '../repositories/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

final defaultReminderProvider = FutureProvider<ReminderSetting>((ref) async {
  final repo = ref.read(settingsRepositoryProvider);
  return repo.loadDefaultReminder();
});

