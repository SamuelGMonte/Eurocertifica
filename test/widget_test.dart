// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:eurocertifica_web/features/learning/data/datasources/course_seed.dart';
import 'package:eurocertifica_web/features/learning/data/repositories/shared_preferences_learning_repository.dart';
import 'package:eurocertifica_web/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Setup
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = SharedPreferencesLearningRepository(
      preferences: preferences,
      courseSeed: CourseSeed(),
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(EurocertificaApp(repository: repository));

    // Verify that the app is built
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
