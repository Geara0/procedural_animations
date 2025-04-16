import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:procedural_animations/dto/segment_dto.dart';
import 'package:procedural_animations/extensions/vector2_extension.dart';
import 'package:procedural_animations/global/global_variables.dart';
import 'package:procedural_animations/utils/constraints/constraints_utils.dart';
import 'package:procedural_animations/widgets/painter_canvas_widget.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

class DistanceConstraintChain extends StatefulWidget {
  const DistanceConstraintChain({super.key});

  static const path = 'distance_constraint_chain';

  @override
  State<DistanceConstraintChain> createState() =>
      _DistanceConstraintChainState();
}

class _DistanceConstraintChainState extends State<DistanceConstraintChain> {
  static const _distanceConstraint = 15.0;
  static const _angleConstraint = pi / 4;

  late List<SegmentDto> _segments;

  void _updateSegments() {
    setState(() {
      _segments = List.generate(
        _segmentCount,
        (i) => SegmentDto(
          position: Vector2.zero(),
          radius: _getRadius(i),
          angle: 0,
          nextDistance: _distanceConstraint,
        ),
      );
    });
  }

  double _getRadius(num i) {
    if (i == 0) return 15;
    if (i == _segmentCount - 1) return 25;
    return 1 + 2 / 15 * i + 400 / 15 * i / 2 * exp(1 - i / 2);
  }

  var _showFish = true;
  var _segmentCount = 10;

  @override
  void initState() {
    super.initState();
    _updateSegments();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    return PainterCanvas(
      path: DistanceConstraintChain.path,
      onHover: _onHover,
      actions: [
        Slider(
          value: _segmentCount.toDouble(),
          min: 10,
          max: 100,
          onChanged: (value) {
            _segmentCount = value.round();
            _updateSegments();
          },
          divisions: 90,
        ),
        SizedBox(width: GlobalUi.mediumDivider),
        Switch(
          value: _showFish,
          onChanged: (value) => setState(() => _showFish = value),
        ),
        SizedBox(width: GlobalUi.padding),
      ],
      painter:
          _showFish
              ? _FishPainter(_segments, colorScheme)
              : _CirclesPainter(_segments, colorScheme.onSurface),
    );
  }

  void _onHover(PointerHoverEvent event) {
    setState(() {
      for (var i = 0; i < _segments.length; i++) {
        if (i == 0) {
          _segments[i].position = Vector2(
            event.localPosition.dx,
            event.localPosition.dy,
          );
          _segments[i].angle =
              atan2(event.localDelta.dx, -event.localDelta.dy) - pi / 2;
          continue;
        }

        _segments[i].position = constrainDistance(
          point: _segments[i].position,
          anchor: _segments[i - 1].position,
          distance: _segments[i - 1].nextDistance,
        );

        final dPos = _segments[i - 1].position - _segments[i].position;
        _segments[i].angle = constrainAngle(
          angle: atan2(dPos.x, -dPos.y) - pi / 2,
          anchor: _segments[i - 1].angle,
          constraint: _angleConstraint,
        );
      }
    });
  }
}

class _CirclesPainter extends CustomPainter {
  _CirclesPainter(this.points, this.color);

  final List<SegmentDto> points;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke;
    final frontPaint =
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point.offset, point.radius, paint);
      canvas.drawCircle(point.front.offset, 2, frontPaint);
    }
  }

  @override
  bool shouldRepaint(_CirclesPainter oldDelegate) {
    return true;
  }
}

class _FishPainter extends CustomPainter {
  _FishPainter(this.points, this.colorScheme);

  final List<SegmentDto> points;
  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = colorScheme.inversePrimary;
    final detailPaint = Paint()..color = colorScheme.primary;
    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      if (i == points.length - 1) {
        final triangle =
            Path()
              ..moveTo(point.front.x, point.front.y)
              ..lineTo(point.left.x, point.left.y)
              ..quadraticBezierTo(
                (point.front.x + point.position.x) / 2,
                (point.front.y + point.position.y) / 2,
                point.right.x,
                point.right.y,
              )
              ..close();
        canvas.drawPath(triangle, detailPaint);
        continue;
      }

      if (i == 0) {
        final head =
            Path()
              ..moveTo(points[1].left.x, points[1].left.y)
              ..quadraticBezierTo(
                points[1].front.x,
                points[1].front.y,
                points[1].right.x,
                points[1].right.y,
              );

        canvas.drawPath(head, paint);
        continue;
      }

      if (i == 1) continue;

      // this is glitchy, but i'm too lazy to fix
      final side =
          Path()
            ..moveTo(point.left.x, point.left.y)
            ..lineTo(points[i - 1].left.x, points[i - 1].left.y)
            ..lineTo(points[i - 1].right.x, points[i - 1].right.y)
            ..lineTo(point.right.x, point.right.y)
            ..close();
      canvas.drawPath(side, paint);
    }

    final point = points[1];
    canvas.drawCircle(point.left.middleWith(point.back).offset, 2, detailPaint);
    canvas.drawCircle(
      point.right.middleWith(point.back).offset,
      2,
      detailPaint,
    );
  }

  @override
  bool shouldRepaint(_FishPainter oldDelegate) {
    return true;
  }
}
