import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class FakeFirebaseCore extends Fake
    with MockPlatformInterfaceMixin
    implements FirebasePlatform {

  final Map<String, FirebaseAppPlatform> _fakeApps = {
    defaultFirebaseAppName: FakeFirebaseApp(),
  };

  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    final appName = name ?? defaultFirebaseAppName;
    final fakeApp = FakeFirebaseApp(name: appName, options: options);
    _fakeApps[appName] = fakeApp;
    return fakeApp;
  }

  @override
  FirebaseAppPlatform app([String name = defaultFirebaseAppName]) {
    final app = _fakeApps[name];
    if (app == null) {
      throw FirebaseException(
        plugin: 'firebase_core',
        message: 'No Firebase App named $name exists',
      );
    }
    return app;
  }

  @override
  List<FirebaseAppPlatform> get apps => _fakeApps.values.toList();
}
class FakeFirebaseApp extends Fake
    with MockPlatformInterfaceMixin
    implements FirebaseAppPlatform {

  FakeFirebaseApp({
    this.name = defaultFirebaseAppName,
    FirebaseOptions? options,
  }) : _options = options ?? const FirebaseOptions(
          apiKey: 'testKey',
          appId: '1:1234567890:android:abc123',
          messagingSenderId: '1234567890',
          projectId: 'test-project',
        );

  @override
  final String name;

  final FirebaseOptions _options;

  @override
  FirebaseOptions get options => _options;
}
