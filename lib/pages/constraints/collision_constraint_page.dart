import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:procedural_animations/dto/point.dart';
import 'package:procedural_animations/extensions/offset_extension.dart';
import 'package:procedural_animations/utils/constraints/constraints_utils.dart';
import 'package:procedural_animations/widgets/stack_canvas_widget.dart';
import 'package:vector_math/vector_math.dart';

class CollisionConstraintPage extends StatefulWidget {
  const CollisionConstraintPage({super.key});

  static const path = 'collision_constraint';

  @override
  State<CollisionConstraintPage> createState() =>
      _CollisionConstraintPageState();
}

class _CollisionConstraintPageState extends State<CollisionConstraintPage> {
  static const _radius = 10;
  static const _count = 30;

  late List<PointDto> _points;
  final _pointer = PointDto.initial(radius: 35);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _points = List.generate(_count, (i) {
      final offset = _radius * 2.0 * i;
      return PointDto(position: Vector2.all(offset), radius: _radius);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    return StackCanvas(
      path: CollisionConstraintPage.path,
      onHover: _onHover,
      children: [
        for (final point in _points)
          Positioned(
            left: point.position.x - point.radius,
            top: point.position.y - point.radius,
            child: Container(
              width: point.radius * 2,
              height: point.radius * 2,
              decoration: BoxDecoration(
                color: colorScheme.tertiary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        Positioned(
          left: _pointer.position.x - _pointer.radius,
          top: _pointer.position.y - _pointer.radius,
          child: Container(
            width: _pointer.radius * 2,
            height: _pointer.radius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colorScheme.tertiary),
            ),
          ),
        ),
      ],
    );
  }

  void _onHover(PointerHoverEvent event) {
    setState(() {
      _pointer.position = event.localPosition.vector;

      // push balls from mouse
      for (final point in _points) {
        if ((_pointer.position - point.position).length <
            _pointer.radius + point.radius) {
          point.position = constrainDistance(
            point: point.position,
            anchor: _pointer.position,
            distance: _pointer.radius + point.radius,
          );
        }
      }

      // push balls from other balls
      for (var i = 0; i < _points.length; i++) {
        final a = _points[i];
        for (var j = i; j < _points.length; j++) {
          final b = _points[j];
          if ((a.position - b.position).length < a.radius + b.radius) {
            final tmp = constrainDistance(
              point: a.position,
              anchor: b.position,
              distance: a.radius + b.radius,
            );
            b.position = constrainDistance(
              point: b.position,
              anchor: a.position,
              distance: a.radius + b.radius,
            );
            a.position = tmp;
          }
        }
      }
    });
  }
}
