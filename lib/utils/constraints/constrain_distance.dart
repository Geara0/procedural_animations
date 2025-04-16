part of 'constraints_utils.dart';

Vector2 constrainDistance({
  required Vector2 point,
  required Vector2 anchor,
  required num distance,
}) {
  return ((point - anchor).normalized() * distance.toDouble()) + anchor;
}
