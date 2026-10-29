import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Data representasi perangkat nyata pengguna.
class RealDeviceInfo {
  const RealDeviceInfo({
    required this.id,
    required this.name,
    required this.details,
    required this.icon,
  });

  final String id;
  final String name;
  final String details;
  final IconData icon;
}

/// Utility pendeteksi informasi nyata perangkat yang sedang menjalankan aplikasi DinoyoCraft.
class AppDeviceManager {
  AppDeviceManager._();

  static final DeviceInfoPlugin _plugin = DeviceInfoPlugin();

  /// Mendeteksi perangkat nyata (model, merk, OS, platform) dari environment.
  static Future<RealDeviceInfo> getRealCurrentDevice() async {
    try {
      if (kIsWeb) {
        final web = await _plugin.webBrowserInfo;
        final browser = web.browserName.name.toUpperCase();
        return RealDeviceInfo(
          id: 'web_session',
          name: '$browser Web Browser',
          details: 'Web Browser • DinoyoCraft Web',
          icon: Icons.language_rounded,
        );
      }

      if (Platform.isAndroid) {
        final android = await _plugin.androidInfo;
        final brand = _capitalize(android.brand.trim());
        final model = android.model.trim();
        final release = android.version.release.isNotEmpty
            ? 'Android ${android.version.release}'
            : 'Android';

        String fullName;
        if (model.toLowerCase().contains(brand.toLowerCase())) {
          fullName = model;
        } else if (brand.isNotEmpty && model.isNotEmpty) {
          fullName = '$brand $model';
        } else if (model.isNotEmpty) {
          fullName = model;
        } else {
          fullName = 'Perangkat Android';
        }

        return RealDeviceInfo(
          id: android.id.isNotEmpty ? android.id : 'current_android',
          name: fullName,
          details: '$release • DinoyoCraft App v1.0.0',
          icon: Icons.phone_android_rounded,
        );
      }

      if (Platform.isIOS) {
        final ios = await _plugin.iosInfo;
        final name = ios.name.isNotEmpty ? ios.name : 'iPhone';
        final release = ios.systemVersion.isNotEmpty
            ? 'iOS ${ios.systemVersion}'
            : 'iOS';
        return RealDeviceInfo(
          id: ios.identifierForVendor ?? 'current_ios',
          name: name,
          details: '$release • DinoyoCraft App v1.0.0',
          icon: Icons.phone_iphone_rounded,
        );
      }

      if (Platform.isWindows) {
        final win = await _plugin.windowsInfo;
        final pcName = win.computerName.isNotEmpty
            ? win.computerName
            : 'Windows PC';
        final product = win.productName.isNotEmpty
            ? win.productName
            : 'Windows 11';
        return RealDeviceInfo(
          id: win.deviceId.isNotEmpty ? win.deviceId : 'current_windows',
          name: pcName,
          details: '$product • DinoyoCraft Desktop',
          icon: Icons.laptop_windows_rounded,
        );
      }

      if (Platform.isMacOS) {
        final mac = await _plugin.macOsInfo;
        final name = mac.computerName.isNotEmpty ? mac.computerName : 'MacBook';
        return RealDeviceInfo(
          id: mac.systemGUID ?? 'current_macos',
          name: name,
          details: 'macOS ${mac.osRelease} • DinoyoCraft App',
          icon: Icons.laptop_mac_rounded,
        );
      }

      if (Platform.isLinux) {
        final linux = await _plugin.linuxInfo;
        final name = linux.prettyName.isNotEmpty
            ? linux.prettyName
            : 'Linux PC';
        return RealDeviceInfo(
          id: linux.id.isNotEmpty ? linux.id : 'current_linux',
          name: name,
          details: 'Linux OS • DinoyoCraft App',
          icon: Icons.computer_rounded,
        );
      }
    } catch (_) {
      // Penanganan fallback bila dijalankan pada mock/test environment
    }

    final platformName = _capitalize(defaultTargetPlatform.name);
    return RealDeviceInfo(
      id: 'current_device_fallback',
      name: 'Smartphone Ini ($platformName)',
      details: 'DinoyoCraft App v1.0.0',
      icon: Icons.phone_android_rounded,
    );
  }

  static String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

