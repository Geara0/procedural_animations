import 'package:flutter/material.dart';
import 'package:procedural_animations/global/global_variables.dart';
import 'package:procedural_animations/routes.dart';
import 'package:procedural_animations/widgets/destination_widget.dart';

class SelectorPage extends StatelessWidget {
  const SelectorPage({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(routeNames[path]!)),
      body: GridView(
        reverse: true,
        padding: EdgeInsets.all(GlobalUi.padding),
        gridDelegate: GlobalUi.gridDelegate,
        children: [
          for (final route in routeNesting[path]!)
            Destination(title: routeNames[route]!, path: route),
        ],
      ),
    );
  }
}
