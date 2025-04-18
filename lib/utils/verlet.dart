import 'package:procedural_animations/dto/point.dart';
import 'package:vector_math/vector_math.dart';

void verlet(PointDto prev, PointDto curr) {
  final tmp = Vector2.copy(curr.position);
  curr.position += curr.position - prev.position;
  prev.position = tmp;
}
