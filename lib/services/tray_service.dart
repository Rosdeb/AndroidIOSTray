import 'dart:io';

import 'package:flutter/services.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class AppTrayService with TrayListener, WindowListener {
  Future<void> initialize({
    required Future<void> Function() onRefresh,
    required Future<void> Function() onExit,
  }) async {
    if (!Platform.isWindows) {
      return;
    }
    windowManager.addListener(this);
    trayManager.addListener(this);
    try {
      await trayManager.setIcon('windows/runner/resources/app_icon.ico');
      await trayManager.setToolTip('Android Emulator Manager');
      await trayManager.setContextMenu(
        Menu(
          items: <MenuItem>[
            MenuItem(key: 'open', label: 'Open Manager'),
            MenuItem(key: 'refresh', label: 'Refresh'),
            MenuItem.separator(),
            MenuItem(key: 'exit', label: 'Exit'),
          ],
        ),
      );
    } on PlatformException {
      return;
    }
    _onRefresh = onRefresh;
    _onExit = onExit;
  }

  Future<void> dispose() async {
    if (!Platform.isWindows) {
      return;
    }
    trayManager.removeListener(this);
    windowManager.removeListener(this);
  }

  Future<void> Function()? _onRefresh;
  Future<void> Function()? _onExit;

  @override
  void onTrayIconMouseDown() {
    windowManager.show();
    windowManager.focus();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case 'open':
        windowManager.show();
        windowManager.focus();
      case 'refresh':
        _onRefresh?.call();
      case 'exit':
        _onExit?.call();
    }
  }
}
