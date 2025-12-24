// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package.  For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pearant_app/main.dart';


void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AlFaseelahParentApp());

    // Wait for splash screen animation
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Verify that the app title appears
    expect(find.text('عالم الفسيلة'), findsWidgets);
  });

  testWidgets('Splash screen shows loading indicator', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AlFaseelahParentApp());

    // Verify that loading indicator is shown
    expect(find. byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('App shows splash screen elements', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AlFaseelahParentApp());

    // Verify splash screen elements
    expect(find. byIcon(Icons.spa), findsOneWidget);
    expect(find.text('تعلم • العب • انمُ'), findsOneWidget);
  });
}