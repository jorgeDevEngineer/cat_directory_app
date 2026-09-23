import 'package:flutter/material.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  final VoidCallback onResumeRevalidate;
  DateTime? _pausedAt;

  AppLifecycleObserver({required this.onResumeRevalidate});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _pausedAt = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      if (_pausedAt != null) {
        final durationInBackground = DateTime.now().difference(_pausedAt!);
        if (durationInBackground > const Duration(minutes: 5)) {
          onResumeRevalidate();
        }
      }
      _pausedAt = null;
    }
  }
}
