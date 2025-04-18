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

class VerletRopePage extends StatefulWidget {
  const VerletRopePage({super.key});

  static const path = 'verlet_rope';

  @override
  State<VerletRopePage> createState() => _VerletRopePageState();
}

class _VerletRopePageState extends State<VerletRopePage> with TickerStateMixin {
  static const _radius = 5;

  final _rope = List.generate(20, (i) => PointDto.initial(radius: _radius));
  late final _prevRope = _rope.map(PointDto.copy).toList();
  var _pointer = Vector2.zero();

  late PointDto _container;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.sizeOf(context);
    final center = Vector2(size.width, size.height) / 2;

    _container = PointDto(position: center, radius: 100);
  }

  @override
  Widget build(BuildContext context) {
    return StackCanvas(
      path: VerletRopePage.path,
      onHover: _onHover,
      outlinedPoints: [_container],
      points: _rope,
      children: [],
    );
  }

  void _onHover(PointerHoverEvent event) {
    setState(() {
      _pointer = event.localPosition.vector;
      _rope.first.position = _pointer;

      _constrainContainer();
      _constrainRope();
    });
  }

  @override
  void tick(Timer timer) {
    setState(() {
      for (var i = 1; i < _rope.length; i++) {
        verlet(_prevRope[i], _rope[i]);

        _rope[i].position.y += 1;
      }

      // Some bouncy mess happening at the end of the rope
      // Too lazy to fix
      for (var i = 0; i < 100; i++) {
        for (var i = _rope.length - 1; i > 1; i--) {
          final curr = _rope[i];
          final next = _rope[i - 1];
          final distance = next.position - curr.position;
          if (distance.length > _radius) {
            distance.length = _radius.toDouble();
            final offset = (curr.position - next.position) - distance;
            next.position += offset / 2;
            curr.position -= offset / 2;
          }

          if ((next.position - _pointer).length > (i - 1) * _radius) {
            next.position = constrainDistance(
              point: next.position,
              anchor: _pointer,
              distance: (i + 1) * _radius,
            );
          }
        }
      }
      _constrainContainer();
      _constrainRope();
    });
  }

  void _constrainRope() {
    for (var i = 1; i < _rope.length; i++) {
      final point = _rope[i];
      point.position = constrainDistance(
        point: point.position,
        anchor: _rope[i - 1].position,
        distance: _radius,
      );
    }
  }

  void _constrainContainer() {
    for (final point in _rope) {
      if ((_container.position - point.position).length <
          _container.radius + point.radius) {
        point.position = constrainDistance(
          point: point.position,
          anchor: _container.position,
          distance: _container.radius + point.radius,
        );
      }
    }
  }
}
