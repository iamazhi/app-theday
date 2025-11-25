import 'package:hive_flutter/hive_flutter.dart';

import '../models/anniversary_model.dart';

class AnniversaryRepository {
  static const String _boxName = 'anniversaries';

  Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive
        ..registerAdapter(AnniversaryTypeAdapter())
        ..registerAdapter(ReminderSettingAdapter())
        ..registerAdapter(AnniversaryModelAdapter());
    }
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<AnniversaryModel>(_boxName);
    }
  }

  Box<AnniversaryModel> get _box => Hive.box<AnniversaryModel>(_boxName);

  Future<List<AnniversaryModel>> getAll() async {
    final items = _box.values.toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    return items;
  }

  Future<void> insert(AnniversaryModel item) async {
    await _box.put(item.id, item);
  }

  Future<void> update(AnniversaryModel item) async {
    await _box.put(item.id, item);
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}

