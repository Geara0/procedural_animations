import 'dart:async';

import 'package:flutter/material.dart';

mixin TickerStateMixin<T extends StatefulWidget> on State<T> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 20), tick);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void tick(Timer timer);
}
