import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:constructor_connect/main.dart';

void main() {
  testWidgets('Home screen renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ArchieSriApp());

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
