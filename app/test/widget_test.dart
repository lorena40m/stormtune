import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stormtune/main.dart';

void main() {
  testWidgets('StormTune app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const StormTuneApp());

    // Verify that the app starts without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });
} 