import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/chat_fab.dart';
import '../../core/widgets/dc_bottom_nav.dart';

class MainShell extends StatelessWidget {
  const MainShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final index = navigationShell.currentIndex;
    final showFab = index != 4; // sembunyikan FAB di tab Bantuan

    return Scaffold(
      // extendBody: true agar konten bisa di-scroll di bawah navbar blur
      extendBody: true,
      body: navigationShell,
      floatingActionButton: showFab ? const ChatFab() : null,
      // Posisi FAB di kanan bawah — Flutter otomatis beri jarak dari BottomBar
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: DcBottomNav(
        currentIndex: index,
        onTap: (i) => navigationShell.goBranch(
          i,
          initialLocation: i == navigationShell.currentIndex,
        ),
      ),
    );
  }
}
