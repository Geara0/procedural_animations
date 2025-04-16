import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:procedural_animations/dto/point.dart';
import 'package:procedural_animations/extensions/offset_extension.dart';
import 'package:procedural_animations/utils/constraints/constraints_utils.dart';
import 'package:procedural_animations/widgets/stack_canvas_widget.dart';
import 'package:vector_math/vector_math.dart';

class FABRIKChainPage extends StatefulWidget {
  static const path = 'fabrik_chain_page';

  const FABRIKChainPage({super.key});

  @override
  State<FABRIKChainPage> createState() => _FABRIKChainPageState();
}

class _FABRIKChainPageState extends State<FABRIKChainPage> {
  static const _count = 10;
  static const _distanceConstraint = 20;

  late List<PointDto> _points;
  late Vector2 _center;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _points = List.generate(_count, (i) {
      final size = MediaQuery.sizeOf(context);
      _center = Vector2(size.width / 2, size.height / 2);
      return PointDto(position: Vector2(_center.x, _center.y), radius: 5);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    return StackCanvas(
      path: FABRIKChainPage.path,
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
                shape: BoxShape.circle,
                color: colorScheme.tertiary,
              ),
            ),
          ),
      ],
    );
  }

  void _onHover(PointerHoverEvent event) {
    setState(() {
      // pull towards mouse as usual
      _points[0].position = event.localPosition.vector;
      for (var i = 1; i < _points.length; i++) {
        _points[i].position = constrainDistance(
          point: _points[i].position,
          anchor: _points[i - 1].position,
          distance: _distanceConstraint,
        );
      }

      // reverse pull back to center
      _points.last.position = _center;
      for (var i = _points.length - 1; i > 0; i--) {
        _points[i - 1].position = constrainDistance(
          point: _points[i - 1].position,
          anchor: _points[i].position,
          distance: _distanceConstraint,
        );
      }
    });
  }
}
