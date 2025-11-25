import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/anniversary_model.dart';
import '../repositories/anniversary_repository.dart';

final anniversaryRepositoryProvider = Provider<AnniversaryRepository>((ref) {
  return AnniversaryRepository();
});

final anniversaryListProvider = StateNotifierProvider<AnniversaryNotifier, AsyncValue<List<AnniversaryModel>>>(
  (ref) => AnniversaryNotifier(ref),
);

class AnniversaryNotifier extends StateNotifier<AsyncValue<List<AnniversaryModel>>> {
  AnniversaryNotifier(this._ref) : super(const AsyncValue.loading()) {
    _load();
  }

  final Ref _ref;

  AnniversaryRepository get _repository => _ref.read(anniversaryRepositoryProvider);

  Future<void> _load() async {
    try {
      final items = await _repository.getAll();
      state = AsyncValue.data(items);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addAnniversary(AnniversaryModel model) async {
    await _repository.insert(model);
    await _load();
  }

  Future<void> updateAnniversary(AnniversaryModel model) async {
    await _repository.update(model);
    await _load();
  }

  Future<void> deleteAnniversary(String id) async {
    await _repository.delete(id);
    await _load();
  }
}

