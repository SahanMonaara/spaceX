import 'package:flutter/material.dart';
import '../screens/launch_details_screen.dart';
import '../screens/launches_list_screen.dart';
import '../screens/splash_screen.dart';

/// It's a map of route names to widget builders
class AppRoutes {
  static final Map<String, WidgetBuilder> _routes = {
    SplashScreen.routeName: (ctx) => const SplashScreen(),
    LaunchesListScreen.routeName: (ctx) => const LaunchesListScreen(),
    LaunchDetailScreen.routeName: (ctx) => const LaunchDetailScreen()
  };

  static get routes => _routes;
}
