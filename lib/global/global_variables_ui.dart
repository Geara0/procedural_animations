part of 'global_variables.dart';

abstract class GlobalUi {
  static const padding = 8.0;

  static const mediumDivider = 8.0;

  static const gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 200,
    mainAxisSpacing: GlobalUi.mediumDivider,
    crossAxisSpacing: GlobalUi.mediumDivider,
  );
}
