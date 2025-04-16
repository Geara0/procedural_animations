import 'dart:ui';

import 'package:vector_math/vector_math.dart';

extension OffsetExtension on Offset {
  Vector2 get vector => Vector2(dx, dy);
}
