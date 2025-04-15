import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:procedural_animations/routes.dart';

class PainterCanvas extends StatelessWidget {
  PainterCanvas({
    super.key,
    required this.path,
    required this.onHover,
    required this.painter,
    this.actions,
  }) : assert(routeNames.containsKey(path));

  final String path;
  final PointerHoverEventListener onHover;
  final CustomPainter painter;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(routeNames[path]!), actions: actions),
      body: MouseRegion(
        onHover: onHover,
        child: CustomPaint(size: Size.infinite, painter: painter),
      ),
    );
  }
}
