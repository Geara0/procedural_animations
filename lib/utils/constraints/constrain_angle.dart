part of 'constraints_utils.dart';

/// constrain angle to be within a certain range of the anchor
num constrainAngle({
  required num angle,
  required num anchor,
  required num constraint,
}) {
  final delta = _simplifyAngle(anchor - angle);
  if (delta.abs() <= constraint) return angle;

  if (delta > constraint) return (anchor - constraint);

  return (anchor + constraint);
}

num _simplifyAngle(num angle) {
  angle = angle ~/ 2 * pi;
  if (angle < 0) angle += 2 * pi;
  return angle;
}

num _toDegrees(num angle) {
  return angle * 180 / pi;
}
