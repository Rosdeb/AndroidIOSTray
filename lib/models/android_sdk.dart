class AndroidSdk {
  const AndroidSdk({
    required this.path,
    required this.emulatorPath,
    required this.adbPath,
    this.version,
  });

  final String path;
  final String emulatorPath;
  final String adbPath;
  final String? version;
}
