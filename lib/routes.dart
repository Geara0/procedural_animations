import 'package:procedural_animations/pages/constraints/basic_distance_page.dart';
import 'package:procedural_animations/pages/constraints/constraints_page.dart';
import 'package:procedural_animations/pages/constraints/distance_constraint_chain.dart';
import 'package:procedural_animations/pages/home_page.dart';

final routes = {
  HomePage.path: (context) => HomePage(),
  ConstraintsPage.path: (context) => ConstraintsPage(),
  BasicDistancePage.path: (context) => BasicDistancePage(),
  DistanceConstraintChain.path: (context) => DistanceConstraintChain(),
};

const routeNames = {
  HomePage.path: 'Home',
  ConstraintsPage.path: 'Constraints',
  BasicDistancePage.path: 'Basic distance',
  DistanceConstraintChain.path: 'Distance constraint chain',
};

const routeNesting = {
  HomePage.path: [ConstraintsPage.path],
  ConstraintsPage.path: [BasicDistancePage.path, DistanceConstraintChain.path],
};
