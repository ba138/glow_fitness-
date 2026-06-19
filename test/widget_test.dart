import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:glow_fitness/main.dart';

void main() {
  testWidgets('App renders the dashboard and bottom navigation',
      (WidgetTester tester) async {
    await tester.pumpWidget(const GlowFitnessApp());
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('Glow Fitness'), findsNothing); // title not shown on screen
    expect(find.text('Home'), findsOneWidget);
    expect(find.text("Today's Session"), findsOneWidget);
  });

  testWidgets('Tapping Workouts switches tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const GlowFitnessApp());
    await tester.pump(const Duration(seconds: 2));

    await tester.tap(find.byIcon(Icons.fitness_center_rounded));
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump(const Duration(seconds: 1));

    // "Power Yoga Flow" only exists on the Workouts screen.
    expect(find.text('Power Yoga Flow'), findsOneWidget);
  });
}
