import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:procedural_animations/pages/home_page.dart';

import 'routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight =
        SchedulerBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.light;

    return DynamicColorBuilder(
      builder: (light, dark) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Procedural Animations',
          themeMode: ThemeMode.system,
          theme: ThemeData(colorScheme: isLight ? light : dark),
          home: HomePage(),
          routes: routes,
        );
      },
    );
  }
}
