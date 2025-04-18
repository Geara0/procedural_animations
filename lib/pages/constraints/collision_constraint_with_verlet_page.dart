import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:procedural_animations/dto/point.dart';
import 'package:procedural_animations/extensions/offset_extension.dart';
import 'package:procedural_animations/page_mixins/ticker_state_mixin.dart';
import 'package:procedural_animations/utils/constraints/constraints_utils.dart';
import 'package:procedural_animations/utils/verlet.dart';
import 'package:procedural_animations/widgets/stack_canvas_widget.dart';
import 'package:vector_math/vector_math.dart';

class CollisionConstraintWithVerletPage extends StatefulWidget {
  const CollisionConstraintWithVerletPage({super.key});

  static const path = 'collision_constrain_with_verlet';

  @override
  State<CollisionConstraintWithVerletPage> createState() =>
      _CollisionConstraintWithVerletPageState();
}

class _CollisionConstraintWithVerletPageState
    extends State<CollisionConstraintWithVerletPage>
    with TickerStateMixin {
  static const _radius = 10.0;
  static const _rowCount = 4;
  static const _colCount = 5;

  late List<PointDto> _prevPoints;
  late List<PointDto> _points;
  final _pointer = PointDto.initial(radius: 35);
  late final PointDto _container = PointDto.initial(radius: 100);
  late Vector2 _center;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.sizeOf(context);

    _center = Vector2(size.width, size.height) / 2;

    _points = [];

    for (var row = -_rowCount / 2; row < _rowCount / 2; row++) {
      for (var col = -_colCount / 2; col < _colCount / 2; col++) {
        _points.add(
          PointDto(
            position: _center + Vector2(col, row) * _radius * 2,
            radius: _radius,
          ),
        );
      }
    }

    _prevPoints = _points.map(PointDto.copy).toList();
    _container.position = _center;
  }

  @override
  Widget build(BuildContext context) {
    return StackCanvas(
      path: CollisionConstraintWithVerletPage.path,
      onHover: _onHover,
      outlinedPoints: [_pointer, _container],
      points: _points,
      children: [],
    );
  }

  void _onHover(PointerHoverEvent event) {
    setState(() {
      _pointer.position = event.localPosition.vector;

      _constrainPointer();
      _constrainContainer();
      _constrainPoints();
    });
  }

  /// push balls from other balls
  void _constrainPoints() {
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
  }

  /// push balls from mouse
  void _constrainPointer() {
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
  }

  /// push balls from container
  void _constrainContainer() {
    for (final point in _points) {
      if ((_container.position - point.position).length >
          _container.radius - point.radius) {
        point.position = constrainDistance(
          point: point.position,
          anchor: _container.position,
          distance: _container.radius - point.radius,
        );
      }
    }
  }

  @override
  void tick(Timer timer) {
    setState(() {
      for (var i = 0; i < _points.length; i++) {
        verlet(_prevPoints[i], _points[i]);

        _points[i].position.y += 1;
      }

      // must iterate to resolve all collisions so points won't be glitchy
      for (var i = 0; i < 5; i++) {
        _constrainPointer();
        _constrainPoints();
        _constrainContainer();
      }
    });
  }
}
