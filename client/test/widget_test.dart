// Smoke test: the app's root widget builds with its real local-storage
// dependencies bootstrapped (main() normally does this before runApp).

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'package:naijatax_enlighten/core/constants/app_constants.dart';
import 'package:naijatax_enlighten/main.dart';

void main() {
  setUpAll(() async {
    // main() disables runtime font fetching; mirror that in tests so no
    // HTTP is attempted.
    GoogleFonts.config.allowRuntimeFetching = false;

    // Hive.initFlutter() needs path_provider (unavailable in tests), so
    // init plain Hive against a temp directory and open the boxes the
    // theme provider and router redirect read during the first frames.
    final dir = Directory.systemTemp.createTempSync('naijatax_widget_test');
    Hive.init(dir.path);
    await Hive.openBox(AppConstants.settingsBox);
    await Hive.openBox(AppConstants.articlesBox);
    await Hive.openBox(AppConstants.taxProfileBox);
  });

  tearDownAll(() async {
    await Hive.close();
  });

  testWidgets('App loads without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    // Let the router's async redirect and auth state settle first.
    await tester.pump();
    // flutter_animate schedules a Duration.zero Future.delayed per .animate()
    // widget whenever one mounts, and each frame can mount more (route
    // redirects included), so a few short pumps are needed for the test
    // framework's "no pending timers" invariant to hold.
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
