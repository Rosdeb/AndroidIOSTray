import '../models/android_sdk.dart';
import '../models/app_settings.dart';
import '../models/emulator.dart';
import '../services/android_sdk_detection_service.dart';
import '../services/emulator_service.dart';

class EmulatorRepository {
  EmulatorRepository({
    required this.sdkDetectionService,
    required this.emulatorService,
  });

  final AndroidSdkDetectionService sdkDetectionService;
  final EmulatorService emulatorService;

  Future<AndroidSdk?> detectSdk(AppSettings settings) async {
    final sdks = await sdkDetectionService.detect(preferredPath: settings.sdkPath);
    return sdks.isEmpty ? null : sdks.first;
  }

  Future<List<Emulator>> listEmulators({
    required AndroidSdk sdk,
    required AppSettings settings,
  }) {
    return emulatorService.listAvds(
      emulatorPath: sdk.emulatorPath,
      sdkPath: sdk.path,
      favorites: settings.favoriteEmulators,
      lastLaunchByName: settings.lastLaunchByName,
      adbPath: sdk.adbPath,
    );
  }

  Future<void> launch(AndroidSdk sdk, Emulator emulator, {bool coldBoot = false}) {
    return emulatorService.launch(
      emulatorPath: sdk.emulatorPath,
      name: emulator.name,
      options: EmulatorLaunchOptions(coldBoot: coldBoot),
    );
  }

  Future<void> stop(AndroidSdk sdk, Emulator emulator) {
    return emulatorService.stop(adbPath: sdk.adbPath, name: emulator.name);
  }
}
