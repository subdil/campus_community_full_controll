import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campusmate/main.dart';

void main() {
  testWidgets('App boots to entry screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CampusMate());
    await tester.pump(const Duration(seconds: 2));
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
