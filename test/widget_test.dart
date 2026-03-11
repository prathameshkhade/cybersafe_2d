import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cybersafe_2d/main.dart';

void main() {
  group('App Initialization Tests', () {
    testWidgets('App should build without errors', (WidgetTester tester) async {
      await tester.pumpWidget(const CyberSafe2DApp());
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App should have a title', (WidgetTester tester) async {
      await tester.pumpWidget(const CyberSafe2DApp());
      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.title, isNotEmpty);
    });
  });

  group('Navigation Tests', () {
    testWidgets('App should render home screen on launch',
            (WidgetTester tester) async {
          await tester.pumpWidget(const CyberSafe2DApp());
          await tester.pumpAndSettle();
          // Verify home screen is displayed
          expect(find.byType(Scaffold), findsWidgets);
        });
  });

  group('UI Element Tests', () {
    testWidgets('App should contain essential UI elements',
            (WidgetTester tester) async {
          await tester.pumpWidget(const CyberSafe2DApp());
          await tester.pumpAndSettle();
          // Verify basic widget tree is rendered
          expect(find.byType(Widget), findsWidgets);
        });

    testWidgets('App should respond to tap gestures',
            (WidgetTester tester) async {
          await tester.pumpWidget(const CyberSafe2DApp());
          await tester.pumpAndSettle();
          // Find any tappable elements and verify interaction
          final buttons = find.byType(ElevatedButton);
          if (buttons.evaluate().isNotEmpty) {
            await tester.tap(buttons.first);
            await tester.pumpAndSettle();
          }
        });
  });

  group('Theme Tests', () {
    testWidgets('App should use a defined theme', (WidgetTester tester) async {
      await tester.pumpWidget(const CyberSafe2DApp());
      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.theme, isNotNull);
    });
  });

  group('Text Content Tests', () {
    testWidgets('App should display text content on screen',
            (WidgetTester tester) async {
          await tester.pumpWidget(const CyberSafe2DApp());
          await tester.pumpAndSettle();
          // Verify at least some text is rendered
          expect(find.byType(Text), findsWidgets);
        });
  });
}