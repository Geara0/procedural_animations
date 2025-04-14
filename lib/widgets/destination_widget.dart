import 'package:flutter/material.dart';

class Destination extends StatelessWidget {
  const Destination({super.key, required this.title, required this.path});

  final String title;
  final String path;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(path);
        },
        child: Center(child: Text(title)),
      ),
    );
  }
}
