// Smoke test to verify the app loads without errors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:naijatax_enlighten/main.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify the app builds without errors by checking for the MaterialApp
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}