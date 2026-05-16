import 'dart:async';

import 'package:flutter/foundation.dart';

class EditorProvider extends ChangeNotifier {
  Timer? _autosaveTimer;
  bool focusMode = false;
  bool fullscreen = false;
  String quickNotes = '';

  int wordCount(String text) => text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
  int characterCount(String text) => text.length;

  void scheduleAutosave(VoidCallback save) {
    _autosaveTimer?.cancel();
    _autosaveTimer = Timer(const Duration(milliseconds: 700), save);
  }

  void toggleFocusMode() {
    focusMode = !focusMode;
    notifyListeners();
  }

  void toggleFullscreen() {
    fullscreen = !fullscreen;
    notifyListeners();
  }

  void updateNotes(String value) {
    quickNotes = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _autosaveTimer?.cancel();
    super.dispose();
  }
}
