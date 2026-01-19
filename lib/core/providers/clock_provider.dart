import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final clockProvider = StreamProvider<DateTime>((ref) {
  final controller = StreamController<DateTime>();

  controller.add(DateTime.now());

  final timer = Timer.periodic(const Duration(seconds: 30), (_) {
    controller.add(DateTime.now());
  });

  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });

  return controller.stream;
});
