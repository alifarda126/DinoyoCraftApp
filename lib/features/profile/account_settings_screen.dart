import 'package:flutter/material.dart';

import 'alamat_screen.dart';
import 'data_diri_screen.dart';
import 'pengaturan_screen.dart';

enum AccountScreenType { profile, address, settings }

/// Dispatcher untuk rute lama (/profile/edit, /addresses, /settings).
/// Implementasi tiap tipe kini ada di screen masing-masing.
class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key, required this.type});

  final AccountScreenType type;

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      AccountScreenType.profile => const DataDiriScreen(),
      AccountScreenType.address => const AlamatScreen(),
      AccountScreenType.settings => const PengaturanScreen(),
    };
  }
}
