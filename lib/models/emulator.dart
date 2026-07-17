enum EmulatorStatus { offline, booting, running, disconnected }

enum EmulatorDeviceType { phone, tablet, foldable, wear, tv, automotive, unknown }

class Emulator {
  const Emulator({
    required this.name,
    this.androidVersion,
    this.apiLevel,
    this.architecture,
    this.path,
    this.resolution,
    this.ram,
    this.internalStorage,
    this.snapshotEnabled,
    this.createdAt,
    this.lastUsedAt,
    this.isFavorite = false,
    this.status = EmulatorStatus.offline,
    this.deviceType = EmulatorDeviceType.unknown,
  });

  final String name;
  final String? androidVersion;
  final int? apiLevel;
  final String? architecture;
  final String? path;
  final String? resolution;
  final String? ram;
  final String? internalStorage;
  final bool? snapshotEnabled;
  final DateTime? createdAt;
  final DateTime? lastUsedAt;
  final bool isFavorite;
  final EmulatorStatus status;
  final EmulatorDeviceType deviceType;

  bool get isRunning => status == EmulatorStatus.running;
  bool get isBooting => status == EmulatorStatus.booting;

  Emulator copyWith({
    String? name,
    String? androidVersion,
    int? apiLevel,
    String? architecture,
    String? path,
    String? resolution,
    String? ram,
    String? internalStorage,
    bool? snapshotEnabled,
    DateTime? createdAt,
    DateTime? lastUsedAt,
    bool? isFavorite,
    EmulatorStatus? status,
    EmulatorDeviceType? deviceType,
  }) {
    return Emulator(
      name: name ?? this.name,
      androidVersion: androidVersion ?? this.androidVersion,
      apiLevel: apiLevel ?? this.apiLevel,
      architecture: architecture ?? this.architecture,
      path: path ?? this.path,
      resolution: resolution ?? this.resolution,
      ram: ram ?? this.ram,
      internalStorage: internalStorage ?? this.internalStorage,
      snapshotEnabled: snapshotEnabled ?? this.snapshotEnabled,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      status: status ?? this.status,
      deviceType: deviceType ?? this.deviceType,
    );
  }
}
