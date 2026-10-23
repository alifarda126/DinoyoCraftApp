import 'package:dinoyocraftmobile/core/services/photo_picker_service.dart';
import 'package:dinoyocraftmobile/core/widgets/dc_bottom_nav.dart';
import 'package:dinoyocraftmobile/core/widgets/gallery_picker_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  // Regresi overflow: sebelumnya label nav wrap banyak baris pada lebar item
  // ekstrem (mis. window di-resize sangat sempit) dan membuat Column di
  // _NavItemWidget meluap keluar tinggi bar 76px.
  testWidgets('DcBottomNav tidak overflow pada lebar layar ekstrem sempit',
      (tester) async {
    tester.view.physicalSize = const Size(90, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: DcBottomNav(
            currentIndex: 0,
            onTap: (_) {},
          ),
        ),
      ),
    );

    // Jika ada RenderFlex overflow, pumpWidget akan gagal dengan exception.
    expect(find.byType(DcBottomNav), findsOneWidget);
    expect(find.text('Beranda'), findsOneWidget);
  });

  testWidgets(
      'Sheet sumber foto menampilkan opsi Kamera & Galeri dan mengembalikan pilihan',
      (tester) async {
    ImageSource? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: FilledButton(
                onPressed: () async {
                  result = await PhotoPickerService.showSourceSheet(
                    context,
                    title: 'Pilih Sumber Foto',
                  );
                },
                child: const Text('buka'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('buka'));
    await tester.pumpAndSettle();

    // Kedua opsi sumber tampil di sheet.
    expect(find.text('Kamera'), findsOneWidget);
    expect(find.text('Galeri'), findsOneWidget);

    await tester.tap(find.text('Galeri'));
    await tester.pumpAndSettle();

    expect(result, ImageSource.gallery);
  });

  testWidgets(
      'Sheet sumber foto mengembalikan ImageSource.camera saat Kamera dipilih',
      (tester) async {
    ImageSource? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: FilledButton(
                onPressed: () async {
                  result = await PhotoPickerService.showSourceSheet(
                    context,
                    title: 'Pilih Sumber Foto',
                  );
                },
                child: const Text('buka'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('buka'));
    await tester.pumpAndSettle();

    expect(find.text('Kamera'), findsOneWidget);
    await tester.tap(find.text('Kamera'));
    await tester.pumpAndSettle();

    expect(result, ImageSource.camera);
  });

  testWidgets(
      'GalleryPickerSheet menampilkan 4 preview kolom, tombol Kamera, Galeri Sistem, dan folder selector',
      (tester) async {
    GalleryPickResult? picked;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: FilledButton(
                onPressed: () async {
                  picked = await GalleryPickerSheet.show(
                    context,
                    title: 'Kirim Foto',
                  );
                },
                child: const Text('buka_galeri'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('buka_galeri'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1400));
    await tester.pump(const Duration(milliseconds: 300));

    // Judul & tombol aksi Kamera + Galeri Sistem
    expect(find.text('Kirim Foto'), findsOneWidget);
    expect(find.text('Kamera'), findsOneWidget);
    expect(find.text('Galeri Sistem'), findsOneWidget);

    // Grid 4 kolom preview
    final gridFinder = find.byType(SliverGrid);
    expect(gridFinder, findsOneWidget);
    final grid = tester.widget<SliverGrid>(gridFinder);
    final delegate =
        grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    expect(delegate.crossAxisCount, 4);

    // Memilih foto dari preview 4 kolom
    final firstPhoto = find.byType(Image).first;
    await tester.tap(firstPhoto);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(picked, isNotNull);
  });
}

