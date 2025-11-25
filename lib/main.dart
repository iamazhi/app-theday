import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'providers/anniversary_provider.dart';
import 'repositories/anniversary_repository.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = AnniversaryRepository();

  await repository.init();
  await NotificationService.instance.init();

  runApp(
    ProviderScope(
      overrides: [
        anniversaryRepositoryProvider.overrideWithValue(repository),
      ],
      child: const MemorialApp(),
    ),
  );
}

