import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:net_speed_test/screens/home_screen.dart';
import 'package:net_speed_test/services/speed_test_service.dart';
import 'package:mocktail/mocktail.dart';

class MockSpeedTestService extends Mock implements SpeedTestService {}

void main() {
  late MockSpeedTestService mockService;

  setUp(() {
    mockService = MockSpeedTestService();
    when(() => mockService.state).thenReturn(TestState.idle);
    when(() => mockService.details).thenReturn(NetworkDetails.empty());
    when(() => mockService.progress).thenReturn(0.0);
    when(() => mockService.downloadSpeed).thenReturn(0.0);
    when(() => mockService.uploadSpeed).thenReturn(0.0);
    when(() => mockService.ping).thenReturn(0);
    when(() => mockService.downloadPing).thenReturn(0);
    when(() => mockService.uploadPing).thenReturn(0);
    when(() => mockService.currentLiveSpeed).thenReturn(0.0);
  });

  Widget createWidgetUnderTest(Size size) {
    return MaterialApp(
      home: Scaffold(
        body: MediaQuery(
          data: MediaQueryData(size: size),
          child: ChangeNotifierProvider<SpeedTestService>.value(
            value: mockService,
            child: const HomeScreen(),
          ),
        ),
      ),
    );
  }

  group('Responsive Layout Tests', () {
    testWidgets('renders mobile layout (width < 800)', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(600, 800);
      tester.view.devicePixelRatio = 1.0;
      
      await tester.pumpWidget(createWidgetUnderTest(const Size(600, 800)));
      
      // Should find the top nav items (brand and trailing)
      expect(find.text('NET Speed Test'), findsWidgets);
      
      // Reset view to default
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    });

    testWidgets('renders desktop layout (width >= 800)', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      
      await tester.pumpWidget(createWidgetUnderTest(const Size(1200, 800)));
      
      // In desktop, it renders an interactive desktop navbar, and a Row instead of Column for main layout
      expect(find.text('NET Speed Test'), findsWidgets);
      
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    });
  });
}
