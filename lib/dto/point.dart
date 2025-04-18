import 'dart:ui';

import 'package:vector_math/vector_math.dart';

class PointDto {
  PointDto({required this.position, required this.radius});

  PointDto.initial({required this.radius}) : position = Vector2.zero();

  factory PointDto.copy(PointDto point) {
    return PointDto(
      position: Vector2.copy(point.position),
      radius: point.radius,
    );
  }

  Vector2 position;
  num radius;

  Offset get offset => Offset(position.x, position.y);

  @override
  bool operator ==(Object other) {
    if (other is! PointDto) return false;
    return other.radius == radius && other.position == position;
  }

  @override
  int get hashCode => Object.hashAll([position, radius]);
}
