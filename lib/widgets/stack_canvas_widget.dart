import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:procedural_animations/routes.dart';

class StackCanvas extends StatelessWidget {
  StackCanvas({
    super.key,
    required this.path,
    required this.onHover,
    required this.children,
  }) : assert(routeNames.containsKey(path));

  final String path;
  final PointerHoverEventListener onHover;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(routeNames[path]!)),
      body: MouseRegion(onHover: onHover, child: Stack(children: children)),
    );
  }
}
