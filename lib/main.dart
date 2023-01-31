import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_launch/common/app_providers.dart';
import 'package:spacex_launch/common/app_routes.dart';
import 'package:spacex_launch/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: MaterialApp(
        title: 'Spacex',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'bankgothic'
        ),
        routes: AppRoutes.routes,
        // home: const SplashScreen(),
        initialRoute: SplashScreen.routeName,
      ),
    );
  }
}
