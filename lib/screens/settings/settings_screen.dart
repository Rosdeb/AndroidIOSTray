import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(28),
      children: <Widget>[
        Text('Settings', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 20),
        _Section(
          title: 'Android SDK',
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.folder_outlined),
              title: Text(settings.sdkPath ?? 'Auto detect Android SDK'),
              subtitle: const Text('ANDROID_HOME, ANDROID_SDK_ROOT, and the default Windows SDK path are checked automatically.'),
              trailing: Wrap(
                spacing: 8,
                children: <Widget>[
                  OutlinedButton(
                    onPressed: () async {
                      final path = await FilePicker.platform.getDirectoryPath(dialogTitle: 'Select Android SDK folder');
                      if (path != null) {
                        await controller.setSdkPath(path);
                        await ref.read(emulatorControllerProvider.notifier).refresh();
                      }
                    },
                    child: const Text('Choose'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await controller.setSdkPath(null);
                      await ref.read(emulatorControllerProvider.notifier).refresh();
                    },
                    child: const Text('Auto'),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _Section(
          title: 'Appearance',
          children: <Widget>[
            SegmentedButton<ThemeMode>(
              segments: const <ButtonSegment<ThemeMode>>[
                ButtonSegment(value: ThemeMode.system, label: Text('System'), icon: Icon(Icons.brightness_auto)),
                ButtonSegment(value: ThemeMode.light, label: Text('Light'), icon: Icon(Icons.light_mode)),
                ButtonSegment(value: ThemeMode.dark, label: Text('Dark'), icon: Icon(Icons.dark_mode)),
              ],
              selected: <ThemeMode>{settings.themeMode},
              onSelectionChanged: (selection) => controller.setThemeMode(selection.first),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _Section(
          title: 'Behavior',
          children: <Widget>[
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: settings.startWithWindows,
              title: const Text('Start with Windows'),
              subtitle: const Text('Persisted setting; installer registry wiring can be enabled during packaging.'),
              onChanged: controller.setStartWithWindows,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: settings.notificationsEnabled,
              title: const Text('Notifications'),
              subtitle: const Text('Show launch and stop notifications when native toast support is configured.'),
              onChanged: (value) => controller.update(settings.copyWith(notificationsEnabled: value)),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: settings.minimizeToTray,
              title: const Text('Close button minimizes to tray'),
              subtitle: const Text('Use the tray Exit command to quit the app.'),
              onChanged: (value) => controller.update(settings.copyWith(minimizeToTray: value)),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _Section(
          title: 'Refresh',
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(Icons.timer_outlined),
                Expanded(
                  child: Slider(
                    min: 3,
                    max: 60,
                    divisions: 57,
                    label: '${settings.refreshIntervalSeconds}s',
                    value: settings.refreshIntervalSeconds.toDouble(),
                    onChanged: (value) => controller.setRefreshInterval(value.round()),
                  ),
                ),
                SizedBox(
                  width: 56,
                  child: Text('${settings.refreshIntervalSeconds}s', textAlign: TextAlign.end),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 18),
        _Section(
          title: 'About',
          children: const <Widget>[
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.info_outline),
              title: Text('Android Emulator Manager'),
              subtitle: Text('Flutter Windows desktop manager for Android Studio emulators.'),
            ),
          ],
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            ...children,
          ],
        ),
      ),
    );
  }
}
