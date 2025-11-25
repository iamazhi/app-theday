import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/anniversary_provider.dart';
import '../../routes/app_routes.dart';
import 'widgets/anniversary_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final anniversaries = ref.watch(anniversaryListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('纪念日'),
      ),
      body: anniversaries.when(
        data: (items) => items.isEmpty
            ? const _EmptyState()
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (_, index) {
                  final item = items[index];
                  return AnniversaryCard(
                    item: item,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.detail,
                      arguments: item,
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('加载失败：$error'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addEdit),
        icon: const Icon(Icons.add),
        label: const Text('添加'),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_available, size: 72, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            '还没有纪念日',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '点击右下角添加你的第一条记录',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

