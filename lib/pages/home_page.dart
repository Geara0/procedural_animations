import 'package:flutter/material.dart';
import 'package:procedural_animations/pages/selector_page.dart';

class HomePage extends StatelessWidget {
  static const path = 'home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SelectorPage(path: path);
  }
}
