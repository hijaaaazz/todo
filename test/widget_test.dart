import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tudu/main.dart';
import 'package:tudu/service_locator.dart';

import 'firbase_mock.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    FirebasePlatform.instance = FakeFirebaseCore(); // ✅ Correct
    initializeDependencies(); // If needed for DI setup
  });

  testWidgets('MyApp loads', (WidgetTester tester) async {
    await Firebase.initializeApp(); // Will now use FakeFirebaseCore

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.byType(MyApp), findsOneWidget);
  });
}
