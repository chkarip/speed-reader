// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:speed_reader/main.dart';

void main() {
  testWidgets('Speed Reader App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SpeedReaderApp());

    // Verify that our app has the correct title.
    expect(find.text('Speed Reader'), findsOneWidget);
    expect(find.text('Play'), findsOneWidget);

    // Tap the play button and trigger a frame.
    await tester.tap(find.text('Play'));
    await tester.pump();

    // Verify that the button text changes to 'Pause'.
    expect(find.text('Pause'), findsOneWidget);
  });
}
