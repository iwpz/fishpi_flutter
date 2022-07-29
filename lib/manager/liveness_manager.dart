import 'dart:async';

import 'package:fishpi_flutter/api/api.dart';
import 'package:fishpi_flutter/manager/eventbus_manager.dart';
import 'package:flutter/material.dart';

class LivenessManager {
  static Timer? liveTimer;
  static double currentLiveness = 0;
  static void startUpdateLiveness() async {
    var res = await Api.getLiveness();
    currentLiveness = double.parse((res['liveness'] / 100.0).toString());
    eventBus.fire(OnLivenessUpdate(currentLiveness));
    liveTimer = Timer.periodic(const Duration(seconds: 35), (timer) async {
      var ress = await Api.getLiveness();
      currentLiveness = double.parse((ress['liveness'] / 100.0).toString());
      eventBus.fire(OnLivenessUpdate(currentLiveness));
      if (ress['liveness'] == 100) {
        stopUpdateLiveness();
      }
    });
  }

  static void stopUpdateLiveness() {
    if (liveTimer != null || liveTimer!.isActive) {
      liveTimer!.cancel();
    }
  }
}
