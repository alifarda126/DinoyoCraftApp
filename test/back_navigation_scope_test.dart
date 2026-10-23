import 'package:dinoyocraftmobile/core/widgets/app_back_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DoubleBackExitScope Tests', () {
    testWidgets('Single back press shows exit toast and does not exit', (tester) async {
      bool exited = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoubleBackExitScope(
              onExit: () => exited = true,
              child: const Center(child: Text('Home Screen')),
            ),
          ),
        ),
      );

      expect(find.text('Home Screen'), findsOneWidget);
      expect(find.text('Tekan sekali lagi untuk keluar'), findsNothing);
      expect(exited, isFalse);

      // Simulate Android back gesture / back button press
      final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));
      await widgetsAppState.didPopRoute();
      await tester.pumpAndSettle();

      // Toast is displayed
      expect(find.text('Tekan sekali lagi untuk keluar'), findsOneWidget);
      // App did not exit on 1st back press
      expect(exited, isFalse);
    });

    testWidgets('Double back press within 2 seconds triggers exit', (tester) async {
      bool exited = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoubleBackExitScope(
              onExit: () => exited = true,
              child: const Center(child: Text('Root Screen')),
            ),
          ),
        ),
      );

      final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));

      // 1st back press
      await widgetsAppState.didPopRoute();
      await tester.pump();
      expect(exited, isFalse);
      expect(find.text('Tekan sekali lagi untuk keluar'), findsOneWidget);

      // 2nd back press 500ms later
      await tester.pump(const Duration(milliseconds: 500));
      await widgetsAppState.didPopRoute();
      await tester.pumpAndSettle();

      // Successfully exited!
      expect(exited, isTrue);
    });

    testWidgets('Back press after timer expires requires double press again', (tester) async {
      bool exited = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoubleBackExitScope(
              onExit: () => exited = true,
              exitDuration: const Duration(seconds: 2),
              child: const Center(child: Text('Root Screen')),
            ),
          ),
        ),
      );

      final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));

      // 1st press
      await widgetsAppState.didPopRoute();
      await tester.pump();
      expect(exited, isFalse);
      expect(find.text('Tekan sekali lagi untuk keluar'), findsOneWidget);

      // Wait 2.5 seconds (timer expires and toast fades out)
      await tester.pump(const Duration(milliseconds: 2500));
      await tester.pumpAndSettle();

      // Toast is gone
      expect(find.text('Tekan sekali lagi untuk keluar'), findsNothing);

      // Press again -> acts as 1st press again
      await widgetsAppState.didPopRoute();
      await tester.pump();
      expect(exited, isFalse);
      expect(find.text('Tekan sekali lagi untuk keluar'), findsOneWidget);
    });
  });

  group('AppBackScope Tests', () {
    testWidgets('AppBackScope executes onBack callback when back gesture received', (tester) async {
      bool backInvoked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppBackScope(
              onBack: () => backInvoked = true,
              child: const Center(child: Text('Auth Screen')),
            ),
          ),
        ),
      );

      final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));
      await widgetsAppState.didPopRoute();
      await tester.pumpAndSettle();

      expect(backInvoked, isTrue);
    });
  });
}
