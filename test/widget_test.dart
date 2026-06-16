// test/widget_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:woolvision_ai/main.dart';

void main() {
  testWidgets('WoolVision AI initialization smoke test', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WoolVisionApp());

    // Since the app starts with a Splash Screen, we will simply verify
    // that the root WoolVisionApp widget mounts successfully without crashing.
    expect(find.byType(WoolVisionApp), findsOneWidget);

    // Note: If you want to test specific text or buttons on your Dashboard later,
    // you will need to use `await tester.pumpAndSettle()` to wait for the
    // splash screen animations to finish before searching for those widgets.
  });
}
