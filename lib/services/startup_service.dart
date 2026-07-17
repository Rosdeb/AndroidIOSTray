import 'dart:io';

class StartupService {
  Future<void> setEnabled(bool enabled) async {
    if (!Platform.isWindows) {
      return;
    }
    // Registry startup integration is intentionally isolated until installer
    // metadata is finalized. The setting is persisted and ready for wiring.
  }
}
