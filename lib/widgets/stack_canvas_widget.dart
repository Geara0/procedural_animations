import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:procedural_animations/dto/point.dart';
import 'package:procedural_animations/routes.dart';

class StackCanvas extends StatelessWidget {
  StackCanvas({
    super.key,
    required this.path,
    required this.onHover,
    required this.children,
    this.points = const [],
    this.outlinedPoints = const [],
  }) : assert(routeNames.containsKey(path));

  final String path;
  final PointerHoverEventListener onHover;
  final List<Widget> children;
  final List<PointDto> points;
  final List<PointDto> outlinedPoints;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    for (final point in points) {
      children.add(
        _Point(
          point: point,
          decoration: BoxDecoration(
            color: colorScheme.tertiary,
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    for (final point in outlinedPoints) {
      children.add(
        _Point(
          point: point,
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.tertiary),
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(routeNames[path]!)),
      body: MouseRegion(onHover: onHover, child: Stack(children: children)),
    );
  }
}

class _Point extends StatelessWidget {
  const _Point({super.key, required this.point, required this.decoration});

  final PointDto point;
  final BoxDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: point.position.x - point.radius,
      top: point.position.y - point.radius,
      child: Container(
        width: point.radius * 2,
        height: point.radius * 2,
        decoration: decoration,
      ),
    );
  }
}
