import 'dart:io';

import 'package:path/path.dart' as p;

import '../constants/app_constants.dart';

class PlatformPaths {
  const PlatformPaths._();

  static List<String> androidSdkCandidates() {
    final env = Platform.environment;
    final candidates = <String>[
      if ((env['ANDROID_HOME'] ?? '').trim().isNotEmpty) env['ANDROID_HOME']!,
      if ((env['ANDROID_SDK_ROOT'] ?? '').trim().isNotEmpty)
        env['ANDROID_SDK_ROOT']!,
    ];

    if (Platform.isWindows) {
      final userProfile = env['USERPROFILE'];
      if (userProfile != null && userProfile.trim().isNotEmpty) {
        candidates.add(p.join(userProfile, AppConstants.defaultWindowsSdkSuffix));
      }
      final localAppData = env['LOCALAPPDATA'];
      if (localAppData != null && localAppData.trim().isNotEmpty) {
        candidates.add(p.join(localAppData, 'Android', 'Sdk'));
      }
    }

    return candidates.toSet().toList(growable: false);
  }
}
