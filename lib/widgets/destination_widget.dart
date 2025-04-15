import 'package:flutter/material.dart';
import 'package:procedural_animations/global/global_variables.dart';

class Destination extends StatelessWidget {
  const Destination({super.key, required this.title, required this.path});

  final String title;
  final String path;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(GlobalUi.smallPadding),
        child: InkWell(
          onTap: () => Navigator.of(context).pushNamed(path),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextTheme.of(context).labelMedium,
            ),
          ),
        ),
      ),
    );
  }
}
