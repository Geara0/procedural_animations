import 'dart:ui';

import 'package:vector_math/vector_math.dart';

class PointDto {
  PointDto({required this.position, required this.radius});

  PointDto.initial({required this.radius}) : position = Vector2.zero();

  Vector2 position;
  double radius;

  Offset get offset => Offset(position.x, position.y);

  @override
  bool operator ==(Object other) {
    if (other is! PointDto) return false;
    return other.radius == radius && other.position == position;
  }

  @override
  int get hashCode => Object.hashAll([position, radius]);
}
