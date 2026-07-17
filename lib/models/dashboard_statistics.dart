import 'emulator.dart';

class DashboardStatistics {
  const DashboardStatistics({
    required this.installed,
    required this.running,
    required this.favorites,
    required this.booting,
  });

  final int installed;
  final int running;
  final int favorites;
  final int booting;

  factory DashboardStatistics.fromEmulators(List<Emulator> emulators) {
    return DashboardStatistics(
      installed: emulators.length,
      running: emulators.where((item) => item.status == EmulatorStatus.running).length,
      favorites: emulators.where((item) => item.isFavorite).length,
      booting: emulators.where((item) => item.status == EmulatorStatus.booting).length,
    );
  }
}
