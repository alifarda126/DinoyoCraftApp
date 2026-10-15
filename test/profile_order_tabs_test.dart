import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:dinoyocraftmobile/features/profile/profile_screen.dart';

Widget _app() => MaterialApp.router(
      routerConfig: GoRouter(
        initialLocation: '/profile',
        routes: [
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/profile/edit',
            builder: (context, state) => const Scaffold(body: Text('edit')),
          ),
          GoRoute(
            path: '/addresses',
            builder: (context, state) => const Scaffold(body: Text('alamat')),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const Scaffold(body: Text('setting')),
          ),
          GoRoute(
            path: '/help',
            builder: (context, state) => const Scaffold(body: Text('help')),
          ),
          GoRoute(
            path: '/chat-room',
            builder: (context, state) => const Scaffold(body: Text('chat')),
          ),
          GoRoute(
            path: '/review/write',
            builder: (context, state) => const Scaffold(body: Text('ulas')),
          ),
          GoRoute(
            path: '/reviews',
            builder: (context, state) => const Scaffold(body: Text('rev')),
          ),
          GoRoute(
            path: '/product/1',
            builder: (context, state) => const Scaffold(body: Text('p1')),
          ),
          GoRoute(
            path: '/product/3',
            builder: (context, state) => const Scaffold(body: Text('p3')),
          ),
        ],
      ),
    );

void main() {
  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
  }

  testWidgets('default tab Dikemas menampilkan status Dikemas Penjual', (
    tester,
  ) async {
    await pump(tester);
    expect(find.text('Dikemas Penjual'), findsOneWidget);
    expect(find.text('Menyerahkan ke Pihak Jasa Kirim'), findsOneWidget);
    expect(find.text('Total (1 Produk):'), findsOneWidget);
  });

  testWidgets('tap tab Dikirim menampilkan kartu kurir + tombol aksi', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.text('Dikirim'));
    await tester.pumpAndSettle();
    expect(find.text('Sedang Dikirim'), findsOneWidget);
    expect(find.text('J&T Express - Reguler'), findsOneWidget);
    expect(find.text('JT92817294820'), findsOneWidget);
    expect(find.text('Total (2 Produk):'), findsOneWidget);
    expect(find.text('Lacak Resi'), findsOneWidget);
    expect(find.text('Hubungi Penjual'), findsOneWidget);
  });

  testWidgets('tap tab Diterima menampilkan 2 kartu selesai', (tester) async {
    await pump(tester);
    await tester.tap(find.text('Diterima'));
    await tester.pumpAndSettle();
    expect(find.text('Pesanan Selesai'), findsNWidgets(2));
    expect(find.text('Beri Ulasan'), findsOneWidget);
    expect(find.text('Lihat Ulasan'), findsOneWidget);
    expect(find.text('Beli Lagi'), findsNWidgets(2));
    expect(find.text('Terracotta Glaze • 1x'), findsOneWidget);
  });

  testWidgets('tombol Lihat Semua Pesanan (dashed) selalu tampil', (
    tester,
  ) async {
    await pump(tester);
    expect(find.text('Lihat Semua Pesanan'), findsOneWidget);
    await tester.tap(find.text('Dikirim'));
    await tester.pumpAndSettle();
    expect(find.text('Lihat Semua Pesanan'), findsOneWidget);
    await tester.tap(find.text('Diterima'));
    await tester.pumpAndSettle();
    expect(find.text('Lihat Semua Pesanan'), findsOneWidget);
  });
}
