import 'dart:ui';

import 'package:vector_math/vector_math.dart';

extension Vector2Extension on Vector2 {
  Offset get offset => Offset(x, y);

  Vector2 middleWith(Vector2 e) {
    return Vector2((x + e.x) / 2, (y + e.y) / 2);
  }
}
