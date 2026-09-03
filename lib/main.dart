import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_booking/constants/app_colors.dart';
import 'package:ride_booking/routes/app_routes.dart';
import 'package:ride_booking/routes/route_names.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: RouteNames.login,
      onGenerateRoute: AppRoutes.generateRoute,
      theme: ThemeData(textTheme: rideSwiftTextTheme),
      home: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
