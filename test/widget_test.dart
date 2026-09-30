import 'package:flutter_test/flutter_test.dart';
import 'package:dinoyocraftmobile/main.dart';

void main() {
  testWidgets('DinoyoCraft app builds', (WidgetTester tester) async {
    await tester.pumpWidget(const DinoyoCraftApp());
    await tester.pump();
    expect(find.text('DinoyoCraft'), findsWidgets);
  });
}
