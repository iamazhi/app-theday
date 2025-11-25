import 'package:flutter/material.dart';

import '../models/anniversary_model.dart';
import '../routes/app_routes.dart';
import '../screens/add_edit/add_edit_screen.dart';
import '../screens/detail/detail_screen.dart';
import '../screens/home/home_screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutes.addEdit:
        final AnniversaryModel? initial = settings.arguments as AnniversaryModel?;
        return MaterialPageRoute(
          builder: (_) => AddEditScreen(initial: initial),
          fullscreenDialog: true,
        );
      case AppRoutes.detail:
        final AnniversaryModel item = settings.arguments as AnniversaryModel;
        return MaterialPageRoute(builder: (_) => DetailScreen(item: item));
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}

