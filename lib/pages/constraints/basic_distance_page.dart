import 'package:flutter/material.dart';
import 'package:procedural_animations/routes.dart';
import 'package:vector_math/vector_math.dart';

class BasicDistancePage extends StatefulWidget {
  static const path = 'basic_distance';
  const BasicDistancePage({super.key});

  @override
  State<BasicDistancePage> createState() => _BasicDistancePageState();
}

class _BasicDistancePageState extends State<BasicDistancePage> {
  var _mousePosition = Vector2.zero();
  late var _pointPosition = _mousePosition;

  static const _radius = 50.0;
  static const _pointRadius = 10.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    final x = _mousePosition.x - _radius;
    final y = _mousePosition.y - _radius;

    return Scaffold(
      appBar: AppBar(title: Text(routeNames[BasicDistancePage.path]!)),
      body: MouseRegion(
        onHover: (event) {
          setState(() {
            _mousePosition = Vector2(
              event.localPosition.dx,
              event.localPosition.dy,
            );
            final x = _mousePosition.x;
            final y = _mousePosition.y;
            _pointPosition = _constrainDistance(
              _pointPosition,
              Vector2(x, y),
              _radius,
            );
            debugPrint(_pointPosition.toString());
          });
        },
        child: Stack(
          children: [
            Positioned(
              left: x,
              top: y,
              child: Container(
                width: _radius * 2,
                height: _radius * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colorScheme.tertiary),
                ),
              ),
            ),
            Positioned(
              left: _pointPosition.x - _pointRadius / 2,
              top: _pointPosition.y - _pointRadius / 2,
              child: Container(
                width: _pointRadius,
                height: _pointRadius,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.tertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Vector2 _constrainDistance(Vector2 point, Vector2 anchor, double distance) {
    return ((point - anchor).normalized() * distance) + anchor;
  }
}
