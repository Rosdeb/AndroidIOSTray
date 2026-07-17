import 'dart:io';

import 'package:path/path.dart' as p;

import '../core/utils/platform_paths.dart';
import '../models/android_sdk.dart';

class AndroidSdkDetectionService {
  Future<List<AndroidSdk>> detect({String? preferredPath}) async {
    final candidates = <String>{
      if (preferredPath != null && preferredPath.trim().isNotEmpty) preferredPath,
      ...PlatformPaths.androidSdkCandidates(),
    };

    final sdks = <AndroidSdk>[];
    for (final candidate in candidates) {
      final sdk = await validate(candidate);
      if (sdk != null) {
        sdks.add(sdk);
      }
    }
    return sdks;
  }

  Future<AndroidSdk?> validate(String sdkPath) async {
    final emulatorPath = p.join(sdkPath, 'emulator', Platform.isWindows ? 'emulator.exe' : 'emulator');
    final adbPath = p.join(sdkPath, 'platform-tools', Platform.isWindows ? 'adb.exe' : 'adb');
    if (!await File(emulatorPath).exists() || !await File(adbPath).exists()) {
      return null;
    }

    return AndroidSdk(path: sdkPath, emulatorPath: emulatorPath, adbPath: adbPath);
  }
}
