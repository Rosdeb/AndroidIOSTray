import 'dart:async';
import 'dart:io';

class AdbService {
  Future<List<String>> devices(String adbPath) async {
    final result = await Process.run(adbPath, const <String>['devices'], runInShell: false)
        .timeout(const Duration(seconds: 8));
    if (result.exitCode != 0) {
      throw ProcessException(adbPath, const <String>['devices'], result.stderr.toString(), result.exitCode);
    }

    return result.stdout
        .toString()
        .split(RegExp(r'\r?\n'))
        .skip(1)
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList(growable: false);
  }

  Future<String?> avdName(String adbPath, String serial) async {
    final result = await Process.run(
      adbPath,
      <String>['-s', serial, 'emu', 'avd', 'name'],
      runInShell: false,
    ).timeout(const Duration(seconds: 8));
    if (result.exitCode != 0) {
      return null;
    }
    return result.stdout.toString().split(RegExp(r'\r?\n')).first.trim();
  }

  Future<void> kill(String adbPath, String serial) async {
    await Process.run(
      adbPath,
      <String>['-s', serial, 'emu', 'kill'],
      runInShell: false,
    ).timeout(const Duration(seconds: 8));
  }
}
