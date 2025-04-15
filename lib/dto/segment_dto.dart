import 'dart:math';

import 'package:procedural_animations/dto/point.dart';
import 'package:vector_math/vector_math.dart';

class SegmentDto extends PointDto {
  SegmentDto({
    required super.position,
    required super.radius,
    required this.nextDistance,
    required this.angle,
  });

  double nextDistance;
  num angle;

  @override
  int get hashCode => Object.hashAll([position, radius, nextDistance, angle]);

  @override
  bool operator ==(Object other) {
    if (other is! SegmentDto) return false;
    return (position as PointDto) == (other as PointDto) &&
        nextDistance == other.nextDistance &&
        angle == other.angle;
  }

  Vector2 get left =>
      position +
      Vector2(radius * cos(angle - pi / 2), radius * sin(angle - pi / 2));

  Vector2 get front =>
      position + Vector2(radius * cos(angle), radius * sin(angle));

  Vector2 get right =>
      position +
      Vector2(radius * cos(angle + pi / 2), radius * sin(angle + pi / 2));

  Vector2 get back =>
      position + Vector2(radius * cos(angle + pi), radius * sin(angle + pi));
}
