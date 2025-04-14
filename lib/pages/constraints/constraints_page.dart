import 'package:flutter/material.dart';
import 'package:procedural_animations/pages/selector_page.dart';

class ConstraintsPage extends StatelessWidget {
  static const path = 'constraints';

  const ConstraintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SelectorPage(path: path);
  }
}
